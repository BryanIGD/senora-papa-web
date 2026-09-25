# Señora Papa — Sitio web del restaurante

[🇨🇦 English](README.md) · 🇪🇨 Español

Sitio web en producción de **Señora Papa**, un restaurante familiar de comida
rápida en Latacunga, Ecuador, hecho con **HTML, CSS y JavaScript puro**: sin
frameworks, sin dependencias y sin paso de compilación.

**🌐 En línea: [senorapapa.com](https://senorapapa.com)**

![HTML5](https://img.shields.io/badge/HTML5-E34F26?logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?logo=css3&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?logo=javascript&logoColor=black)
![Cloudflare Pages](https://img.shields.io/badge/Cloudflare_Pages-F38020?logo=cloudflare&logoColor=white)
![Accesibilidad 100](https://img.shields.io/badge/Lighthouse_accesibilidad-100-0CCE6B)

<p align="center">
  <img src="docs/capturas/inicio-escritorio.jpg" alt="Página de inicio en escritorio" width="68%">
  &nbsp;
  <img src="docs/capturas/inicio-movil.jpg" alt="Página de inicio en celular" width="24%">
</p>

---

## El problema

El restaurante no tenía presencia en internet más allá de las redes sociales,
y los clientes preguntaban siempre lo mismo: *qué hay en la carta, cuánto
cuesta y dónde queda*. El sitio responde esas tres preguntas rápido, desde el
celular y con datos móviles, y es lo bastante simple para que alguien sin
conocimientos técnicos lo mantenga al día.

## Qué tiene

| Página | Contenido |
|---|---|
| **Inicio** | Portada rotativa, categorías, favoritos, mapa y estado "abierto ahora" |
| **Nuestra Carta** | 31 productos en 7 categorías, todos con foto y precio |
| **Nuestra Historia** | La historia del negocio en línea de tiempo, del puesto de 2015 al local propio |
| **Ubicación** | Mapa, cómo llegar y horarios con el día de hoy resaltado |
| **Contacto** | Redes sociales y preguntas frecuentes |
| **404** | Página de error propia que devuelve al inicio o a la carta |

<p align="center">
  <img src="docs/capturas/carta-escritorio.jpg" alt="La carta en escritorio" width="68%">
  &nbsp;
  <img src="docs/capturas/carta-movil.jpg" alt="La carta en celular" width="24%">
</p>

## Aspectos técnicos destacados

**Accesibilidad desde el diseño, no como parche**
- El carrusel sigue el patrón WAI-ARIA: flechas del teclado, pausa con el
  cursor o el foco, pausa cuando la pestaña no está visible, y las
  diapositivas ocultas salen del orden de tabulación.
- Respeta `prefers-reduced-motion`: el carrusel deja de girar solo.
- Los colores de marca tienen variantes `-texto` más oscuras para que todo
  par texto/fondo cumpla el contraste **WCAG AA (4,5:1)**.
- Áreas táctiles de al menos 24×24 px (WCAG 2.2), enlace para saltar al
  contenido, regiones semánticas, `aria-current` en la navegación y menú
  móvil que se cierra con Escape.

**Estado "Abierto ahora" con la hora de Ecuador**
- Los horarios viven en un solo objeto de JS. El script calcula si el local
  está abierto **en la zona horaria de Ecuador** (`America/Guayaquil`), no en
  la de quien visita, así que alguien en el extranjero ve la respuesta
  correcta.
- Contempla horarios que cierran después de medianoche y días cerrados, con
  un cálculo manual de UTC−5 para navegadores antiguos.

**SEO y búsqueda local**
- JSON-LD de `schema.org/Restaurant` con dirección, coordenadas y horarios,
  para que el sitio pueda aparecer como resultado enriquecido en Google.
- Etiquetas Open Graph por página para la vista previa en WhatsApp y
  Facebook, URLs canónicas, `sitemap.xml` y `robots.txt`.
- Los precios están **en el HTML, no los carga JS**: Google los lee y se ven
  aunque falle un script. Son justamente lo que la gente viene a buscar.

**Rendimiento**
- `width`/`height` explícitos en cada imagen → **cero saltos de diseño** (CLS 0).
- `srcset` en las fotos de portada, `fetchpriority="high"` en la imagen LCP y
  carga diferida nativa en el resto.
- El resaltado de categorías de la carta usa `IntersectionObserver`, no
  eventos de scroll.
- JavaScript total: **un archivo de 15 KB**, cargado con `defer`.

**Resistencia a fallos**
- Si falta una foto, aparece un recuadro con el nombre del archivo en lugar
  del ícono de imagen rota, para saber exactamente cuál agregar.
- Hoja de estilos de impresión: la carta se puede imprimir legible.

## Lighthouse

| | Rendimiento | Accesibilidad | Buenas prácticas | SEO |
|---|:-:|:-:|:-:|:-:|
| **Celular** | 83 – 93 | 100 | 100 | 100 |
| **Escritorio** | 98 – 99 | 100 | 100 | 100 |

<sub>Lighthouse 9, medido en las cinco páginas de contenido (con limitación
simulada). La 404 es `noindex` a propósito y no entra en la cifra de SEO.</sub>

## Decisiones de ingeniería

**¿Por qué sin framework?** Son cinco páginas de contenido que cambian pocas
veces al año. Un framework sumaría un proceso de compilación, actualizaciones
de dependencias y herramientas de Node que quien mantiene el sitio tendría
que aprender. Con HTML puro, cambiar un precio es abrir el archivo, cambiar
el número y hacer push.

**¿Por qué sin formulario de contacto?** Un sitio estático no tiene servidor
que reciba mensajes, y el negocio ya responde todos los días por Facebook,
Instagram y TikTok. Un formulario que nadie lee es peor que no tenerlo, así
que Contacto lleva a los canales donde sí contestan.

**¿Por qué la paleta sale del logo?** Los colores se tomaron del logo y del
menú impreso del local y se centralizaron como variables de CSS, para que la
web y la carta física se vean como la misma marca. Cambiar el tema es editar
un solo bloque al inicio de la hoja de estilos.

## Estructura

```
senora-papa-web/
├── sitio/                  ← todo lo que se publica
│   ├── index.html · menu.html · historia.html · ubicacion.html · contacto.html · 404.html
│   ├── css/estilos.css     Una sola hoja de estilos; las variables van arriba
│   ├── js/principal.js     Menú móvil, carrusel, categorías y horarios
│   ├── assets/             Imágenes e íconos
│   └── sitemap.xml · robots.txt · site.webmanifest
├── docs/capturas/          Capturas para este README
├── README.md
└── README.es.md
```

### Colores de marca

Definidos al inicio de `sitio/css/estilos.css`. Si cambia el logo, se
vuelven a sacar los colores y se cambian ahí; el resto del sitio los hereda.

| Variable | Color | Uso |
|---|---|---|
| `--color-marca` | `#35A9A1` | Turquesa principal: franjas, íconos, pie |
| `--color-naranja-texto` | `#C24720` | Precios y botones |
| `--color-acento` | `#FDE05F` | Amarillo de paneles y etiquetas |
| `--color-carbon` | `#2B1508` | Texto principal |

## Verlo en la computadora

```bash
git clone https://github.com/BryanIGD/senora-papa-web.git
cd senora-papa-web/sitio
python3 -m http.server 8000
```

Y abrir <http://localhost:8000>. No hay nada que instalar.

## Publicación

El sitio está en **Cloudflare Pages**, con el directorio de salida
configurado en `sitio`. Cada push a `main` se publica en unos 30 segundos, y
cualquier versión anterior se puede restaurar con un clic.

## Próximos pasos

- **Versión en inglés**: en curso, con `hreflang` y selector de idioma.
- **Una sola fuente para los horarios**: hoy se repiten en el JS, en la
  tabla de Ubicación y en el JSON-LD; generar los dos últimos desde el objeto
  de JS evitaría que se desincronicen.
- **Fuentes propias e imágenes WebP/AVIF**: lo que falta para superar 90 de
  rendimiento en celular en la página de inicio.

## Créditos

Hecho por [Bryan](https://github.com/BryanIGD).
El código se comparte como parte de un portafolio. El nombre **Señora Papa**,
el logo, las fotos y el contenido de la carta pertenecen al restaurante y no
se pueden reutilizar.
