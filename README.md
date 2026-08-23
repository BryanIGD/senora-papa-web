# Señora Papa — Sitio web

Sitio web estático del restaurante **Señora Papa** (Latacunga, Cotopaxi, Ecuador).

Es un sitio informativo: muestra la carta con precios, la ubicación y las
formas de contacto. **No procesa pagos ni recibe pedidos.**

👉 **Para editar el contenido, lee [COMO-EDITAR.md](COMO-EDITAR.md).**

---

## Qué tiene

| Página | Archivo | Contenido |
|---|---|---|
| Inicio | `index.html` | Portada rotativa, categorías, favoritos, resumen de historia y ubicación |
| Nuestra Carta | `menu.html` | Todos los platos **con precios**, agrupados por categoría |
| Nuestra Historia | `historia.html` | Relato, línea de tiempo y valores del negocio |
| Ubicación | `ubicacion.html` | Mapa, dirección, horarios y cómo llegar |
| Contacto | `contacto.html` | WhatsApp, teléfono, correo, redes y formulario |
| Error 404 | `404.html` | Página para direcciones que no existen |

## Cómo está hecho

HTML, CSS y JavaScript puros. **Sin frameworks, sin dependencias, sin paso de
compilación.** Para ver el sitio basta con abrir `index.html`; para publicarlo,
basta con subir la carpeta.

Se hizo así a propósito: es un sitio que cambia poco, y quien lo mantenga no
necesita instalar Node, npm ni aprender ninguna herramienta. Un precio se
cambia abriendo un archivo y escribiendo el número nuevo.

```
Website/
├── index.html · menu.html · historia.html · ubicacion.html · contacto.html
├── 404.html
├── css/estilos.css          Todos los estilos. Los colores están arriba del todo.
├── js/principal.js          Menú móvil, portada rotativa, horarios, formulario.
│                            👉 El WhatsApp y los horarios se configuran aquí.
├── assets/
│   ├── imagenes/            Fotos, cada una en su carpeta (con su LEEME.txt)
│   │   ├── logo/  hero/  productos/  local/  historia/
│   │   └── compartir.jpg    Imagen que se ve al compartir el enlace
│   └── iconos/              Iconos de pestaña y de celular
├── herramientas/
│   └── optimizar-imagenes.ps1   Achica las fotos pesadas del celular
│                            (PowerShell: corre en Windows, no en Mac)
├── sitemap.xml · robots.txt · site.webmanifest
├── COMO-EDITAR.md           👈 Guía completa de edición
└── README.md
```

## Decisiones que conviene conocer

**Los colores salen del logo.** Se midieron sobre `logo.png` píxel por píxel y
están definidos como variables al inicio de `css/estilos.css`. Si cambia el
logo, se vuelven a sacar los colores y se cambian ahí; el resto del sitio los
hereda solo.

| | | |
|---|---|---|
| `--color-marca` | `#D43E0B` | Rojo de la vincha y el delantal |
| `--color-acento` | `#FDBA11` | Amarillo de "PAPA" y de la mascota |
| `--color-oscuro` | `#2B0F01` | Café del contorno del cartel |
| `--color-turquesa` | `#04BDB5` | Turquesa del borde |

**Los precios están en el HTML, no en un archivo de datos.** Así Google los
puede leer y se ven aunque falle el JavaScript — que es justamente el
contenido por el que la gente entra al sitio.

**El formulario de contacto abre WhatsApp** con el mensaje ya escrito, en vez
de enviar un correo. Un sitio estático no tiene servidor que reciba mensajes, y
esta forma no obliga a contratar ningún servicio externo. En `COMO-EDITAR.md`
está explicado cómo cambiarlo por correo si algún día se prefiere.

**Si falta una foto, no se rompe nada.** En su lugar aparece un recuadro con el
nombre del archivo que falta, para saber cuál hay que agregar.

## Ver el sitio en la computadora

Doble clic en `index.html` alcanza para revisar casi todo.

Para probarlo tal como se verá publicado (mapa y vista previa de enlaces
incluidos), conviene levantar un servidor local:

En Windows (PowerShell):

```powershell
cd "c:\Users\darku\Documents\Projects\Website"
python -m http.server 8000
```

En Mac (Terminal):

```bash
cd ~/Documents/Projects/Website
python3 -m http.server 8000
```

Y abrir <http://localhost:8000>

## Publicar

Arrastrar la carpeta completa a <https://app.netlify.com/drop>. Da una
dirección con HTTPS al instante y permite conectar un dominio propio después.

Antes de publicar, revisar la lista de pendientes que está al inicio de
[COMO-EDITAR.md](COMO-EDITAR.md).
