# Grok Strix — wrapper Grok para o Strix AI pentest

> Integração leve do [usestrix/strix](https://github.com/usestrix/strix) no **Grok Build**.  
> **Não reimplementa** o Strix: checa pré-requisitos, monta o comando, exige autorização e resume `strix_runs/`.

Strix = agentes de pentest autônomos (Docker + LLM + PoC real).  
Este kit = **como chamar o Strix com segurança a partir do Grok**.

## Legal

Só alvos que você **possui** ou tem **autorização escrita**.  
Alvo público ambíguo → o agente **recusa** e pede confirmação.

## O que é / não é

| É | Não é |
|---|--------|
| Skill + slash commands | Fork do Strix |
| Auth gate + preflight Docker/CLI | Multi-agent ofensivo reescrito |
| Orquestra `strix` no terminal | Substitui grok-pentest |
| Resume findings de `strix_runs/` | SaaS app.strix.ai |

## Pré-requisitos (na sua máquina)

1. **Docker** rodando  
2. **Strix CLI** instalado: `curl -sSL https://strix.ai/install | bash` (ou docs oficiais)  
3. **LLM API key** do provider escolhido  

```bash
export STRIX_LLM="openai/gpt-5.4"   # ou anthropic/..., etc.
export LLM_API_KEY="..."
# opcional: LLM_API_BASE, PERPLEXITY_API_KEY, STRIX_REASONING_EFFORT
```

Config costuma ir para `~/.strix/cli-config.json` após o primeiro run.

## Install (wrapper Grok)

```powershell
cd grok-strix
.\scripts\install.ps1
```

```bash
./scripts/install.sh
```

## Uso no Grok

```
/strix                    # router + preflight
/strix-scan ./            # white-box no diretório
/strix-scan https://staging.meusite.com
/strix-ci                 # comando headless sugerido pra PR
/strix-status             # docker / strix / env / últimos runs
```

Exemplos:

```
/strix-scan . --quick
/strix-scan https://localhost:3000 --instruction "foco em IDOR e auth"
/strix-scan . -n --scan-mode quick --scope-mode diff --diff-base origin/main
```

## Fluxo recomendado com os outros kits

```
1. /pentest-whitebox          (rápido, barato)
2. /strix-scan ./ ou staging  (PoC profundo, custa tokens + Docker)
3. Fix com craftsman + tdd
4. /verify-done
```

## Companions

| Kit | Papel |
|-----|--------|
| [grok-pentest](https://github.com/Godz57/grok-pentest) | Playbooks OWASP + scripts vibe code |
| [grok-superpowers](https://github.com/Godz57/grok-superpowers) | Processo de eng |
| [grok-craftsman](https://github.com/Godz57/grok-craftsman) | Qualidade always-on |
| [grok-loops](https://github.com/Godz57/grok-loops) | Loops autônomos |
| **Strix** (upstream) | https://github.com/usestrix/strix |

## Docs oficiais Strix

- https://docs.strix.ai  
- https://strix.ai  

## License

MIT (wrapper). Strix em si é **Apache-2.0** no repositório upstream.
