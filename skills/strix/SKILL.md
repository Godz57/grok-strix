---
name: strix
description: >
  Orchestrate the Strix open-source AI pentesting CLI from Grok: preflight
  (Docker, strix, LLM env), authorization gate, build safe strix commands,
  run scans on owned/authorized targets only, summarize strix_runs/ results.
  Use when user says strix, /strix, /strix-scan, autonomous AI pentest with PoC,
  or deep validated security scan beyond static review. NEVER scan unauthorized
  third-party systems. Does not reimplement Strix.
metadata:
  short-description: "Run Strix AI pentest (wrapper)"
  author: "Grok wrapper for usestrix/strix"
---

# strix (Grok wrapper)

You **orchestrate** the external [Strix](https://github.com/usestrix/strix) CLI.  
You do **not** reimplement its multi-agent pentest engine.

Announce: `Using Strix wrapper — authorized targets only.`

## Hard rules

1. **Authorization first** for any network target that is not clearly local:
   - OK with user nod: `localhost`, `127.0.0.1`, `::1`, path `./` or local dir
   - Public URL / remote IP → user must confirm **ownership or written auth**
   - Ambiguous / “hack this site” → **refuse**; offer `/pentest-whitebox` or local path
2. **No third-party attacks.** Ever.
3. Prefer **non-interactive** (`-n`) when running unattended / long scans so the session can capture output.
4. Prefer **staging / local** over production; warn hard before production.
5. After scan: summarize findings; do not dump secrets; recommend rotation if secrets appear.
6. Offensive depth is Strix’s job inside Docker — still only on authorized targets.

## Preflight (always before first scan in session)

Run checks (shell):

```bash
# Docker
docker info >/dev/null 2>&1 && echo DOCKER_OK || echo DOCKER_FAIL

# Strix CLI
command -v strix >/dev/null 2>&1 && strix --help >/dev/null 2>&1 && echo STRIX_OK || echo STRIX_FAIL

# Env (do not print secret values)
[ -n "$LLM_API_KEY" ] || [ -n "$OPENAI_API_KEY" ] || [ -n "$ANTHROPIC_API_KEY" ] && echo KEY_MAYBE || echo KEY_UNSET
[ -n "$STRIX_LLM" ] && echo "STRIX_LLM=$STRIX_LLM" || echo STRIX_LLM_UNSET
```

Windows PowerShell equivalents:

```powershell
docker info 2>$null; if ($LASTEXITCODE -eq 0) { "DOCKER_OK" } else { "DOCKER_FAIL" }
Get-Command strix -ErrorAction SilentlyContinue | Out-Null; if ($?) { "STRIX_OK" } else { "STRIX_FAIL" }
if ($env:LLM_API_KEY -or $env:OPENAI_API_KEY -or $env:ANTHROPIC_API_KEY) { "KEY_MAYBE" } else { "KEY_UNSET" }
if ($env:STRIX_LLM) { "STRIX_LLM=$env:STRIX_LLM" } else { "STRIX_LLM_UNSET" }
```

Also note if `~/.strix/cli-config.json` exists (config may already be saved).

### If preflight fails

| Failure | Tell user |
|---------|-----------|
| DOCKER_FAIL | Start Docker Desktop / engine |
| STRIX_FAIL | Install: `curl -sSL https://strix.ai/install | bash` — see https://docs.strix.ai |
| KEY / STRIX_LLM unset | `export STRIX_LLM=...` and `export LLM_API_KEY=...` (or provider-specific) |

Do **not** invent results if Strix cannot run.

## Build the command

Base patterns (from upstream docs):

```bash
# Local codebase
strix -n --target ./path --scan-mode standard

# Quick / CI-ish
strix -n --target ./ --scan-mode quick

# PR diff scope
strix -n --target ./ --scan-mode quick --scope-mode diff --diff-base origin/main

# Deployed app (authorized only)
strix -n --target https://staging.example.com

# With focus
strix -n --target ./app --instruction "Focus on IDOR and auth bypass"

# Instruction file
strix -n --target ./app --instruction-file ./roe.md

# Multi-target
strix -n -t ./app -t https://staging.example.com
```

Map user flags:

| User says | CLI |
|-----------|-----|
| quick / ci / pr | `--scan-mode quick` (+ diff if PR) |
| deep / full | `--scan-mode standard` (or omit if default) |
| instruction text | `--instruction "..."` |
| headless default | always prefer `-n` unless user wants interactive TUI |
| interactive | omit `-n` and warn it needs a real terminal |

Working directory: project root when target is `.` or `./`.

## Run

1. Show the exact command to the user (redact API keys if any leaked into args — keys should be env only).  
2. Confirm auth for non-local targets once.  
3. Execute via shell with long timeout expectation (scans can take many minutes).  
4. Stream/capture output; note exit code (non-zero often means vulns found in CI mode).  

Results default location (upstream): **`strix_runs/<run-name>/`** under cwd.

## After run — summarize

1. List newest dir under `strix_runs/`  
2. Read reports / JSON / markdown present there  
3. Produce:

```markdown
## Strix summary
- Target:
- Mode:
- Run path: strix_runs/...
- Exit code:

### Findings (by severity)
...

### PoCs / evidence
(short; no full secrets)

### Recommended fixes
(prioritized; offer tdd/craftsman for implementation)

### Next
- retest after fix
- optional /pentest-whitebox for static gaps Strix skipped
```

## When to prefer grok-pentest instead

- No Docker / no Strix install  
- Want cheap static OWASP checklist only  
- User only has source, no time/budget for agentic scan  

Say so and route to `/pentest-whitebox`.

## Integration

- Fix phase: `tdd`, `code-craftsman` (if ON), `verify-done`  
- Do not auto-open PRs or force-push  
- Do not run Strix against production without explicit user acceptance of risk  
