[CmdletBinding()]
param([switch]$Commit)

function Check-Magick {
    try { & magick -version > $null; return $true } catch { return $false }
}

if (-not (Check-Magick)) {
    Write-Host "magick (ImageMagick) não encontrado. Instale-o ou use o script Inkscape." -ForegroundColor Yellow
    exit 1
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Split-Path -Parent $scriptDir
$assetsDir = Join-Path $projectRoot 'assets'

$sizes = @(256,512)
$svgFiles = Get-ChildItem -Path $assetsDir -Filter "cookie-*.svg" -File -ErrorAction SilentlyContinue
if (-not $svgFiles) { Write-Host "Nenhum SVG encontrado em $assetsDir" -ForegroundColor Red; exit 1 }

foreach ($svg in $svgFiles) {
    foreach ($size in $sizes) {
        $base = [System.IO.Path]::GetFileNameWithoutExtension($svg.Name)
        $outPng = Join-Path $assetsDir \"$($base)@$($size).png\"
        Write-Host "Gerando $outPng"
        & magick convert $svg.FullName -background none -resize ${size}x${size} -strip -quality 85 $outPng
    }
    $base = [System.IO.Path]::GetFileNameWithoutExtension($svg.Name)
    $outWebp = Join-Path $assetsDir \"$($base)@512.webp\"
    Write-Host "Gerando $outWebp"
    & magick convert $svg.FullName -background none -resize 512x512 -strip -quality 80 $outWebp
}

if ($Commit) {
    git add (Join-Path $assetsDir '*@*.png') (Join-Path $assetsDir '*@*.webp')
    git commit -m 'chore(assets): add PNG and WebP renditions'
}
