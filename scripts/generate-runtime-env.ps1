$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Terraform Runtime Configuration Generator " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Reading Terraform outputs..." -ForegroundColor Yellow

$sourceIp   = terraform output -raw source_ingest_ip
$sourcePort = terraform output -raw source_ingest_port
$hlsUrl     = terraform output -raw hls_endpoint_url
$dashUrl    = terraform output -raw dash_endpoint_url

$outputDir = "generated"

if (!(Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

$outputFile = Join-Path $outputDir ".env"

# ----------------------------------------------------
# Preserve an existing JWT secret if the file exists.
# Otherwise generate a new random one.
# ----------------------------------------------------

$jwtSecret = $null

if (Test-Path $outputFile) {

    $existing = Get-Content $outputFile

    foreach ($line in $existing) {

        if ($line.StartsWith("JWT_SECRET=")) {

            $jwtSecret = $line.Replace("JWT_SECRET=","").Trim()
        }
    }
}

if ([string]::IsNullOrWhiteSpace($jwtSecret)) {

    Write-Host "Generating new JWT secret..." -ForegroundColor Yellow

    $jwtSecret = [Guid]::NewGuid().ToString("N") +
                 [Guid]::NewGuid().ToString("N")
}
else {

    Write-Host "Keeping existing JWT secret..." -ForegroundColor Green
}

$envContent = @"
SRT_TARGET_IP=$sourceIp
SRT_TARGET_PORT=$sourcePort
SRT_LATENCY_MS=2000
HLS_URL=$hlsUrl
DASH_URL=$dashUrl
JWT_SECRET=$jwtSecret
"@

$envContent | Set-Content -Path $outputFile

Write-Host ""
Write-Host "Runtime configuration generated successfully." -ForegroundColor Green
Write-Host ""

Write-Host "Location:"
Write-Host "  $outputFile"
Write-Host ""

Write-Host "Contents:"
Write-Host "------------------------------------------"

Get-Content $outputFile

Write-Host "------------------------------------------"