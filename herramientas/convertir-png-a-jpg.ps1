# =============================================================================
#  CONVERTIR PNG A JPG  -  Senora Papa
# -----------------------------------------------------------------------------
#  Que hace:
#    1. Toma los .png de assets\imagenes\productos
#    2. Los pone sobre fondo blanco (los PNG con transparencia se ven mal
#       en JPG si no se hace esto)
#    3. Los reduce de tamano y de peso
#    4. Los guarda como .jpg, que es lo que el sitio busca
#    5. Guarda el .png original en  originales\productos\  por si acaso
#
#  Como se usa:  clic derecho sobre este archivo > "Ejecutar con PowerShell"
#
#  Se puede ejecutar las veces que haga falta: los .jpg que ya existen
#  no los vuelve a tocar.
# =============================================================================

Add-Type -AssemblyName System.Drawing

$raiz     = Split-Path -Parent $PSScriptRoot
$origen   = Join-Path $raiz "assets\imagenes\productos"
$respaldo = Join-Path $raiz "originales\productos"
$LADO_MAX = 1000
$CALIDAD  = 82

if (-not (Test-Path $respaldo)) { New-Item -ItemType Directory -Force -Path $respaldo | Out-Null }

# Busca el codificador de JPEG
$codificador = $null
foreach ($c in [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders()) {
    if ($c.MimeType -eq "image/jpeg") { $codificador = $c }
}
$parametros = New-Object System.Drawing.Imaging.EncoderParameters(1)
$parametros.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
    [System.Drawing.Imaging.Encoder]::Quality, [long]$CALIDAD)

$archivos = Get-ChildItem "$origen\*.png" -ErrorAction SilentlyContinue
if (-not $archivos) {
    Write-Host "No hay archivos .png que convertir en $origen" -ForegroundColor Yellow
    return
}

Write-Host ""
Write-Host "Convirtiendo $($archivos.Count) archivo(s) PNG a JPG..." -ForegroundColor Cyan
Write-Host ""

$totalAntes = 0
$totalDespues = 0

foreach ($f in $archivos) {
    $destino = Join-Path $origen ($f.BaseName + ".jpg")
    $pesoAntes = $f.Length

    try {
        $src = New-Object System.Drawing.Bitmap($f.FullName)

        # Calcula el tamano final
        $escala = [math]::Min(1.0, $LADO_MAX / [math]::Max($src.Width, $src.Height))
        $nw = [int][math]::Round($src.Width  * $escala)
        $nh = [int][math]::Round($src.Height * $escala)

        # Dibuja sobre blanco. Sin esto, lo transparente sale negro en JPG.
        $dst = New-Object System.Drawing.Bitmap($nw, $nh,
                   [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
        $g = [System.Drawing.Graphics]::FromImage($dst)
        $g.Clear([System.Drawing.Color]::White)
        $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $g.PixelOffsetMode   = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
        $g.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $g.DrawImage($src, 0, 0, $nw, $nh)
        $g.Dispose()

        $dst.Save($destino, $codificador, $parametros)
        $dst.Dispose()
        $src.Dispose()

        # Guarda el original y lo saca de la carpeta que se publica
        Move-Item -Path $f.FullName -Destination (Join-Path $respaldo $f.Name) -Force

        $pesoDespues = (Get-Item $destino).Length
        $totalAntes   += $pesoAntes
        $totalDespues += $pesoDespues

        $ahorro = [math]::Round(100 - (100 * $pesoDespues / $pesoAntes))
        Write-Host ("  {0,-22} {1,5} KB  ->  {2,4} KB   ({3}% menos)  {4}x{5}" -f `
            $f.Name, [math]::Round($pesoAntes/1KB), [math]::Round($pesoDespues/1KB), $ahorro, $nw, $nh) -ForegroundColor Green
    }
    catch {
        Write-Host ("  ERROR con {0}: {1}" -f $f.Name, $_.Exception.Message) -ForegroundColor Red
    }
}

Write-Host ""
Write-Host ("TOTAL: {0} KB  ->  {1} KB" -f [math]::Round($totalAntes/1KB), [math]::Round($totalDespues/1KB)) -ForegroundColor Cyan
Write-Host "Los .png originales quedaron en  originales\productos\" -ForegroundColor Gray
Write-Host ""
