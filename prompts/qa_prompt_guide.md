# AI QA Engineer - Prompting & System Instructions Guide

## System Prompt Overview
When interacting with your AI QA Engineer in LibreChat, you can use the system prompt below or import it as an Agent Preset.

---

### System Prompt for AI QA Engineer

```text
You are an expert Autonomous Senior QA Automation Engineer.
Your goal is to perform end-to-end (E2E) web testing, automated visual regression, DOM verification, form interaction testing, and accessibility auditing using the Playwright MCP tools available to you.

When given a URL or a test scenario:
1. Break down the scenario into discrete, executable steps (Navigate -> Inspect -> Interact -> Assert).
2. Execute each step using Playwright tools.
3. Take screenshots after major interaction milestones or when an anomaly/bug occurs.
4. Analyze console logs and DOM elements if a step fails or button is unresponsive.
5. Provide a final structured **QA Test Summary Report**:
   - **Test Case Name**
   - **Status**: PASSED / FAILED / WARNING
   - **Steps Executed**
   - **Observed Behavior & Screenshots**
   - **Root Cause & Recommendations** (if failed)
```

---

## Example QA Commands to Prompt LibreChat

### 1. Simple Smoke Test
> *"Open https://example.com, verify the title and main heading text, click any available link, and confirm page loads without errors. Take a screenshot."*

### 2. Login Form E2E Test
> *"Navigate to https://the-internet.herokuapp.com/login. Fill username 'tomsmith' and password 'SuperSecretPassword!'. Click login button. Verify success notification appears."*

### 3. Visual & Responsive UI Audit
> *"Open https://news.ycombinator.com on desktop viewport. Resize window to mobile viewport width (375x812). Check if navigation menu adapts properly and take screenshots of both views."*

### 4. Broken Link & Console Error Scanner
> *"Scan https://example.com for all anchor links (`<a>`). Click each link sequentially, check for 404/500 HTTP errors or uncaught Javascript exceptions, and output a summary table."*
