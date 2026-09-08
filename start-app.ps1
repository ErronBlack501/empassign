param(
    [string]$TomcatPath = $env:TOMCAT_HOME,
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$composeFile = Join-Path $projectRoot "docker-compose.yml"
$mavenWrapper = Join-Path $projectRoot "mvnw.cmd"

function Test-Command([string]$Name) {
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Commande introuvable: $Name"
    }
}

if (-not (Test-Path $composeFile)) {
    throw "Fichier docker-compose.yml introuvable dans $projectRoot"
}

Test-Command "docker"
Test-Command "java"

if (-not $env:JAVA_HOME -or -not (Test-Path (Join-Path $env:JAVA_HOME "bin\java.exe"))) {
    throw "JAVA_HOME doit pointer vers un JDK valide (Java 21 recommande)."
}

if (-not $TomcatPath) {
    throw "Chemin Tomcat manquant. Utilisez -TomcatPath 'C:\chemin\vers\apache-tomcat-11' ou definissez TOMCAT_HOME."
}

$tomcatBin = Join-Path $TomcatPath "bin"
$startupScript = Join-Path $tomcatBin "startup.bat"
$shutdownScript = Join-Path $tomcatBin "shutdown.bat"
$webappsPath = Join-Path $TomcatPath "webapps"

$env:CATALINA_HOME = $TomcatPath
$env:CATALINA_BASE = $TomcatPath

if (-not (Test-Path $startupScript) -or -not (Test-Path $shutdownScript) -or -not (Test-Path $webappsPath)) {
    throw "Installation Tomcat invalide: startup.bat, shutdown.bat ou webapps est introuvable dans $TomcatPath"
}

Write-Host "Demarrage de MySQL..." -ForegroundColor Cyan
docker compose -f $composeFile up -d mysql
$env:DB_HOST = "127.0.0.1"
$env:DB_PORT = "3307"
$env:DB_USER = "empassign"
$env:DB_PASSWORD = "empassign"

if (-not $SkipBuild) {
    if (-not (Test-Path $mavenWrapper)) {
        throw "mvnw.cmd introuvable dans $projectRoot"
    }

    Write-Host "Compilation du projet..." -ForegroundColor Cyan
    Push-Location $projectRoot
    try {
        & $mavenWrapper clean package
        if ($LASTEXITCODE -ne 0) {
            throw "La compilation Maven a echoue."
        }
    }
    finally {
        Pop-Location
    }
}

$warFile = Get-ChildItem (Join-Path $projectRoot "target") -Filter "*.war" -File |
Where-Object { $_.Name -notlike "original-*" } |
Select-Object -First 1

if (-not $warFile) {
    throw "Aucun fichier WAR trouve dans target. Lancez le script sans -SkipBuild."
}

$deploymentName = [IO.Path]::GetFileNameWithoutExtension($warFile.Name)
$destination = Join-Path $webappsPath $warFile.Name

Write-Host "Arret propre de Tomcat avant le deploiement..." -ForegroundColor Yellow
if (Test-Path $shutdownScript) {
    try {
        & $shutdownScript
    }
    catch {
        Write-Host "Shutdown Tomcat ignore: $($_.Exception.Message)" -ForegroundColor DarkYellow
    }
}

Start-Sleep -Seconds 3

Write-Host "Nettoyage des deploiements Tomcat existants pour $deploymentName..." -ForegroundColor Yellow
Get-ChildItem $webappsPath -Filter "empassign*" -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

Copy-Item $warFile.FullName $destination -Force

Write-Host "WAR deploye dans $destination" -ForegroundColor Green
Write-Host "Demarrage de Tomcat..." -ForegroundColor Cyan
Start-Process -FilePath $startupScript -WorkingDirectory $tomcatBin

Write-Host "Application disponible a: http://localhost:8080/$deploymentName/" -ForegroundColor Green