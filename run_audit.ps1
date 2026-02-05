<#
run_audit.ps1
Auditoria completa do sistema:
- Cria pasta audit_YYYY-MM-DD
- Recolhe hardware, OS, software, dev environment, performance
- Gera relatorio consolidado TXT + MD
- Atualiza README com link para a auditoria
- Faz git add / commit / push automatico
#>

# ============================
# 1. Preparacao e pasta da auditoria
# ============================

$date = Get-Date -Format 'yyyy-MM-dd'
$auditFolder = "audit_$date"

Write-Host "=== PC SYSTEM AUDIT ==="
Write-Host "Data da auditoria: $date"
Write-Host "Pasta da auditoria: $auditFolder"
Write-Host ""

if (-not (Test-Path $auditFolder)) {
    New-Item -ItemType Directory -Path $auditFolder | Out-Null
    Write-Host "Pasta criada: $auditFolder"
} else {
    Write-Host "Pasta ja existe: $auditFolder (os ficheiros poderao ser sobrescritos)"
}

# Helper para construir caminhos dentro da pasta
function Join-AuditPath {
    param([string]$name)
    return Join-Path $auditFolder $name
}

# ============================
# 2. Recolha de Hardware
# ============================

$hardwareTxt = Join-AuditPath "hardware.txt"
$hardwareJson = Join-AuditPath "hardware.json"

Get-ComputerInfo | Out-File -FilePath $hardwareTxt -Encoding utf8
Get-ComputerInfo | ConvertTo-Json -Depth 10 | Out-File -FilePath $hardwareJson -Encoding utf8

# ============================
# 3. Recolha do Sistema Operativo
# ============================

$osTxt = Join-AuditPath "os.txt"
$osJson = Join-AuditPath "os.json"

Get-CimInstance Win32_OperatingSystem | Out-File -FilePath $osTxt -Encoding utf8
Get-CimInstance Win32_OperatingSystem | ConvertTo-Json -Depth 10 | Out-File -FilePath $osJson -Encoding utf8

# ============================
# 4. Software Instalado
# ============================

$softwareTxt = Join-AuditPath "software_installed.txt"
$softwareCsv = Join-AuditPath "software_installed.csv"

Get-WmiObject -Class Win32_Product | Select-Object Name, Version | Out-File -FilePath $softwareTxt -Encoding utf8
Get-WmiObject -Class Win32_Product | Select-Object Name, Version | Export-Csv -Path $softwareCsv -NoTypeInformation -Encoding UTF8

# ============================
# 5. Ambiente de Desenvolvimento
# ============================

$devEnvTxt = Join-AuditPath "dev_environment.txt"

"=== Python ===" | Out-File -FilePath $devEnvTxt -Encoding utf8
python --version 2>$null | Out-String | Out-File -Append -FilePath $devEnvTxt -Encoding utf8

"=== Node.js ===" | Out-File -Append -FilePath $devEnvTxt -Encoding utf8
node --version 2>$null | Out-String | Out-File -Append -FilePath $devEnvTxt -Encoding utf8

"=== Git ===" | Out-File -Append -FilePath $devEnvTxt -Encoding utf8
git --version 2>$null | Out-String | Out-File -Append -FilePath $devEnvTxt -Encoding utf8

"=== Docker ===" | Out-File -Append -FilePath $devEnvTxt -Encoding utf8
docker --version 2>$null | Out-String | Out-File -Append -FilePath $devEnvTxt -Encoding utf8

"=== WSL ===" | Out-File -Append -FilePath $devEnvTxt -Encoding utf8
wsl --status 2>$null |
    Format-List |
    Out-String |
    Out-File -Append -FilePath $devEnvTxt -Encoding utf8

# ============================
# 6. Performance Snapshot
# ============================

$perfTxt = Join-AuditPath "performance_snapshot.txt"

"=== CPU ===" | Out-File -FilePath $perfTxt -Encoding utf8
Get-CimInstance Win32_Processor |
    Select-Object LoadPercentage |
    Format-Table |
    Out-String |
    Out-File -Append -FilePath $perfTxt -Encoding utf8

"=== Memoria ===" | Out-File -Append -FilePath $perfTxt -Encoding utf8
Get-CimInstance Win32_OperatingSystem |
    Select-Object FreePhysicalMemory, TotalVisibleMemorySize |
    Format-Table |
    Out-String |
    Out-File -Append -FilePath $perfTxt -Encoding utf8

"=== Disco ===" | Out-File -Append -FilePath $perfTxt -Encoding utf8
Get-CimInstance Win32_LogicalDisk |
    Select-Object DeviceID, FreeSpace, Size |
    Format-Table |
    Out-String |
    Out-File -Append -FilePath $perfTxt -Encoding utf8

# ============================
# 7. Relatorio consolidado (TXT + MD)
# ============================

$fullReportTxt = Join-AuditPath "audit_full_report.txt"
$fullReportMd  = Join-AuditPath "audit_full_report.md"

"" | Out-File -FilePath $fullReportTxt -Encoding utf8
"" | Out-File -FilePath $fullReportMd  -Encoding utf8

function Add-SectionTxt {
    param(
        [string]$title,
        [string]$filePath
    )
    Add-Content -Path $fullReportTxt -Value "===== $title ====="
    Add-Content -Path $fullReportTxt -Value ""
    Get-Content $filePath | Add-Content -Path $fullReportTxt
    Add-Content -Path $fullReportTxt -Value ""
}

function Add-SectionMd {
    param(
        [string]$title,
        [string]$filePath
    )
    Add-Content -Path $fullReportMd -Value "## $title"
    Add-Content -Path $fullReportMd -Value ""
    Get-Content $filePath | Add-Content -Path $fullReportMd
    Add-Content -Path $fullReportMd -Value ""
}

"# PC System Audit - $date" | Out-File -FilePath $fullReportMd -Encoding utf8
Add-Content -Path $fullReportMd -Value ""

# Secoes TXT
Add-SectionTxt -title "Hardware (TXT)"              -filePath $hardwareTxt
Add-SectionTxt -title "Sistema Operativo (TXT)"     -filePath $osTxt
Add-SectionTxt -title "Software Instalado (TXT)"    -filePath $softwareTxt
Add-SectionTxt -title "Ambiente de Desenvolvimento" -filePath $devEnvTxt
Add-SectionTxt -title "Performance"                 -filePath $perfTxt

# Secoes MD
Add-SectionMd -title "Hardware"                     -filePath $hardwareTxt
Add-SectionMd -title "Sistema Operativo"            -filePath $osTxt
Add-SectionMd -title "Software Instalado"           -filePath $softwareTxt
Add-SectionMd -title "Ambiente de Desenvolvimento"  -filePath $devEnvTxt
Add-SectionMd -title "Performance"                  -filePath $perfTxt

# ============================
# 8. Atualizar README.md
# ============================

$readmePath = "README.md"
$readmeContent = Get-Content $readmePath

# Escapar a barra com acento grave
$auditLinkLine = "- [$date]($auditFolder`/)"

$newReadme = @()
$inserted = $false

foreach ($line in $readmeContent) {
    $newReadme += $line
    if (-not $inserted -and $line -match "Auditorias realizadas") {
        $newReadme += $auditLinkLine
        $inserted = $true
    }
}

[System.IO.File]::WriteAllLines($readmePath, $newReadme, (New-Object System.Text.UTF8Encoding($false)))

# ============================
# 9. Git add / commit / push automatico
# ============================

Write-Host ""
Write-Host "=== GIT OPERATIONS ==="

git add . | Out-Null

$commitMessage = "Auditoria automatica $date"
git commit -m $commitMessage | Out-Null

git push | Out-Null

Write-Host "Commit e push realizados com sucesso."
Write-Host ""

# ============================
# 10. Mensagem final
# ============================

Write-Host "=== AUDITORIA CONCLUIDA ==="
Write-Host "Relatorios gerados em: $auditFolder"
Write-Host "README atualizado."
Write-Host "Git push concluido."