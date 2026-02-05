# ============================
# Funções utilitárias
# ============================

function Join-AuditPath {
    param([string]$fileName)
    return Join-Path -Path $auditFolder -ChildPath $fileName
}

# Criar pasta da auditoria
$auditDate = Get-Date -Format "yyyy-MM-dd"
$auditFolder = "audit_$auditDate"
New-Item -ItemType Directory -Path $auditFolder -Force | Out-Null
Write-Host "Pasta criada: $auditFolder"

# Criar pasta reports/
$reportsFolder = Join-AuditPath "reports"
New-Item -ItemType Directory -Path $reportsFolder -Force | Out-Null

# ============================
# Ficheiros de saída
# ============================

$hardwareTxt = Join-AuditPath "hardware.txt"
$hardwareJson = Join-AuditPath "hardware.json"

$osTxt = Join-AuditPath "os.txt"
$osJson = Join-AuditPath "os.json"

$softwareTxt = Join-AuditPath "software_installed.txt"
$softwareCsv = Join-AuditPath "software_installed.csv"

$devEnvTxt = Join-AuditPath "dev_environment.txt"
$devEnvMd  = Join-AuditPath "dev_environment.md"

# ============================
# 1. Hardware
# ============================

Get-ComputerInfo | Out-File -FilePath $hardwareTxt -Encoding utf8
Get-ComputerInfo | ConvertTo-Json -Depth 10 | Out-File -FilePath $hardwareJson -Encoding utf8

# ============================
# 2. Sistema Operativo
# ============================

Get-CimInstance Win32_OperatingSystem | Out-File -FilePath $osTxt -Encoding utf8
Get-CimInstance Win32_OperatingSystem | ConvertTo-Json -Depth 10 | Out-File -FilePath $osJson -Encoding utf8

# ============================
# 3. Software Instalado
# ============================

Get-WmiObject -Class Win32_Product |
    Select-Object Name, Version |
    Out-File -FilePath $softwareTxt -Encoding utf8

Get-WmiObject -Class Win32_Product |
    Select-Object Name, Version |
    Export-Csv -Path $softwareCsv -NoTypeInformation -Encoding UTF8

# ============================
# 4. Ambiente de Desenvolvimento
# ============================

# Python
"=== Python ===" | Out-File -FilePath $devEnvTxt -Encoding utf8
python --version 2>$null | Out-File -Append -FilePath $devEnvTxt -Encoding utf8

"=== Python ===" | Out-File -FilePath $devEnvMd -Encoding utf8
python --version 2>$null | Out-File -Append -FilePath $devEnvMd -Encoding utf8

# Node.js
"=== Node.js ===" | Out-File -Append -FilePath $devEnvTxt -Encoding utf8
node --version 2>$null | Out-File -Append -FilePath $devEnvTxt -Encoding utf8

"=== Node.js ===" | Out-File -Append -FilePath $devEnvMd -Encoding utf8
node --version 2>$null | Out-File -Append -FilePath $devEnvMd -Encoding utf8

# Git
"=== Git ===" | Out-File -Append -FilePath $devEnvTxt -Encoding utf8
git --version 2>$null | Out-File -Append -FilePath $devEnvTxt -Encoding utf8

"=== Git ===" | Out-File -Append -FilePath $devEnvMd -Encoding utf8
git --version 2>$null | Out-File -Append -FilePath $devEnvMd -Encoding utf8

# Docker
"=== Docker ===" | Out-File -Append -FilePath $devEnvTxt -Encoding utf8
docker --version 2>$null | Out-File -Append -FilePath $devEnvTxt -Encoding utf8

"=== Docker ===" | Out-File -Append -FilePath $devEnvMd -Encoding utf8
docker --version 2>$null | Out-File -Append -FilePath $devEnvMd -Encoding utf8

# WSL (CORRIGIDO)
"=== WSL ===" | Out-File -Append -FilePath $devEnvTxt -Encoding utf8
wsl --status 2>$null |
    Format-List |
    Out-String |
    Out-File -Append -FilePath $devEnvTxt -Encoding utf8

"=== WSL ===" | Out-File -Append -FilePath $devEnvMd -Encoding utf8
wsl --status 2>$null |
    Format-List |
    Out-String |
    Out-File -Append -FilePath $devEnvMd -Encoding utf8

# ============================
# 5. Performance
# ============================

Get-CimInstance Win32_Processor |
    Select-Object LoadPercentage |
    Out-File -FilePath (Join-AuditPath "cpu.txt") -Encoding utf8

Get-CimInstance Win32_OperatingSystem |
    Select-Object FreePhysicalMemory, TotalVisibleMemorySize |
    Out-File -FilePath (Join-AuditPath "memory.txt") -Encoding utf8

Get-CimInstance Win32_LogicalDisk |
    Select-Object DeviceID, FreeSpace, Size |
    Out-File -FilePath (Join-AuditPath "disk.txt") -Encoding utf8

# ============================
# 6. Gerar audit_full_report.md
# ============================

$fullMd = Join-Path $reportsFolder "audit_full_report.md"

$softwareTable = (Import-Csv $softwareCsv | ForEach-Object {
    "| $($_.Name) | $($_.Version) |"
})

$osTable = (Get-CimInstance Win32_OperatingSystem | Select-Object * | Format-Table -AutoSize | Out-String)

$mdContent = @(
"# PC System Audit - $auditDate"
""
"## Índice"
"- [Hardware](#hardware)"
"- [Sistema Operativo](#sistema-operativo)"
"- [Software Instalado](#software-instalado)"
"- [Ambiente de Desenvolvimento](#ambiente-de-desenvolvimento)"
"- [Performance](#performance)"
""
"---"
""
"## Hardware"
(Get-Content $hardwareTxt)
""
"---"
""
"## Sistema Operativo"
"````"
$osTable
"````"
""
"---"
""
"## Software Instalado"
"| Nome | Versão |"
"|------|--------|"
$softwareTable
""
"---"
""
"## Ambiente de Desenvolvimento"
(Get-Content $devEnvMd)
""
"---"
""
"## Performance"
"### CPU"
(Get-Content (Join-AuditPath "cpu.txt"))
""
"### Memória"
(Get-Content (Join-AuditPath "memory.txt"))
""
"### Disco"
(Get-Content (Join-AuditPath "disk.txt"))
""
"---"
)

[System.IO.File]::WriteAllLines(
    $fullMd,
    $mdContent,
    (New-Object System.Text.UTF8Encoding($false))
)

# ============================
# 7. Gerar audit_full_report.txt
# ============================

$fullTxt = Join-Path $reportsFolder "audit_full_report.txt"

$txtContent = @(
"PC System Audit - $auditDate"
""
"===================="
"Hardware"
"===================="
(Get-Content $hardwareTxt)
""
"===================="
"Sistema Operativo"
"===================="
(Get-Content $osTxt)
""
"===================="
"Software Instalado"
"===================="
(Get-Content $softwareTxt)
""
"===================="
"Ambiente de Desenvolvimento"
"===================="
(Get-Content $devEnvTxt)
""
"===================="
"Performance"
"===================="
"CPU:"
(Get-Content (Join-AuditPath "cpu.txt"))
""
"Memória:"
(Get-Content (Join-AuditPath "memory.txt"))
""
"Disco:"
(Get-Content (Join-AuditPath "disk.txt"))
)

[System.IO.File]::WriteAllLines(
    $fullTxt,
    $txtContent,
    (New-Object System.Text.UTF8Encoding($false))
)

# ============================
# 8. Git Push Automático
# ============================

if (Test-Path ".git") {
    $changes = git status --porcelain

    if ($changes) {
        git add .
        git commit -m "Audit $auditDate"
        git push
        Write-Host "Alterações enviadas para o repositório."
    }
    else {
        Write-Host "Nenhuma alteração para enviar."
    }
}
else {
    Write-Host "Este diretório não é um repositório Git."
}