---
description: Run Strix AI pentest on a local path or authorized URL
argument-hint: "<path|url> [--quick] [--instruction \"...\"] [-n]"
---

# /strix-scan

1. Read skill `strix` fully (preflight + auth + command build).
2. Parse `$ARGUMENTS` → target, optional `--quick`, `--instruction`, `--diff-base`, `-n`.
3. **Auth gate** if target is a public URL.
4. Preflight Docker + `strix` + LLM env.
5. Build and run `strix` command (prefer `-n`).
6. Summarize `strix_runs/` when finished.

Default target if none: `.` (current project) after confirming.
