# =============================================================================
#  PREPARAR FOTOS  -  Senora Papa
# -----------------------------------------------------------------------------
#  Deja cualquier foto lista para el sitio, venga como venga.
#
#  Que hace, en orden:
#    1. Toma los .png , .jpeg y .JPG de assets\imagenes\productos
#    2. Si tienen fondo transparente, los pone sobre blanco
#    3. Empareja el fondo: los grises casi blancos (#F7F7F7 y parecidos)
#       los pasa a blanco puro, para que todas las fotos combinen entre si
#    4. Reduce el tamano a 1000 px y baja el peso
#    5. Los guarda como .jpg, que es lo unico que el sitio busca
#    6. Guarda el archivo original en  originales\productos\  por si acaso
#
#  Como se usa:  clic derecho sobre este archivo > "Ejecutar con PowerShell"
#
#  Se puede ejecutar las veces que haga falta: los .jpg que ya estan listos
#  no los vuelve a tocar.
#
#  OJO: este script NO quita el fondo verde. Para eso esta
#       quitar-fondo-verde.ps1 , que hay que ejecutar ANTES que este.
# =============================================================================

Add-Type -AssemblyName System.Drawing

$raiz     = Split-Path -Parent $PSScriptRoot
$origen   = Join-Path $raiz "assets\imagenes\productos"
$respaldo = Join-Path $raiz "originales\productos"

$LADO_MAX = 1000     # ningun lado pasa de esto
$CALIDAD  = 85       # 0 a 100. Mas alto = mejor calidad y mas peso

# Cuando un pixel se considera "fondo casi blanco" y se pasa a blanco puro.
# Se pide que sea claro Y que sea gris (sin color), para no tocar la comida.
$UMBRAL_CLARO = 242  # el canal mas oscuro tiene que llegar a esto
$UMBRAL_GRIS  = 8    # diferencia maxima entre canales

if (-not (Test-Path $respaldo)) { New-Item -ItemType Directory -Force -Path $respaldo | Out-Null }

$codificador = $null
foreach ($c in [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders()) {
    if ($c.MimeType -eq "image/jpeg") { $codificador = $c }
}
$parametros = New-Object System.Drawing.Imaging.EncoderParameters(1)
$parametros.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
    [System.Drawing.Imaging.Encoder]::Quality, [long]$CALIDAD)

# Junta todo lo que no sea ya un .jpg en minusculas
$archivos = Get-ChildItem $origen -File | Where-Object {
    $_.Extension -match '^\.(png|jpeg)$' -or ($_.Extension -eq '.JPG' -and $_.Name -cmatch '\.JPG$')
}

if (-not $archivos) {
    Write-Host ""
    Write-Host "No hay nada que preparar: todas las fotos ya son .jpg" -ForegroundColor Green
    Write-Host ""
    Read-Host "Presiona Enter para cerrar"
    return
}

Write-Host ""
Write-Host "Preparando $($archivos.Count) foto(s)..." -ForegroundColor Cyan
Write-Host ""

$antes = 0; $despues = 0; $ok = 0

foreach ($f in $archivos) {

    $destino = Join-Path $origen ($f.BaseName.ToLower() + ".jpg")
    $pesoAntes = $f.Length

    try {
        $src = New-Object System.Drawing.Bitmap($f.FullName)
        $w = $src.Width; $h = $src.Height

        # --- 1. Sobre blanco, en tamano final ---------------------------------
        $escala = [math]::Min(1.0, $LADO_MAX / [math]::Max($w, $h))
        $nw = [int][math]::Round($w * $escala)
        $nh = [int][math]::Round($h * $escala)

        $dst = New-Object System.Drawing.Bitmap($nw, $nh,
                   [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
        $g = [System.Drawing.Graphics]::FromImage($dst)
        $g.Clear([System.Drawing.Color]::White)
        $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $g.PixelOffsetMode   = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
        $g.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $g.DrawImage($src, 0, 0, $nw, $nh)
        $g.Dispose()
        $src.Dispose()

        # --- 2. Emparejar el fondo casi blanco a blanco puro -------------------
        $rect = New-Object System.Drawing.Rectangle(0, 0, $nw, $nh)
        $datos = $dst.LockBits($rect,
                    [System.Drawing.Imaging.ImageLockMode]::ReadWrite,
                    [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
        $largo = [math]::Abs($datos.Stride) * $nh
        $buf = New-Object byte[] $largo
        [System.Runtime.InteropServices.Marshal]::Copy($datos.Scan0, $buf, 0, $largo)

        for ($i = 0; $i -lt $largo; $i += 3) {
            $b = $buf[$i]; $v = $buf[$i+1]; $r = $buf[$i+2]
            $min = [math]::Min($r, [math]::Min($v, $b))
            $max = [math]::Max($r, [math]::Max($v, $b))
            if ($min -ge $UMBRAL_CLARO -and ($max - $min) -le $UMBRAL_GRIS) {
                $buf[$i] = 255; $buf[$i+1] = 255; $buf[$i+2] = 255
            }
        }

        [System.Runtime.InteropServices.Marshal]::Copy($buf, 0, $datos.Scan0, $largo)
        $dst.UnlockBits($datos)

        # --- 3. Guardar --------------------------------------------------------
        $dst.Save($destino, $codificador, $parametros)
        $dst.Dispose()

        Move-Item -Path $f.FullName -Destination (Join-Path $respaldo $f.Name) -Force

        $pesoDespues = (Get-Item $destino).Length
        $antes += $pesoAntes; $despues += $pesoDespues; $ok++

        Write-Host ("  {0,-24} -> {1,-22} {2,4} KB   {3}x{4}" -f `
            $f.Name, (Split-Path $destino -Leaf), [math]::Round($pesoDespues/1KB), $nw, $nh) -ForegroundColor Green
    }
    catch {
        Write-Host ("  ERROR con {0}: {1}" -f $f.Name, $_.Exception.Message) -ForegroundColor Red
    }
}

Write-Host ""
Write-Host ("Listas $ok de $($archivos.Count).  Peso: {0} KB -> {1} KB" -f `
    [math]::Round($antes/1KB), [math]::Round($despues/1KB)) -ForegroundColor Cyan
Write-Host "Los archivos originales quedaron en  originales\productos\" -ForegroundColor Gray
Write-Host ""
