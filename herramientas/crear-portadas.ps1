# =============================================================================
#  CREAR PORTADAS (HERO)  -  Senora Papa
# -----------------------------------------------------------------------------
#  Arma las 3 imagenes grandes que rotan arriba en la pagina de inicio,
#  usando los recortes de producto con fondo transparente y los colores
#  de la marca. No hace falta ninguna foto nueva.
#
#  Resultado:  assets\imagenes\hero\hero-1.jpg , hero-2.jpg , hero-3.jpg
#              1920 x 1080 px
#
#  Como se usa:  clic derecho > "Ejecutar con PowerShell"
#
#  Si algun dia tienes fotos reales del local o de la comida, puedes
#  reemplazar estos archivos y listo: el sitio los toma igual.
# =============================================================================

Add-Type -AssemblyName System.Drawing

$raiz    = Split-Path -Parent $PSScriptRoot
$recortes = Join-Path $raiz "originales\productos"
$logos    = Join-Path $raiz "assets\imagenes\logo"
$salida   = Join-Path $raiz "assets\imagenes\hero"

if (-not (Test-Path $salida)) { New-Item -ItemType Directory -Force -Path $salida | Out-Null }

$ANCHO = 1920
$ALTO  = 1080

# --- Colores de la marca -----------------------------------------------------
$tealHondo = [System.Drawing.Color]::FromArgb(255, 16,  62,  57)   # izquierda
$tealMedio = [System.Drawing.Color]::FromArgb(255, 42, 150, 143)
$tealClaro = [System.Drawing.Color]::FromArgb(255, 66, 190, 180)   # derecha
$amarillo  = [System.Drawing.Color]::FromArgb(255, 253, 186, 17)

# --- Que producto va en cada portada ----------------------------------------
#  DONDE VA LA COMIDA
#  El titular del sitio ocupa desde el borde izquierdo hasta un 52% del
#  ancho, mas o menos, en cualquier pantalla. Por eso la comida arranca
#  recien en el 59% (x = 1130): asi nunca se monta encima del texto.
#  Y x + w tiene que quedar por debajo de 1920 para que no se corte nada.
#
#  archivo             ancho final   x      y     (posicion en el lienzo)
$portadas = @(
    @{ n = 1; img = "combo-1.png";      w = 740; x = 1130; y = 318 },
    @{ n = 2; img = "combo-3.png";      w = 740; x = 1130; y = 316 },
    @{ n = 3; img = "individuales.png"; w = 680; x = 1170; y = 296 }
)

$cod = $null
foreach ($c in [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders()) {
    if ($c.MimeType -eq "image/jpeg") { $cod = $c }
}
$par = New-Object System.Drawing.Imaging.EncoderParameters(1)
$par.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
    [System.Drawing.Imaging.Encoder]::Quality, [long]86)

Write-Host ""
Write-Host "Creando las portadas..." -ForegroundColor Cyan
Write-Host ""

foreach ($p in $portadas) {

    $lienzo = New-Object System.Drawing.Bitmap($ANCHO, $ALTO,
                  [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
    $g = [System.Drawing.Graphics]::FromImage($lienzo)
    $g.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode   = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality

    # --- 1. Fondo: degradado turquesa, oscuro a la izquierda -----------------
    $rect = New-Object System.Drawing.Rectangle(0, 0, $ANCHO, $ALTO)
    $brocha = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
                  $rect, $tealHondo, $tealClaro, 15.0)
    $mezcla = New-Object System.Drawing.Drawing2D.ColorBlend(3)
    $mezcla.Colors    = @($tealHondo, $tealMedio, $tealClaro)
    $mezcla.Positions = @(0.0, 0.55, 1.0)
    $brocha.InterpolationColors = $mezcla
    $g.FillRectangle($brocha, $rect)
    $brocha.Dispose()

    # --- 2. Circulos decorativos, como los del menu impreso ------------------
    $blanco08 = New-Object System.Drawing.SolidBrush(
                    [System.Drawing.Color]::FromArgb(20, 255, 255, 255))
    $blanco05 = New-Object System.Drawing.SolidBrush(
                    [System.Drawing.Color]::FromArgb(13, 255, 255, 255))
    $amar12   = New-Object System.Drawing.SolidBrush(
                    [System.Drawing.Color]::FromArgb(32, $amarillo.R, $amarillo.G, $amarillo.B))

    $g.FillEllipse($blanco08, 1210, -180, 820, 820)
    $g.FillEllipse($blanco05, 1020,  600, 560, 560)
    $g.FillEllipse($amar12,   1620,  660, 360, 360)
    $g.FillEllipse($blanco05, -140,  -70, 460, 460)

    $blanco08.Dispose(); $blanco05.Dispose(); $amar12.Dispose()

    # --- 3. Sombra suave debajo del producto ---------------------------------
    $rutaImg = Join-Path $recortes $p.img
    if (Test-Path $rutaImg) {
        $prod = New-Object System.Drawing.Bitmap($rutaImg)
        $escala = $p.w / $prod.Width
        $ph = [int][math]::Round($prod.Height * $escala)

        # varias elipses cada vez mas tenues = sombra difuminada
        for ($i = 7; $i -ge 1; $i--) {
            $a = [int](7 * $i)
            $br = New-Object System.Drawing.SolidBrush(
                      [System.Drawing.Color]::FromArgb($a, 8, 40, 37))
            $ex = $p.x + ($p.w * 0.10) - ($i * 11)
            $ey = $p.y + $ph - 70 - ($i * 4)
            $ew = ($p.w * 0.80) + ($i * 22)
            $eh = 105 + ($i * 8)
            $g.FillEllipse($br, $ex, $ey, $ew, $eh)
            $br.Dispose()
        }

        # --- 4. El producto ---------------------------------------------------
        $g.DrawImage($prod, $p.x, $p.y, $p.w, $ph)
        $prod.Dispose()
    }
    else {
        Write-Host ("  AVISO: no se encontro {0}" -f $p.img) -ForegroundColor Yellow
    }

    # NOTA: aqui iba la mascota abajo a la izquierda, pero se quito.
    # Encima de la portada el sitio pone un velo oscuro que tapa el 88% del
    # lado izquierdo (es lo que hace legible el texto blanco), asi que la
    # mascota quedaba invisible y ademas chocaba con el titular.

    $g.Dispose()

    $destino = Join-Path $salida ("hero-" + $p.n + ".jpg")
    $lienzo.Save($destino, $cod, $par)
    $lienzo.Dispose()

    $kb = [math]::Round((Get-Item $destino).Length / 1KB)
    Write-Host ("  hero-{0}.jpg   {1}x{2}   {3} KB   (producto: {4})" -f `
        $p.n, $ANCHO, $ALTO, $kb, $p.img) -ForegroundColor Green
}

Write-Host ""
Write-Host "Listo. Las portadas estan en  assets\imagenes\hero\" -ForegroundColor Cyan
Write-Host ""
