---
description: Check Docker, Strix CLI, LLM env, and recent strix_runs
---

# /strix-status

1. Run preflight checks from skill `strix` (Docker, strix, env vars, `~/.strix/cli-config.json`).
2. List recent `strix_runs/` under cwd if present (name + mtime).
3. Report table:

```
Docker: OK | FAIL
Strix CLI: OK | missing
STRIX_LLM: set | unset
API key env: set | unset
Config file: ~/.strix/cli-config.json yes/no
Recent runs: ...
```

4. If something missing, print install/config one-liners from README (docs.strix.ai).
