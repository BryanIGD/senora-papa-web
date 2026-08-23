# Cómo editar la página web de Señora Papa

Guía para cambiar el contenido del sitio sin saber programar.

**Regla de oro:** antes de tocar cualquier archivo, haz una copia de seguridad
de la carpeta completa. Si algo sale mal, restauras la copia y listo.

Para editar los archivos sirve el **Bloc de notas** de Windows, pero es mucho
más cómodo usar **Visual Studio Code** (gratis, en <https://code.visualstudio.com>),
porque colorea el texto y es más difícil equivocarse.

---

## ⚠️ ANTES DE PUBLICAR: lo que falta por completar

Ya solo queda **un** dato de ejemplo por cambiar: el dominio.

| Buscar esto | Reemplazar por | Dónde aparece |
|---|---|---|
| `www.ejemplo.com.ec` | El dominio real | Las 5 páginas + sitemap.xml + robots.txt |

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

## 3. Cambiar el WhatsApp y los horarios

Estos **no** se cambian en las páginas. Se cambian **una sola vez** en
**`js/principal.js`**, arriba del todo:

```js
var NEGOCIO = {
  whatsapp: '593000000000',
  ...
  horarios: {
    domingo:   ['11:00', '20:00'],
    lunes:     ['10:00', '22:00'],
    ...
  }
};
```

### El número de WhatsApp

Va el código de país + el número, **todo junto**, sin `+`, sin espacios, sin
guiones y **sin el 0 inicial**:

| Número local | Se escribe |
|---|---|
| `098 765 4321` | `593987654321` |
| `099 123 4567` | `593991234567` |

### Los horarios

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

Las fotos van en `assets/imagenes/`, cada una en su carpeta. En cada carpeta
hay un `LEEME.txt` que explica qué va ahí y en qué tamaño.

Resumen:

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

La **lista completa** de las fotos que la página está esperando está en
`assets/imagenes/productos/LEEME.txt`.

Mientras una foto no exista, en su lugar sale un recuadro con el nombre del
archivo que falta. No es un error: es para que sepas cuál te falta. Apenas
dejes el archivo con el nombre correcto en la carpeta correcta, aparece sola.

### Si las fotos vienen con fondo verde

Las fotos de los platos están tomadas sobre un fondo verde (croma). Ese verde
hay que quitarlo antes de subirlas, si no el plato se ve con un recuadro verde
alrededor.

Déjalas en `assets/imagenes/productos/` tal como estén y ejecuta:

```
herramientas\quitar-fondo-verde.ps1
```

(clic derecho sobre el archivo → **Ejecutar con PowerShell**)

El script hace cuatro cosas: quita el verde, suaviza los bordes para que el
envase no quede recortado a lo bruto, **elimina el reflejo verdoso que el fondo
deja sobre el envase blanco**, y reduce el peso del archivo. También renombra
la foto al nombre que espera la página.

No toca las fotos que ya están limpias, así que se puede ejecutar las veces que
haga falta. Los archivos originales no se borran: se guardan en `originales/`.

> `originales/` es solo un respaldo. No hace falta subirla al servidor y se
> puede borrar sin que pase nada.

### Las fotos del celular pesan demasiado

Una foto de celular pesa entre 3 MB y 8 MB, unas 20 veces más de lo que
debería. Si subes el sitio así, va a tardar muchísimo en abrir con datos
móviles y la gente se va antes de que cargue.

Para arreglarlo, haz doble clic en:

```
herramientas/optimizar-imagenes.ps1
```

(o clic derecho → *Ejecutar con PowerShell*). Ajusta todas las fotos de una
sola vez y guarda las originales en una carpeta aparte por si acaso.

También se puede hacer a mano en <https://squoosh.app>.

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

El sitio no necesita servidor especial ni base de datos: son archivos sueltos.

**La opción más simple (gratis):**

1. Entra a <https://app.netlify.com/drop>
2. Arrastra la carpeta `Website` completa a la ventana.
3. Listo: te da una dirección al instante, con candado de seguridad (HTTPS).

Después puedes conectar un dominio propio (`señorapapa.com.ec` o similar)
desde el panel de Netlify.

**Alternativa igual de buena:** <https://pages.cloudflare.com>

### Para actualizar después

Cambias los archivos en tu computadora y vuelves a arrastrar la carpeta. Se
reemplaza todo.

### Cuando ya esté publicado

1. Reemplaza `www.ejemplo.com.ec` por el dominio real en las 5 páginas,
   en `sitemap.xml` y en `robots.txt`.
2. Registra el sitio en <https://search.google.com/search-console> para que
   Google lo encuentre.
3. Comprueba que el enlace se vea bien al compartirlo por WhatsApp.
4. Verifica los datos de Google en
   <https://search.google.com/test/rich-results>

---

## 9. El formulario de contacto

El formulario de `contacto.html` **no envía correos**. Arma el mensaje con lo
que escribió el cliente y abre WhatsApp con el texto ya listo, para que solo
tenga que darle a enviar.

Se hizo así a propósito: un sitio de archivos sueltos no tiene un servidor
propio que reciba mensajes, y esta forma no necesita contratar ni configurar
nada. Además llega al celular que ya se revisa todos los días.

### Si prefieres recibirlos por correo

1. Crea una cuenta gratis en <https://web3forms.com> (o <https://formspree.io>).
   Te dan una clave.
2. En `contacto.html`, busca la línea:

   ```html
   <form data-formulario-whatsapp novalidate>
   ```

3. Cámbiala por:

   ```html
   <form action="https://api.web3forms.com/submit" method="POST">
     <input type="hidden" name="access_key" value="TU-CLAVE-AQUI">
   ```

4. Cambia el texto del botón y quita el aviso verde que habla de WhatsApp.

---

## 10. Problemas frecuentes

**Cambié algo y la página se ve rota.**
Seguramente se borró un `<` o un `>`. Restaura la copia de seguridad y hazlo
de nuevo con más calma.

**Puse la foto pero no aparece.**
Casi siempre es el nombre. Revisa que coincida **exactamente** con el del HTML:
sin mayúsculas, sin tildes, sin espacios. Ojo también con `.jpg` vs `.jpeg`:
son distintos.

**Cambié el precio y sigo viendo el viejo.**
Es la memoria del navegador. Presiona **Ctrl + F5** para recargar de cero.

**El botón de WhatsApp no abre nada.**
Revisa el número en `js/principal.js`. Tiene que ir junto, sin `+`, sin
espacios y sin el 0 del inicio: `593987654321`.

**El cartel dice "Cerrado" y sí estamos abiertos.**
Revisa los horarios en `js/principal.js`. Se calcula con la hora de Ecuador,
no con la hora del celular de quien mira la página.
