# Cómo editar la página web de Señora Papa

Guía para cambiar el contenido del sitio sin saber programar.

**Regla de oro:** ya no hace falta copiar la carpeta a mano. El proyecto está
en Git, que guarda cada versión anterior. Si algo sale mal y todavía no lo has
subido, esto deshace tus cambios y deja el archivo como estaba:

```bash
git restore nombre-del-archivo.html
```

Para editar los archivos sirve el **Bloc de notas** de Windows, pero es mucho
más cómodo usar **Visual Studio Code** (gratis, en <https://code.visualstudio.com>),
porque colorea el texto y es más difícil equivocarse.

---

## ✅ El sitio ya está publicado

Está en línea en <https://senorapapa.com>. Ya no quedan datos de ejemplo por
reemplazar: los precios, la dirección, los horarios y las redes son los reales.

**Las tres redes ya están puestas:**

```
https://www.facebook.com/people/Se%C3%B1ora-Papa/61593310995960/
https://www.instagram.com/senora.papa.latacunga
https://tiktok.com/@senora.papa
```

Ya están puestos y **no hay que tocarlos**: el nombre del negocio, la dirección
(Av. Benjamín Terán y Av. Amazonas), la referencia (ex redondel de la FAE), las
coordenadas del mapa, los colores y **toda la carta con sus precios**, que está
copiada del menú impreso del local.

> **Si algún día cambia el enlace de una red:** aparece en las 5 páginas (en el
> pie) y además en el bloque de datos del final de `ubicacion.html`. Hay que
> cambiarlo en todos esos sitios, o el botón lleva a una página de error.

Además falta:

- [ ] Las **3 fotos de portada** (`hero-1.jpg`, `hero-2.jpg`, `hero-3.jpg`).
      Son las grandes que rotan arriba en la página de inicio, y hoy salen
      como recuadros vacíos. Van horizontales, 1920×1080.
- [ ] Las fotos de **`local/equipo.jpg`** y **`historia/fundadores.jpg`**
- [ ] El **precio del agua y la gaseosa** (hoy dicen "Consultar")
- [ ] La **historia real**: quién fundó el negocio y en qué años
- [ ] Los textos de **"En carro"** y **"En bus"** en `ubicacion.html`
- [ ] Registrar el local en **Google Business** (ver sección 4)

**La carta ya está completa:** los 24 platos, los 5 extras y las 6 portadas de
categoría tienen su foto.

---

## 1. Cambiar un precio

Los precios están en **`menu.html`**.

1. Abre `menu.html`.
2. Busca el nombre del plato con **Ctrl + F**.
3. Unas líneas más abajo vas a ver:

   ```html
   <span class="precio">$1,00</span>
   ```

4. Cambia **solo el número**. Deja el `$`, las comillas y el resto igual.
5. Guarda con **Ctrl + S**.

> Los precios usan **coma** (`$1,00`), igual que el menú impreso del local.
> Manténlo así para que la página y el menú se vean iguales.

> **Ojo con estos tres:** Papipollo, Triple 2 y Combo 1 también aparecen en la
> página de inicio, en la sección "Nuestros favoritos". Si les cambias el
> precio, acuérdate de cambiarlo también en `index.html`.

> Las **bebidas** (gaseosa y agua) dicen "Consultar" porque el menú impreso no
> trae el precio. Cuando lo tengas, reemplaza esa palabra por el precio.

---

## 2. Agregar, quitar o cambiar un plato

### Agregar un plato

En `menu.html`, copia un bloque completo como este (desde `<article` hasta
`</article>`), pégalo justo debajo, y cambia lo que está marcado:

```html
<article class="tarjeta-producto">
  <div class="marco-img" data-etiqueta="nombre-del-archivo.jpg">
    <img src="assets/imagenes/productos/nombre-del-archivo.jpg"
         alt="Nombre del Plato" width="600" height="450" loading="lazy">
  </div>
  <div class="tarjeta-producto__cuerpo">
    <h3 class="tarjeta-producto__nombre">Nombre del Plato</h3>
    <p class="tarjeta-producto__descripcion">La descripción corta va aquí.</p>
    <div class="tarjeta-producto__pie">
      <span class="precio">$0.00</span>
    </div>
  </div>
</article>
```

Cambia:
- `nombre-del-archivo.jpg` → **en los dos lugares** donde aparece
- `Nombre del Plato` → **en los dos lugares** donde aparece
- La descripción y el precio

### Quitar un plato

Borra el bloque completo, desde `<article class="tarjeta-producto">` hasta su
`</article>`.

### Ponerle una etiqueta a un plato

Agrega una de estas líneas justo después de la línea `<div class="marco-img"...`:

```html
<span class="etiqueta etiqueta--flotante">Más pedido</span>
<span class="etiqueta etiqueta--flotante etiqueta--acento">Picante</span>
<span class="etiqueta etiqueta--flotante etiqueta--fresca">Natural</span>
```

---

## 3. Cambiar los horarios

**No** se cambian en las páginas. Se cambian en **`js/principal.js`**, arriba
del todo:

```js
var NEGOCIO = {
  horarios: {
    domingo:   null,
    lunes:     ['10:00', '22:00'],
    martes:    ['10:00', '22:00'],
    ...
  }
};
```

### Cómo se escriben

Se usan en formato de 24 horas. Un día cerrado se escribe `null`:

```js
domingo: null,
```

> **Ojo:** los horarios están en **dos lugares**. Si los cambias en
> `js/principal.js`, cámbialos también en la tabla de `ubicacion.html`
> y en el bloque de datos de Google al final de ese mismo archivo.
> El de `principal.js` es el que calcula el cartelito de "Abierto ahora".

---

## 4. El mapa

**El mapa ya apunta al local**, con estas coordenadas:

```
-0.925556, -78.620611        (0°55'32.0"S  78°37'14.2"W)
```

Están puestas en el mapa de `ubicacion.html`, en el mapa chico de `index.html`,
en los botones "Cómo llegar" y "Abrir en Google Maps", y en el bloque de datos
para Google al final de `ubicacion.html`. No hay que cambiarlas.

### Lo que sí falta: registrar el local en Google Business

Hoy el mapa muestra un **pin simple**. Si registras el negocio gratis en
<https://business.google.com>, el mapa pasa a mostrar el nombre "Señora Papa",
las fotos, los horarios y las reseñas.

Y lo más importante: es lo que hace que el local aparezca cuando alguien busca
**"salchipapas Latacunga"** desde el celular. De todo lo que hay en esta guía,
esto es lo que más clientes nuevos trae — mucho más que cualquier cambio en la
página. Es gratis y toma unos minutos.

Una vez registrado, si quieres cambiar el mapa por el de la ficha del negocio:

1. Entra a <https://www.google.com/maps> y busca "Señora Papa".
2. Clic en **Compartir** → pestaña **Insertar un mapa** → **COPIAR HTML**.
3. En `ubicacion.html`, busca el comentario `<<< AQUÍ VA EL MAPA >>>` y
   reemplaza el `<iframe ...></iframe>` que está debajo por el que copiaste.
4. Agrégale `loading="lazy"` al iframe nuevo, para que la página cargue rápido.

### Si algún día se muda el local

Para sacar las coordenadas nuevas: en Google Maps, **clic derecho sobre el
punto exacto**. Arriba aparecen los dos números. Hay que cambiarlos en los
cinco lugares mencionados arriba (busca `-0.925556` en los archivos).

---

## 5. Cambiar las fotos

Las fotos van en `assets/imagenes/`, cada una en su carpeta:

| Carpeta | Qué va | Tamaño | Peso |
|---|---|---|---|
| `logo/` | El logo | PNG transparente | — |
| `hero/` | Las 3 fotos grandes de portada | 1920×1080 | < 400 KB |
| `productos/` | Una foto por plato | 1200×900 | < 250 KB |
| `local/` | Fachada, interior, equipo | 1600 de ancho | < 300 KB |
| `historia/` | Fotos antiguas | libre | < 300 KB |

**El nombre del archivo tiene que coincidir exactamente** con el que está
escrito en el HTML. Todo en minúsculas, sin tildes, sin espacios, con guiones:
`papipollo.jpg`, `mixta-1.jpg`, `combo-2.jpg`.

Para saber qué fotos espera la página, búscalas en el HTML: cada una aparece
como `<img src="assets/imagenes/...">`.

Mientras una foto no exista, en su lugar sale un recuadro con el nombre del
archivo que falta. No es un error: es para que sepas cuál te falta. Apenas
dejes el archivo con el nombre correcto en la carpeta correcta, aparece sola.

### Si las fotos vienen con fondo verde

Las fotos de los platos están tomadas sobre un fondo verde (croma). Ese verde
hay que quitarlo antes de subirlas, si no el plato se ve con un recuadro verde
alrededor.

Las fotos que ya están en el sitio vienen limpias. Si algún día tomas fotos
nuevas sobre el fondo verde, se lo puedes quitar en <https://www.photopea.com>
(gratis, en el navegador) o en <https://www.remove.bg>.

> Esto antes lo hacía un script de PowerShell que ya no está en el proyecto,
> porque solo corría en Windows. Si algún día vuelve a hacer falta, sigue
> guardado en el historial de Git:
> `git log --diff-filter=D -- herramientas/`

### Las fotos del celular pesan demasiado

Una foto de celular pesa entre 3 MB y 8 MB, unas 20 veces más de lo que
debería. Si subes el sitio así, va a tardar muchísimo en abrir con datos
móviles y la gente se va antes de que cargue.

Para arreglarlo, pasa cada foto por <https://squoosh.app>: la abres, eliges
**JPG** a la derecha, bajas la calidad hasta un 75 % y descargas. Una foto de
5 MB queda en unos 200 KB y a simple vista se ve igual.

En Mac también sirve la app **Vista Previa**: *Herramientas → Ajustar tamaño*.

---

## 6. Cambiar los colores

Todos los colores del sitio están en **un solo lugar**: arriba de
`css/estilos.css`, en el bloque que dice `:root`.

Están **tomados del menú impreso y del logo**. El menú usa un sistema muy
claro, y la página lo repite igual:

| En el menú impreso | En la página | Variable | Color |
|---|---|---|---|
| El fondo turquesa | Franjas, íconos, pie de página | `--color-marca` | `#44A69D` |
| Las burbujas de precio y los títulos naranjas | Precios y botones | `--color-naranja-texto` | `#C24720` |
| Los paneles amarillos | Etiquetas y detalles | `--color-acento` | `#FBD24E` |
| El texto café oscuro | Todo el texto | `--color-carbon` | `#2B1508` |

Por eso el **turquesa es el color principal** (es el que más se ve) y el
**naranja es el que llama la atención** (precios y botones). Es exactamente la
misma lógica del menú que está en el local.

Si algún día se rediseña el menú, hay que volver a sacar los colores del diseño
nuevo y cambiarlos aquí. No hace falta tocar nada más: todo el sitio los usa
desde este bloque.

> **Cuidado con el contraste.** Varias variables tienen una versión "-texto"
> más oscura (`--color-marca-texto`, `--color-naranja-texto`). Existen a
> propósito: los colores originales del menú se ven bien en un cartel grande,
> pero en letra chica sobre fondo blanco no se leen. Si igualas la versión
> normal con la "-texto", el sitio se vuelve difícil de leer para mucha gente.
>
> Por lo mismo, sobre el fondo turquesa el texto va **oscuro**, nunca blanco.

---

## 7. Cambiar los textos de "Nuestra Historia"

`historia.html` es la página que **más hay que personalizar**. Los textos que
están ahí son un borrador con la estructura armada, pero la historia real hay
que escribirla.

Lo que mejor funciona son los **detalles concretos**:

> ✅ "Mi mamá empezó vendiendo salchipapas en una carretilla frente al mercado
> Cerrado, con una olla prestada."
>
> ❌ "Somos una empresa con amplia trayectoria y vocación de servicio."

El primero se recuerda y se cuenta. El segundo lo dice cualquiera. Escríbelo
como se lo contarías a un cliente en el mostrador.

---

## 8. Publicar el sitio

El sitio vive en **Cloudflare Pages** (gratis) y está conectado al repositorio
de GitHub.

**No hay que arrastrar carpetas ni entrar a ningún panel para actualizarlo.**
Cada vez que subes un cambio desde la terminal:

```bash
git add .
git commit -m "Lo que cambiaste"
git push
```

Cloudflare lo detecta solo y republica el sitio en unos 30 segundos. Eso es
todo.

### Si un cambio sale mal

En el panel de Cloudflare, dentro del proyecto `senora-papa-web`, cada
publicación anterior tiene un botón para volver a ella en un clic. No se pierde
nada.

### Cosas que se hacen una sola vez

1. Registrar el sitio en <https://search.google.com/search-console> y subir ahí
   el `sitemap.xml`, para que Google lo encuentre.
2. Comprobar que el enlace se vea bien al compartirlo por Facebook o Instagram.
3. Verificar los datos del negocio en
   <https://search.google.com/test/rich-results>

---

## 9. La página de contacto

`contacto.html` **no tiene formulario, ni teléfono, ni correo.** El contacto es
por redes sociales, que es donde el negocio ya responde todos los días.

Se hizo así a propósito: un sitio de archivos sueltos no tiene servidor que
reciba mensajes, y un formulario que no contesta nadie es peor que no tenerlo.

### Cambiar los enlaces de las redes

Las tres direcciones aparecen **en las 5 páginas** (en el pie de página) y
además en el cuerpo de `contacto.html`. Si cambia alguna, hay que buscarla y
reemplazarla en todas:

```
https://www.facebook.com/people/Se%C3%B1ora-Papa/61593310995960/
https://www.instagram.com/senora.papa.latacunga
https://tiktok.com/@senora.papa
```

Desde la terminal se reemplazan todas de una vez:

```bash
grep -rl 'senora.papa.latacunga' --include='*.html' . \
  | xargs sed -i '' 's|senora.papa.latacunga|LA-CUENTA-NUEVA|g'
```

---


## 10. Problemas frecuentes

**Cambié algo y la página se ve rota.**
Seguramente se borró un `<` o un `>`. Si todavía no lo subiste, deshazlo con
`git restore nombre-del-archivo.html` y vuelve a hacerlo con más calma.

**Puse la foto pero no aparece.**
Casi siempre es el nombre. Revisa que coincida **exactamente** con el del HTML:
sin mayúsculas, sin tildes, sin espacios. Ojo también con `.jpg` vs `.jpeg`:
son distintos.

**Cambié el precio y sigo viendo el viejo.**
Es la memoria del navegador. Presiona **Ctrl + F5** para recargar de cero.

**El cartel dice "Cerrado" y sí estamos abiertos.**
Revisa los horarios en `js/principal.js`. Se calcula con la hora de Ecuador,
no con la hora del celular de quien mira la página.
