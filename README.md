# 📘 PC System Audit  
Auditoria técnica completa ao ambiente pessoal de desenvolvimento de **Ivan Almeida**.

Este repositório contém um conjunto de ficheiros gerados automaticamente através de comandos PowerShell, com o objetivo de documentar de forma clara e versionada:

- Hardware do sistema  
- Sistema operativo e respetiva configuração  
- Software instalado  
- Ambiente de desenvolvimento  
- Estado geral de performance no momento da auditoria  

O objetivo é manter um **histórico evolutivo** do ambiente de trabalho, permitindo comparações ao longo do tempo, reprodutibilidade e diagnóstico mais rápido de alterações ou problemas.

---

## 🎯 Objetivos do Projeto

- Criar um **snapshot técnico completo** do PC pessoal.  
- Manter a auditoria **versionada em Git**, permitindo histórico e comparação.  
- Facilitar a **recriação do ambiente** noutro equipamento, se necessário.  
- Suportar boas práticas de documentação e governança técnica.  
- Servir como referência para o desenvolvimento do **DAT‑PAM** e outros projetos.

---

## 📁 Estrutura do Repositório

Estrutura base dos ficheiros deste repositório:

/audit_2026-02-05/  
&nbsp;&nbsp;&nbsp;&nbsp;hardware.txt  
&nbsp;&nbsp;&nbsp;&nbsp;hardware.json  
&nbsp;&nbsp;&nbsp;&nbsp;os.txt  
&nbsp;&nbsp;&nbsp;&nbsp;os.json  
&nbsp;&nbsp;&nbsp;&nbsp;software_installed.csv  
&nbsp;&nbsp;&nbsp;&nbsp;dev_environment.txt  
&nbsp;&nbsp;&nbsp;&nbsp;performance_snapshot.txt  

README.md

### Descrição dos ficheiros

| Ficheiro | Conteúdo |
|----------|----------|
| **hardware.txt / hardware.json** | Informações detalhadas sobre CPU, RAM, discos, GPU, motherboard, rede |
| **os.txt / os.json** | Versão do Windows, build, data de instalação, updates, features |
| **software_installed.csv** | Lista completa de software instalado (Win32 + Store) |
| **dev_environment.txt** | Versões de Python, Git, Docker, WSL, ferramentas de desenvolvimento |
| **performance_snapshot.txt** | Estado momentâneo de performance (CPU, RAM, processos principais) |

---

## 🛠️ Como gerar a auditoria

A auditoria é gerada através de um conjunto de comandos PowerShell executados manualmente ou via script.

O processo segue estes passos:

1. Recolha de informações de hardware  
2. Recolha de informações do sistema operativo  
3. Listagem de software instalado  
4. Recolha do ambiente de desenvolvimento  
5. Snapshot de performance  
6. Commit e push para o GitHub  

Cada secção é executada manualmente, passo a passo, para garantir aprendizagem e controlo total.

---

## 🔄 Atualizações Futuras

Sempre que houver:

- Instalação de novo software  
- Atualização relevante do Windows  
- Alteração de hardware  
- Mudança no ambiente de desenvolvimento  

basta repetir os comandos e fazer um novo commit, criando assim um histórico evolutivo.

---

## 👤 Autor

**Ivan Almeida**  
Repositório pessoal de auditoria técnica.  
Criado com o apoio do Copilot (Kodi), em modo colaborativo e iterativo.