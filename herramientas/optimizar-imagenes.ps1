# =============================================================================
#  OPTIMIZAR IMÁGENES  -  Señora Papa
# -----------------------------------------------------------------------------
#  Achica y comprime las fotos del sitio para que la página abra rápido en el
#  celular, aunque las fotos vengan directo de la cámara.
#
#  CÓMO USARLO
#    Clic derecho sobre este archivo  >  "Ejecutar con PowerShell"
#
#  QUÉ HACE
#    1. Guarda una copia de TODAS las fotos originales en
#       assets/imagenes/_originales/   (no se borra nada, nunca)
#    2. Achica las que estén más grandes de lo necesario
#    3. Las vuelve a guardar comprimidas
#
#  Si algo sale mal, las fotos originales están intactas en _originales/
#  y se pueden volver a copiar en su lugar.
#
#  No necesita instalar nada: usa lo que ya viene con Windows.
# =============================================================================

Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = 'Stop'

# La carpeta del sitio es la que contiene a "herramientas"
$raiz      = Split-Path -Parent $PSScriptRoot
$imagenes  = Join-Path $raiz "assets\imagenes"
$respaldo  = Join-Path $imagenes "_originales"

# Ancho máximo y calidad según la carpeta
$reglas = @{
    "hero"      = @{ Ancho = 1920; Calidad = 82 }
    "productos" = @{ Ancho = 1200; Calidad = 82 }
    "local"     = @{ Ancho = 1600; Calidad = 82 }
    "historia"  = @{ Ancho = 1600; Calidad = 82 }
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host "  OPTIMIZAR IMAGENES - Senora Papa" -ForegroundColor Yellow
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host ""

if (-not (Test-Path $imagenes)) {
    Write-Host "No se encontro la carpeta assets\imagenes" -ForegroundColor Red
    Write-Host "Deja este archivo dentro de la carpeta 'herramientas' del sitio."
    Read-Host "Presiona Enter para salir"
    exit
}

# Codificador JPG
$codecJpg = $null
foreach ($e in [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders()) {
    if ($e.MimeType -eq 'image/jpeg') { $codecJpg = $e }
}

function Optimizar-Archivo($archivo, $anchoMax, $calidad) {
    $pesoAntes = $archivo.Length

    $src = New-Object System.Drawing.Bitmap($archivo.FullName)
    $w = $src.Width; $h = $src.Height

    # Si ya es chica y liviana, no se toca
    if ($w -le $anchoMax -and $pesoAntes -lt 300KB) {
        $src.Dispose()
        return @{ Cambio = $false; Antes = $pesoAntes; Despues = $pesoAntes; Ancho = $w }
    }

    $escala = 1.0
    if ($w -gt $anchoMax) { $escala = $anchoMax / $w }
    $nw = [int][math]::Round($w * $escala)
    $nh = [int][math]::Round($h * $escala)

    $dst = New-Object System.Drawing.Bitmap($nw, $nh, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($dst)
    $g.InterpolationMode  = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode      = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode    = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $g.DrawImage($src, 0, 0, $nw, $nh)
    $g.Dispose()
    $src.Dispose()          # se libera el archivo ANTES de sobrescribirlo

    $ext = $archivo.Extension.ToLower()
    if ($ext -eq '.jpg' -or $ext -eq '.jpeg') {
        $par = New-Object System.Drawing.Imaging.EncoderParameters(1)
        $par.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
                            [System.Drawing.Imaging.Encoder]::Quality, [long]$calidad)
        $dst.Save($archivo.FullName, $codecJpg, $par)
    } else {
        $dst.Save($archivo.FullName, [System.Drawing.Imaging.ImageFormat]::Png)
    }
    $dst.Dispose()

    $pesoDespues = (Get-Item $archivo.FullName).Length
    return @{ Cambio = $true; Antes = $pesoAntes; Despues = $pesoDespues; Ancho = $nw }
}

$totalAntes = 0
$totalDespues = 0
$procesadas = 0

foreach ($carpeta in $reglas.Keys) {
    $ruta = Join-Path $imagenes $carpeta
    if (-not (Test-Path $ruta)) { continue }

    $archivos = Get-ChildItem -Path $ruta -File | Where-Object {
        $_.Extension -match '^\.(jpg|jpeg|png)$'
    }
    if ($archivos.Count -eq 0) { continue }

    Write-Host ""
    Write-Host "--- $carpeta ---" -ForegroundColor Cyan

    # Respaldo antes de tocar nada
    $rutaRespaldo = Join-Path $respaldo $carpeta
    if (-not (Test-Path $rutaRespaldo)) {
        New-Item -ItemType Directory -Force -Path $rutaRespaldo | Out-Null
    }

    foreach ($a in $archivos) {
        $copia = Join-Path $rutaRespaldo $a.Name
        if (-not (Test-Path $copia)) { Copy-Item $a.FullName $copia }

        try {
            $r = Optimizar-Archivo $a $reglas[$carpeta].Ancho $reglas[$carpeta].Calidad
            $totalAntes   += $r.Antes
            $totalDespues += $r.Despues
            $procesadas++

            $kbA = [math]::Round($r.Antes/1KB); $kbD = [math]::Round($r.Despues/1KB)
            if ($r.Cambio) {
                $pct = [math]::Round(100 - (100 * $r.Despues / $r.Antes))
                Write-Host ("  {0,-34} {1,6} KB -> {2,5} KB  (-{3}%)" -f $a.Name, $kbA, $kbD, $pct) -ForegroundColor Green
            } else {
                Write-Host ("  {0,-34} {1,6} KB   ya estaba bien" -f $a.Name, $kbA) -ForegroundColor DarkGray
            }
        } catch {
            Write-Host ("  {0,-34} ERROR: {1}" -f $a.Name, $_.Exception.Message) -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Yellow
if ($procesadas -eq 0) {
    Write-Host "  No se encontraron fotos que optimizar." -ForegroundColor Yellow
    Write-Host "  Deja las fotos en assets\imagenes\productos, hero, local o historia."
} else {
    $mbA = [math]::Round($totalAntes/1MB, 2)
    $mbD = [math]::Round($totalDespues/1MB, 2)
    Write-Host ("  {0} fotos procesadas" -f $procesadas) -ForegroundColor Yellow
    Write-Host ("  Antes:   {0} MB" -f $mbA)
    Write-Host ("  Despues: {0} MB" -f $mbD) -ForegroundColor Green
    if ($totalAntes -gt 0) {
        Write-Host ("  Ahorro:  {0}%" -f [math]::Round(100 - (100 * $totalDespues / $totalAntes))) -ForegroundColor Green
    }
    Write-Host ""
    Write-Host "  Las fotos originales quedaron guardadas en:"
    Write-Host "  assets\imagenes\_originales\" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Esa carpeta es solo tu respaldo: el sitio no la usa."
    Write-Host "  Si quieres, puedes borrarla antes de publicar."
}
Write-Host "=============================================" -ForegroundColor Yellow
Write-Host ""
Read-Host "Presiona Enter para cerrar"
