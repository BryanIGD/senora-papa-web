/* ==========================================================================
   PRINCIPAL.JS
   Todo el comportamiento del sitio en un solo archivo. Sin librerías.
   --------------------------------------------------------------------------
   CONTENIDO
     0. Datos del negocio     <- AQUÍ SE CAMBIAN LOS HORARIOS
     1. Imágenes que faltan
     2. Menú del celular
     3. Sombra del encabezado
     4. Portada rotativa (hero)
     5. Barra de categorías de la carta
     6. Horario: día de hoy y estado abierto/cerrado
     7. Año automático en el pie de página
   ========================================================================== */

'use strict';


/* ==========================================================================
   0. DATOS DEL NEGOCIO
   --------------------------------------------------------------------------
   Este es el ÚNICO lugar del sitio donde se cambian los horarios.
   De aquí salen tres cosas automáticamente:
     * el texto "Hoy: 10:00 a 22:00" de la barra de arriba
     * el cartel de "Abierto ahora" / "Cerrado"
     * el día resaltado en la tabla de la página de Ubicación

   OJO: la tabla de horarios de ubicacion.html se escribe aparte. Si cambias
   los horarios aquí, cámbialos también allá.
   ========================================================================== */

var NEGOCIO = {

  /* Horarios de atención.
     Formato de 24 horas: '10:00' es 10 de la mañana, '22:00' las 10 de la noche.
     Si un día no se abre, se escribe:  null                             */
  horarios: {
    domingo:   null,
    lunes:     ['10:00', '22:00'],
    martes:    ['10:00', '22:00'],
    miercoles: ['10:00', '22:00'],
    jueves:    ['10:00', '22:00'],
    viernes:   ['10:00', '22:00'],
    sabado:    ['10:00', '22:00']
  }
};


/* Nombres de los días en el orden que usa JavaScript (0 = domingo) */
var DIAS = ['domingo', 'lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado'];


/* --------------------------------------------------------------------------
   Devuelve la fecha y hora actuales EN ECUADOR, sin importar desde qué país
   se esté viendo la página. Ecuador es UTC-5 todo el año (no cambia la hora
   en invierno ni en verano).
   -------------------------------------------------------------------------- */
function horaEnEcuador() {
  var ahora = new Date();
  try {
    return new Date(ahora.toLocaleString('en-US', { timeZone: 'America/Guayaquil' }));
  } catch (e) {
    /* Si el navegador es muy viejo y no reconoce zonas horarias,
       se calcula UTC-5 a mano. */
    return new Date(ahora.getTime() + (ahora.getTimezoneOffset() - 300) * 60000);
  }
}

/* Convierte '14:30' en minutos desde la medianoche (870) */
function aMinutos(hhmm) {
  var partes = hhmm.split(':');
  return parseInt(partes[0], 10) * 60 + parseInt(partes[1], 10);
}


/* ==========================================================================
   1. IMÁGENES QUE FALTAN
   --------------------------------------------------------------------------
   Mientras no se hayan agregado las fotos, en lugar de mostrar el ícono de
   imagen rota se deja el fondo degradado con el nombre del plato encima.
   Así la página se puede revisar completa desde el primer día.
   ========================================================================== */

function manejarImagenesFaltantes() {
  var imagenes = document.querySelectorAll('.marco-img > img');

  Array.prototype.forEach.call(imagenes, function (img) {
    function marcarFalla() {
      if (img.parentElement) img.parentElement.classList.add('sin-imagen');
    }

    /* La imagen ya terminó de cargar y falló (pasa cuando el script
       se ejecuta después de la carga) */
    if (img.complete && img.naturalWidth === 0) {
      marcarFalla();
    }
    img.addEventListener('error', marcarFalla);
  });

  /* El logo: si el archivo todavía no existe, se oculta la imagen y queda
     visible el nombre del negocio escrito con letras. */
  var logos = document.querySelectorAll('.logo img');
  Array.prototype.forEach.call(logos, function (img) {
    function ocultarLogo() {
      img.style.display = 'none';
      var texto = img.parentElement.querySelector('.logo__texto');
      if (texto) texto.hidden = false;
    }
    if (img.complete && img.naturalWidth === 0) ocultarLogo();
    img.addEventListener('error', ocultarLogo);
  });
}


/* ==========================================================================
   2. MENÚ DEL CELULAR
   ========================================================================== */

function iniciarMenuCelular() {
  var boton = document.querySelector('.menu-boton');
  var nav   = document.querySelector('.nav');
  if (!boton || !nav) return;

  function abrir() {
    nav.classList.add('abierto');
    boton.setAttribute('aria-expanded', 'true');
    document.body.classList.add('menu-abierto');
  }

  function cerrar() {
    nav.classList.remove('abierto');
    boton.setAttribute('aria-expanded', 'false');
    document.body.classList.remove('menu-abierto');
  }

  boton.addEventListener('click', function () {
    if (nav.classList.contains('abierto')) { cerrar(); } else { abrir(); }
  });

  /* Al tocar un enlace, el menú se cierra solo */
  var enlaces = nav.querySelectorAll('a');
  Array.prototype.forEach.call(enlaces, function (a) {
    a.addEventListener('click', cerrar);
  });

  /* La tecla Escape también lo cierra */
  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape' && nav.classList.contains('abierto')) {
      cerrar();
      boton.focus();
    }
  });

  /* Si la pantalla se agranda hasta escritorio, se limpia el estado */
  window.addEventListener('resize', function () {
    if (window.innerWidth >= 900 && nav.classList.contains('abierto')) cerrar();
  });
}


/* ==========================================================================
   3. SOMBRA DEL ENCABEZADO AL BAJAR
   ========================================================================== */

function iniciarEncabezado() {
  var encabezado = document.querySelector('.encabezado');
  if (!encabezado) return;

  function actualizar() {
    if (window.scrollY > 10) {
      encabezado.classList.add('desplazado');
    } else {
      encabezado.classList.remove('desplazado');
    }
  }

  actualizar();
  window.addEventListener('scroll', actualizar, { passive: true });
}


/* ==========================================================================
   4. PORTADA ROTATIVA (HERO)
   ========================================================================== */

function iniciarHero() {
  var hero = document.querySelector('.hero');
  if (!hero) return;

  var pista   = hero.querySelector('.hero__pista');
  var slides  = hero.querySelectorAll('.hero__slide');
  var puntos  = hero.querySelectorAll('.hero__punto');
  var anterior = hero.querySelector('.hero__flecha--prev');
  var siguiente = hero.querySelector('.hero__flecha--next');
  if (!pista || slides.length < 2) return;

  var actual = 0;
  var temporizador = null;
  var PAUSA = 6000;   /* milisegundos que dura cada imagen en pantalla */

  /* Si la persona pidió en su sistema operativo que se reduzcan las
     animaciones, la portada no gira sola. */
  var sinMovimiento = window.matchMedia &&
                      window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  function mostrar(indice) {
    actual = (indice + slides.length) % slides.length;
    pista.style.transform = 'translateX(-' + (actual * 100) + '%)';

    Array.prototype.forEach.call(slides, function (slide, i) {
      /* Los slides que no se ven se sacan del recorrido del teclado */
      slide.setAttribute('aria-hidden', i === actual ? 'false' : 'true');
      var enfocables = slide.querySelectorAll('a, button');
      Array.prototype.forEach.call(enfocables, function (el) {
        if (i === actual) { el.removeAttribute('tabindex'); }
        else { el.setAttribute('tabindex', '-1'); }
      });
    });

    Array.prototype.forEach.call(puntos, function (p, i) {
      p.setAttribute('aria-selected', i === actual ? 'true' : 'false');
    });
  }

  function avanzar() { mostrar(actual + 1); }

  function arrancar() {
    if (sinMovimiento) return;
    detener();
    temporizador = setInterval(avanzar, PAUSA);
  }

  function detener() {
    if (temporizador) { clearInterval(temporizador); temporizador = null; }
  }

  /* Reinicia el reloj después de que la persona navega a mano, para que no
     se le cambie la imagen justo cuando la está leyendo */
  function irA(indice) { mostrar(indice); arrancar(); }

  if (siguiente) siguiente.addEventListener('click', function () { irA(actual + 1); });
  if (anterior)  anterior.addEventListener('click',  function () { irA(actual - 1); });

  Array.prototype.forEach.call(puntos, function (p, i) {
    p.addEventListener('click', function () { irA(i); });
  });

  /* Se detiene mientras el cursor está encima o algo tiene el foco */
  hero.addEventListener('mouseenter', detener);
  hero.addEventListener('mouseleave', arrancar);
  hero.addEventListener('focusin',  detener);
  hero.addEventListener('focusout', arrancar);

  /* Se detiene si la pestaña deja de estar visible */
  document.addEventListener('visibilitychange', function () {
    if (document.hidden) { detener(); } else { arrancar(); }
  });

  /* Flechas del teclado */
  hero.addEventListener('keydown', function (e) {
    if (e.key === 'ArrowRight') { irA(actual + 1); }
    if (e.key === 'ArrowLeft')  { irA(actual - 1); }
  });

  /* Deslizar con el dedo en el celular */
  var inicioX = 0;
  var inicioY = 0;
  var arrastrando = false;

  hero.addEventListener('touchstart', function (e) {
    inicioX = e.touches[0].clientX;
    inicioY = e.touches[0].clientY;
    arrastrando = true;
    detener();
  }, { passive: true });

  hero.addEventListener('touchend', function (e) {
    if (!arrastrando) return;
    arrastrando = false;

    var deltaX = e.changedTouches[0].clientX - inicioX;
    var deltaY = e.changedTouches[0].clientY - inicioY;

    /* Solo cuenta como deslizar si el movimiento fue claramente horizontal.
       Si no, la persona estaba bajando la página. */
    if (Math.abs(deltaX) > 50 && Math.abs(deltaX) > Math.abs(deltaY)) {
      irA(deltaX < 0 ? actual + 1 : actual - 1);
    } else {
      arrancar();
    }
  }, { passive: true });

  mostrar(0);
  arrancar();
}


/* ==========================================================================
   5. BARRA DE CATEGORÍAS DE LA CARTA
   --------------------------------------------------------------------------
   Resalta la categoría que se está viendo mientras se baja la página.
   ========================================================================== */

function iniciarFiltroCategorias() {
  var barra = document.querySelector('.filtro-categorias');
  if (!barra || !('IntersectionObserver' in window)) return;

  var chips = barra.querySelectorAll('.filtro-categorias__chip');
  var secciones = document.querySelectorAll('.categoria[id]');
  if (!chips.length || !secciones.length) return;

  function activar(id) {
    Array.prototype.forEach.call(chips, function (chip) {
      var esActivo = chip.getAttribute('href') === '#' + id;
      chip.classList.toggle('activo', esActivo);

      /* Si el chip activo quedó fuera de la vista en celular,
         se arrastra la barra para que se vea */
      if (esActivo && barra.querySelector('.filtro-categorias__lista')) {
        var lista = barra.querySelector('.filtro-categorias__lista');
        var izquierda = chip.offsetLeft - (lista.clientWidth / 2) + (chip.clientWidth / 2);
        lista.scrollTo({ left: izquierda, behavior: 'smooth' });
      }
    });
  }

  var observador = new IntersectionObserver(function (entradas) {
    entradas.forEach(function (entrada) {
      if (entrada.isIntersecting) activar(entrada.target.id);
    });
  }, {
    /* La franja de detección va en la parte de arriba de la pantalla,
       justo debajo del encabezado y de la barra de categorías */
    rootMargin: '-150px 0px -65% 0px',
    threshold: 0
  });

  Array.prototype.forEach.call(secciones, function (s) { observador.observe(s); });
}


/* ==========================================================================
   6. HORARIO: DÍA DE HOY Y ESTADO ABIERTO / CERRADO
   ========================================================================== */

function iniciarHorarios() {
  var ahora = horaEnEcuador();
  var diaHoy = DIAS[ahora.getDay()];
  var minutosAhora = ahora.getHours() * 60 + ahora.getMinutes();
  var horarioHoy = NEGOCIO.horarios[diaHoy];

  /* --- Resalta la fila de hoy en la tabla de horarios --- */
  var filas = document.querySelectorAll('.horarios tr[data-dia]');
  Array.prototype.forEach.call(filas, function (fila) {
    if (fila.getAttribute('data-dia') === diaHoy) fila.classList.add('hoy');
  });

  /* --- Calcula si está abierto en este momento --- */
  var abierto = false;
  if (horarioHoy) {
    var apertura = aMinutos(horarioHoy[0]);
    var cierre   = aMinutos(horarioHoy[1]);
    /* Si cierra después de medianoche (ej. 18:00 a 02:00) el número
       de cierre es menor que el de apertura */
    if (cierre <= apertura) {
      abierto = minutosAhora >= apertura || minutosAhora < cierre;
    } else {
      abierto = minutosAhora >= apertura && minutosAhora < cierre;
    }
  }

  /* --- Escribe el estado donde se haya puesto el elemento --- */
  var estados = document.querySelectorAll('[data-estado]');
  Array.prototype.forEach.call(estados, function (el) {
    el.classList.remove('estado--abierto', 'estado--cerrado');
    if (abierto) {
      el.classList.add('estado', 'estado--abierto');
      el.textContent = 'Abierto ahora · hasta las ' + horarioHoy[1];
    } else {
      el.classList.add('estado', 'estado--cerrado');
      el.textContent = horarioHoy
        ? 'Cerrado · hoy abrimos ' + horarioHoy[0] + ' a ' + horarioHoy[1]
        : 'Cerrado hoy';
    }
  });

  /* --- Texto corto del horario para la barra de arriba --- */
  var resumen = document.querySelectorAll('[data-horario-hoy]');
  Array.prototype.forEach.call(resumen, function (el) {
    el.textContent = horarioHoy
      ? 'Hoy: ' + horarioHoy[0] + ' a ' + horarioHoy[1]
      : 'Hoy cerrado';
  });
}


/* ==========================================================================
   7. AÑO DEL PIE DE PÁGINA
   ========================================================================== */

function iniciarAnio() {
  var elementos = document.querySelectorAll('[data-anio]');
  var anio = new Date().getFullYear();
  Array.prototype.forEach.call(elementos, function (el) { el.textContent = anio; });
}


/* ==========================================================================
   ARRANQUE
   ========================================================================== */

function iniciar() {
  manejarImagenesFaltantes();
  iniciarMenuCelular();
  iniciarEncabezado();
  iniciarHero();
  iniciarFiltroCategorias();
  iniciarHorarios();
  iniciarAnio();
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', iniciar);
} else {
  iniciar();
}
