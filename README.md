# PC System Audit
Ferramenta automática de auditoria ao Windows. Recolhe hardware, software, sistema operativo, apps da Store, ambiente de desenvolvimento e performance. ## Gera relatórios completos, mantém histórico por data e integra com Git/GitHub.
## Auditorias realizadas
(Atualizado automaticamente pelo script.)
- [Parece que o resultado não era seguro para mostrar. Vamos alterar tudo e tentar outra coisa!]
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
├── hardware.*
├── os.*
├── software_installed.*
├── software_store_apps.csv
├── dev_environment.txt
├── performance_snapshot.txt
├── audit_full_report.txt
└── audit_full_report.md
## Sobre o script
- Totalmente automático
- Repetível
- Não apaga auditorias anteriores
- Fácil de estender
## Requisitos
- Windows 10+
- PowerShell 5.1 ou 7+
- Git configurado
- Python, Node, Docker, WSL (opcionais)
## Autor
Projeto criado por Ivan Almeida (DigitALLtogether).