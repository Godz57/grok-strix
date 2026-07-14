---
description: Print or run a headless Strix command suitable for CI/PR
argument-hint: "[--run] [--diff-base origin/main]"
---

# /strix-ci

1. Preflight (Docker, strix, env).
2. Propose workflow snippet + local command:

```bash
strix -n --target ./ --scan-mode quick --scope-mode diff --diff-base origin/main
```

3. If `$ARGUMENTS` contains `--run` and user confirms env is ready → execute in repo root.
4. Explain: non-zero exit may mean vulnerabilities found (useful as CI gate).
5. Remind: set `STRIX_LLM` and `LLM_API_KEY` as CI secrets; checkout with `fetch-depth: 0` for diffs.

Do not commit secrets. Optional: write `.github/workflows/strix-penetration-test.yml` **only if user asks**.
