# Señora Papa — Sitio web

Sitio web estático del restaurante **Señora Papa** (Latacunga, Cotopaxi, Ecuador).

Es un sitio informativo: muestra la carta con precios, la ubicación y las
formas de contacto. **No procesa pagos ni recibe pedidos.**

🌐 **En línea: <https://senorapapa.com>**

👉 **Para editar el contenido, lee [COMO-EDITAR.md](COMO-EDITAR.md).**

---

## Qué tiene

| Página | Archivo | Contenido |
|---|---|---|
| Inicio | `index.html` | Portada rotativa, categorías, favoritos, resumen de historia y ubicación |
| Nuestra Carta | `menu.html` | Todos los platos **con precios**, agrupados por categoría |
| Nuestra Historia | `historia.html` | Relato, línea de tiempo y valores del negocio |
| Ubicación | `ubicacion.html` | Mapa, dirección, horarios y cómo llegar |
| Contacto | `contacto.html` | Redes sociales, horarios y preguntas frecuentes |
| Error 404 | `404.html` | Página para direcciones que no existen |

## Cómo está hecho

HTML, CSS y JavaScript puros. **Sin frameworks, sin dependencias, sin paso de
compilación.** Para ver el sitio basta con abrir `index.html`; para publicarlo,
basta con hacer `git push`.

Se hizo así a propósito: es un sitio que cambia poco, y quien lo mantenga no
necesita instalar Node, npm ni aprender ninguna herramienta. Un precio se
cambia abriendo un archivo y escribiendo el número nuevo.

```
Website/
├── index.html · menu.html · historia.html · ubicacion.html · contacto.html
├── 404.html
├── css/estilos.css          Todos los estilos. Los colores están arriba del todo.
├── js/principal.js          Menú móvil, portada rotativa, horarios, año del pie.
│                            👉 Los horarios se configuran aquí.
├── assets/
│   ├── imagenes/            Fotos, cada una en su carpeta
│   │   ├── logo/  hero/  productos/  local/  historia/
│   │   └── compartir.jpg    Imagen que se ve al compartir el enlace
│   └── iconos/              Iconos de pestaña y de celular
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

**No hay formulario de contacto, ni teléfono, ni correo publicados.** El
contacto es por Facebook, Instagram y TikTok, que es donde el negocio ya
responde todos los días. Un sitio estático tampoco tendría servidor que reciba
mensajes, así que no se pierde nada y no hay que contratar ningún servicio.

**Si falta una foto, no se rompe nada.** En su lugar aparece un recuadro con el
nombre del archivo que falta, para saber cuál hay que agregar.

## Ver el sitio en la computadora

Doble clic en `index.html` alcanza para revisar casi todo.

Para probarlo tal como se verá publicado (mapa y vista previa de enlaces
incluidos), conviene levantar un servidor local:

En Windows (PowerShell):

```powershell
cd "$HOME\Documents\Projects\senora-papa-web"
python -m http.server 8000
```

En Mac (Terminal):

```bash
cd ~/Documents/Projects/senora-papa-web
python3 -m http.server 8000
```

Y abrir <http://localhost:8000>

## Publicar

El sitio está en **Cloudflare Pages**, conectado a este repositorio de GitHub.
No hay que entrar a ningún panel: cada `git push` a `main` republica
<https://senorapapa.com> en unos 30 segundos.

Si una publicación sale mal, en el panel de Cloudflare cada versión anterior
tiene un botón para volver a ella en un clic.
