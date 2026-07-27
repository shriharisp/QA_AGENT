import express from 'express';
import { SSEServerTransport } from '@modelcontextprotocol/sdk/server/sse.js';
import { spawn } from 'child_process';

const app = express();
const PORT = process.env.PORT || 8931;

// Store active transport sessions
const activeSessions = new Map();

app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'playwright-mcp-sse' });
});

app.get('/sse', async (req, res) => {
  console.log('[Playwright MCP] New SSE client connected');

  const transport = new SSEServerTransport('/message', res);
  const sessionId = transport.sessionId;

  // Launch Playwright MCP stdio process
  const mcpProcess = spawn('npx', ['-y', '@modelcontextprotocol/server-playwright'], {
    stdio: ['pipe', 'pipe', 'inherit']
  });

  activeSessions.set(sessionId, { transport, process: mcpProcess });

  mcpProcess.stdout.on('data', (data) => {
    try {
      const lines = data.toString().split('\n').filter(l => l.trim());
      for (const line of lines) {
        const json = JSON.parse(line);
        transport.send(json);
      }
    } catch (e) {
      // Raw string format fallback
    }
  });

  mcpProcess.on('exit', (code) => {
    console.log(`[Playwright MCP] Process exited with code ${code}`);
    activeSessions.delete(sessionId);
  });

  req.on('close', () => {
    console.log(`[Playwright MCP] Client disconnected: ${sessionId}`);
    mcpProcess.kill();
    activeSessions.delete(sessionId);
  });

  await transport.start();
});

app.post('/message', express.json(), async (req, res) => {
  const sessionId = req.query.sessionId;
  const session = activeSessions.get(sessionId);

  if (!session) {
    return res.status(404).send('Session not found');
  }

  try {
    const payload = JSON.stringify(req.body) + '\n';
    session.process.stdin.write(payload);
    res.status(202).send('Accepted');
  } catch (err) {
    console.error('[Playwright MCP] Error writing to process:', err);
    res.status(500).send(err.message);
  }
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Playwright MCP Server listening on http://0.0.0.0:${PORT}`);
  console.log(`   SSE Endpoint: http://localhost:${PORT}/sse`);
});
