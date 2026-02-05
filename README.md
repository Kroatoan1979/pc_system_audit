# PC System Audit
Ferramenta automÃ¡tica de auditoria ao Windows. Recolhe hardware, software, sistema operativo, apps da Store, ambiente de desenvolvimento e performance. ## Gera relatÃ³rios completos, mantÃ©m histÃ³rico por data e integra com Git/GitHub.
## Auditorias realizadas
- [2026-02-05](audit_2026-02-05/)
- [2026-02-05](audit_2026-02-05/)
- [2026-02-05](audit_2026-02-05/)
- [2026-02-05](audit_2026-02-05/)
- [2026-02-05](audit_2026-02-05/)
- [2026-02-05](audit_2026-02-05/)
- [2026-02-05](audit_2026-02-05/)
(Atualizado automaticamente pelo script.)
- [Parece que o resultado nÃ£o era seguro para mostrar. Vamos alterar tudo e tentar outra coisa!]
## Como executar
Na raiz do projeto, correr:
.\run_audit.ps1
O script:
- Cria audit_YYYY-MM-DD/
- Recolhe hardware, OS, software, Store apps, dev environment e performance
- Gera audit_full_report.txt e audit_full_report.md
- Atualiza o README
- Executa git add, git commit e git push
## Estrutura da auditoria
audit_YYYY-MM-DD/
â”œâ”€â”€ hardware.*
â”œâ”€â”€ os.*
â”œâ”€â”€ software_installed.*
â”œâ”€â”€ software_store_apps.csv
â”œâ”€â”€ dev_environment.txt
â”œâ”€â”€ performance_snapshot.txt
â”œâ”€â”€ audit_full_report.txt
â””â”€â”€ audit_full_report.md
## Sobre o script
- Totalmente automÃ¡tico
- RepetÃ­vel
- NÃ£o apaga auditorias anteriores
- FÃ¡cil de estender
## Requisitos
- Windows 10+
- PowerShell 5.1 ou 7+
- Git configurado
- Python, Node, Docker, WSL (opcionais)
## Autor
Projeto criado por Ivan Almeida (DigitALLtogether).
