[CmdletBinding()]
param([switch]$Commit)

function Find-Inkscape {
    $candidates = @('inkscape','inkscape.com','inkscape.exe')
    foreach ($c in $candidates) {
        try { $cmd = Get-Command $c -ErrorAction Stop; return $cmd.Source } catch {}
    }
    $paths = @("C:\Program Files\Inkscape\bin\inkscape.com","C:\Program Files\Inkscape\inkscape.exe")
    foreach ($p in $paths) { if (Test-Path $p) { return $p } }
    return $null
}

$inkscape = Find-Inkscape
if (-not $inkscape) { Write-Host "Inkscape não encontrado. Instale e rode novamente." -ForegroundColor Yellow; exit 1 }

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
        # tenter sintaxe moderna
        try {
            & $inkscape $svg.FullName --export-type=png --export-filename=$outPng --export-width=$size
        } catch {
            & $inkscape --export-png=$outPng --export-width=$size $svg.FullName
        }
    }
    $base = [System.IO.Path]::GetFileNameWithoutExtension($svg.Name)
    $png512 = Join-Path $assetsDir \"$($base)@512.png\"
    $outWebp = Join-Path $assetsDir \"$($base)@512.webp\"
    # tentar cwebp/ffmpeg se disponíveis
    if (Get-Command cwebp -ErrorAction SilentlyContinue) {
        & cwebp -q 80 $png512 -o $outWebp
    } elseif (Get-Command ffmpeg -ErrorAction SilentlyContinue) {
        & ffmpeg -y -i $png512 -vcodec libwebp -lossless 0 -q:v 75 -preset default -an $outWebp
    } else {
        Write-Host "Nenhum conversor WebP (cwebp/ffmpeg) encontrado. Apenas PNGs gerados." -ForegroundColor Yellow
    }
}

if ($Commit) {
    git add (Join-Path $assetsDir '*@*.png') (Join-Path $assetsDir '*@*.webp')
    git commit -m 'chore(assets): add PNG and WebP renditions (Inkscape)'
}
