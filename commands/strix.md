---
description: Strix AI pentest router — preflight, auth, scan, or status
argument-hint: "[scan <target>] [status] [ci]"
---

# /strix

Load skill `strix` (`~/.grok/skills/strix/SKILL.md`).

## Route

| Args | Action |
|------|--------|
| empty / help | Preflight + short how-to + ask target |
| `status` | Same as `/strix-status` |
| `ci` | Same as `/strix-ci` |
| `scan ...` or path/URL | Same as `/strix-scan` |

Always apply authorization gate for non-local targets.
