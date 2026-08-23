# =============================================================================
#  QUITAR EL FONDO VERDE DE LAS FOTOS DE PRODUCTOS
# -----------------------------------------------------------------------------
#  Las fotos de los platos vienen con fondo verde (croma). Este script:
#
#    1. Detecta el verde y lo reemplaza por BLANCO.
#    2. Suaviza los bordes, para que el plato no quede recortado "a lo bruto".
#    3. Quita el reflejo verde que el fondo deja sobre el envase blanco
#       (a eso se le dice "despill"; sin esto los envases se ven verdosos).
#    4. Reduce el tamano y guarda como .jpg liviano.
#
#  Los archivos originales NO se borran: se mueven a la carpeta
#  "originales" en la raiz del proyecto, por si alguna vez hacen falta.
#
#  COMO USARLO
#    Clic derecho sobre este archivo > "Ejecutar con PowerShell".
#    O desde la terminal:  .\herramientas\quitar-fondo-verde.ps1
#
#  Se puede volver a ejecutar cuando lleguen fotos nuevas: solo procesa
#  las que todavia tengan fondo verde.
# =============================================================================

Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = 'Stop'
$raiz      = Split-Path -Parent $PSScriptRoot
$productos = Join-Path $raiz 'assets\imagenes\productos'
$respaldo  = Join-Path $raiz 'originales\productos'

# --- Tamano maximo del lado largo y calidad del JPG -------------------------
$MAX_LADO = 1000
$CALIDAD  = 82

# --- Umbrales del croma -----------------------------------------------------
#  "verdor" = cuanto mas verde es el pixel que su canal rojo o azul.
#  El fondo verde puro da un verdor de ~190. El envase blanco da 0.
$VERDE_TOTAL  = 70   # de aqui para arriba: es fondo, se borra entero
$VERDE_BORDE  = 20   # entre 20 y 70: es borde, se difumina


# -----------------------------------------------------------------------------
#  El procesamiento va en C# porque en PowerShell puro, recorrer un millon y
#  medio de pixeles por foto tardaria varios minutos.
# -----------------------------------------------------------------------------
$codigo = @'
using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

public class Croma
{
    public static string Procesar(string entrada, string salida,
                                  int maxLado, long calidad,
                                  int verdeTotal, int verdeBorde)
    {
        using (Bitmap origen = new Bitmap(entrada))
        {
            int w = origen.Width, h = origen.Height;

            Bitmap bmp = new Bitmap(w, h, PixelFormat.Format32bppArgb);
            using (Graphics g = Graphics.FromImage(bmp)) { g.DrawImage(origen, 0, 0, w, h); }

            Rectangle rect = new Rectangle(0, 0, w, h);
            BitmapData datos = bmp.LockBits(rect, ImageLockMode.ReadWrite, PixelFormat.Format32bppArgb);
            int largo = Math.Abs(datos.Stride) * h;
            byte[] buf = new byte[largo];
            Marshal.Copy(datos.Scan0, buf, 0, largo);

            long borrados = 0, suavizados = 0;

            // El orden en memoria es B, G, R, A
            for (int i = 0; i < largo; i += 4)
            {
                int b  = buf[i];
                int gr = buf[i + 1];
                int r  = buf[i + 2];

                int maxRB  = (r > b) ? r : b;
                int verdor = gr - maxRB;

                double alfa;
                if (verdor >= verdeTotal)      { alfa = 0.0; borrados++; }
                else if (verdor <= verdeBorde) { alfa = 1.0; }
                else {
                    alfa = (double)(verdeTotal - verdor) / (verdeTotal - verdeBorde);
                    suavizados++;
                }

                // Despill: baja el verde que sobra, para que el envase blanco
                // no quede con reflejo verdoso.
                if (verdor > 10) { gr = maxRB + (int)((gr - maxRB) * 0.10); }

                // Compone sobre blanco segun la transparencia calculada
                double inv = 1.0 - alfa;
                int nb = (int)(b  * alfa + 255 * inv);
                int ng = (int)(gr * alfa + 255 * inv);
                int nr = (int)(r  * alfa + 255 * inv);

                buf[i]     = (byte)(nb < 0 ? 0 : (nb > 255 ? 255 : nb));
                buf[i + 1] = (byte)(ng < 0 ? 0 : (ng > 255 ? 255 : ng));
                buf[i + 2] = (byte)(nr < 0 ? 0 : (nr > 255 ? 255 : nr));
                buf[i + 3] = 255;
            }

            Marshal.Copy(buf, 0, datos.Scan0, largo);
            bmp.UnlockBits(datos);

            // Redimensiona
            double esc = 1.0;
            int lado = (w > h) ? w : h;
            if (lado > maxLado) { esc = (double)maxLado / lado; }
            int nw = (int)Math.Round(w * esc);
            int nh = (int)Math.Round(h * esc);

            Bitmap final = new Bitmap(nw, nh, PixelFormat.Format24bppRgb);
            using (Graphics g2 = Graphics.FromImage(final))
            {
                g2.Clear(Color.White);
                g2.InterpolationMode  = InterpolationMode.HighQualityBicubic;
                g2.PixelOffsetMode    = PixelOffsetMode.HighQuality;
                g2.SmoothingMode      = SmoothingMode.HighQuality;
                g2.DrawImage(bmp, 0, 0, nw, nh);
            }

            ImageCodecInfo cod = null;
            foreach (ImageCodecInfo c in ImageCodecInfo.GetImageEncoders())
                if (c.MimeType == "image/jpeg") { cod = c; break; }

            EncoderParameters ep = new EncoderParameters(1);
            ep.Param[0] = new EncoderParameter(Encoder.Quality, calidad);
            final.Save(salida, cod, ep);

            final.Dispose();
            bmp.Dispose();

            long total = (long)w * h;
            int pct = (int)Math.Round(100.0 * borrados / total);
            return nw + "x" + nh + "  fondo quitado: " + pct + "%";
        }
    }

    // Mira las cuatro esquinas para confirmar que la foto tiene fondo verde
    public static bool TieneFondoVerde(string ruta)
    {
        using (Bitmap b = new Bitmap(ruta))
        {
            Point[] esquinas = new Point[] {
                new Point(3, 3), new Point(b.Width - 4, 3),
                new Point(3, b.Height - 4), new Point(b.Width - 4, b.Height - 4)
            };
            int verdes = 0;
            foreach (Point p in esquinas)
            {
                Color c = b.GetPixel(p.X, p.Y);
                int maxRB = (c.R > c.B) ? c.R : c.B;
                if (c.G - maxRB >= 70) verdes++;
            }
            return verdes >= 3;
        }
    }
}
'@

Add-Type -TypeDefinition $codigo -ReferencedAssemblies System.Drawing

# --- Como se debe llamar cada archivo ----------------------------------------
#  El nombre del archivo tiene que coincidir con el que espera el HTML.
#  Izquierda: parte del nombre que trae la foto. Derecha: nombre final.
$nombres = @{
    'doble-papa-+-pollo-+-salchicha'     = 'doble'
    'mixta-1-papa-+-carne-+-huevo'       = 'mixta-1'
    'mixta-2-papa-+-salchicha-+-huevo'   = 'mixta-2'
    'triple-1-papa-+-pollo-+-salchicha-+-huevo' = 'triple-1'
    'triple-2-papa-+-pollo-+-carne-+-huevo'     = 'triple-2'
    'triple-3-papa-+-pollo-+-carne-+-salchicha' = 'triple-3'
}

if (-not (Test-Path $respaldo)) { New-Item -ItemType Directory -Force -Path $respaldo | Out-Null }

$fotos = Get-ChildItem -Path $productos -File |
         Where-Object { $_.Extension -match '^\.(jpe?g|png)$' }

if (-not $fotos) { Write-Host "No hay fotos en $productos"; return }

Write-Host ""
Write-Host "Procesando $($fotos.Count) foto(s)..." -ForegroundColor Cyan
Write-Host ""

$hechas = 0; $saltadas = 0
foreach ($f in $fotos) {
    $base = [System.IO.Path]::GetFileNameWithoutExtension($f.Name)

    # Nombre final: el del diccionario, o el mismo si ya esta bien
    $destinoBase = $base
    foreach ($k in $nombres.Keys) { if ($base -eq $k) { $destinoBase = $nombres[$k] } }
    $destino = Join-Path $productos ($destinoBase + '.jpg')

    if (-not [Croma]::TieneFondoVerde($f.FullName)) {
        Write-Host ("  - {0,-44} sin fondo verde, se deja igual" -f $f.Name) -ForegroundColor DarkGray
        $saltadas++
        continue
    }

    $tmp = Join-Path $env:TEMP ("croma_" + [Guid]::NewGuid().ToString('N') + ".jpg")
    $info = [Croma]::Procesar($f.FullName, $tmp, $MAX_LADO, $CALIDAD, $VERDE_TOTAL, $VERDE_BORDE)

    Move-Item -Path $f.FullName -Destination (Join-Path $respaldo $f.Name) -Force
    Move-Item -Path $tmp -Destination $destino -Force

    $kb = [math]::Round((Get-Item $destino).Length / 1KB, 0)
    Write-Host ("  OK {0,-30} -> {1,-20} {2}  {3} KB" -f $f.Name, ($destinoBase + '.jpg'), $info, $kb) -ForegroundColor Green
    $hechas++
}

Write-Host ""
Write-Host "Listo. $hechas procesada(s), $saltadas sin cambios." -ForegroundColor Cyan
Write-Host "Los archivos originales quedaron en: originales\productos" -ForegroundColor DarkGray
Write-Host ""
