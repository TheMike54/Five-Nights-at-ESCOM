# Five-Nights-at-ESCOM-Forked
Repositorio para la ejecución, modificación e implementación de una funcionalidad dentro de un proyecto anteriormente desarrollado para la entrega de una característica nueva mediante un Pull Request completo con evidencias de Quality Assurance.

---
Aplicaciones Móviles Nativas
Gabriel Hurtado Avilés
7CV4

### Participantes
* Chávez Romero Jonathan - 2024630102
* Moreno Noguerón Ximena - 2024630201
* Reyes Castellanos José Abel - 2020311353
---

## Índice

* [`Documentacion`](/docs/)
* [`Documento explicativo de la idea`](/docs/evidencias/entrega1/IDEA.md)
* [`Documento explicativo de las pruebas`](/docs/evidencias/entrega1/PRUEBAS.md)
* [`Documento explicativo de las licencias`](/docs/LICENCIAS.md)
* [`Evidencias de ejecución para la entrega 1`](/docs/evidencias/entrega1/ENTREGA1.md)
---

## Parte 3 — Feature "Add Night 2"

Rama: `feature/night-2`. Se agrega la Noche 2 como nueva sala jugable (`N2`), con el
sistema completo de cámaras/batería/UI (reutilizado del sistema de la Noche 1) y un
personaje nuevo con una mecánica propia de vigilancia por cámara.

* **`obj_Intruso`** (Jose Abel Reyes Castellanos): personaje nuevo que empieza en la
  Cámara 1 y avanza una cámara cada 10 segundos si no se le está vigilando en ese
  instante exacto; si llega a la Cámara 8 sin haber sido detenido, dispara un jumpscare
  propio (`case 2` en `obj_GOManager`) y termina la partida.
* **Sala `N2`** (Ximena Moreno Noguerón): sistema de cámaras, batería y UI de la Noche 2,
  con `obj_PM` (enemigo de la Noche 1) también activo para aumentar la dificultad.
* **Guardado y botón "Continuar"** (Jonathan Chávez Romero): el progreso de la Noche 1
  se guarda y el menú principal permite continuar directo a la Noche 2.

Evidencias de desarrollo y QA en [`docs/evidencias/entrega1/PRUEBAS.md`](/docs/evidencias/entrega1/PRUEBAS.md).


## Funciones del fork Alexis177


Adapté el proyecto de [gabrielhuav](https://github.com/gabrielhuav/Five-Nights-at-ESCOM) para que agotar la energía termine la ronda mediante un apagón, el screamer existente y la pantalla de Game Over.

## Abrir y ejecutar

El entorno utilizado para las pruebas fue Windows, GameMaker LTS IDE **2026.0.0.16** y runtime **2026.0.0.23**.

1. Clonar el repositorio: `git clone https://github.com/Alexis177/Five-Nights-at-ESCOM.git`.
2. Entrar a la carpeta: `cd Five-Nights-at-ESCOM`.
3. Para revisar el PR de pausa, ejecutar `git switch feature/luis-changes`.
4. Abrir `Five Nights at ESCOM.yyp` desde GameMaker.
5. Seleccionar Windows como destino y ejecutar con el botón Run.
6. Seleccionar Nuevo Juego. Utilizar las cámaras y el láser hasta agotar la batería para comprobar la secuencia.

La ejecución manual documentada se realizó sobre la copia local LTS. Las instrucciones anteriores permiten obtener la rama desde Git.

## Documentación

- [Idea y criterios del cambio](docs/idea.md).
- [Bosquejos, controles y flujo de pantallas](docs/diseno/README.md).
- [Estructura y recorrido del código](docs/arquitectura.md).
- [Pruebas realizadas](docs/pruebas.md).
- [Evidencias antes y después](docs/evidencia/entrega-1/README.md).
- [Procedencia de recursos](docs/licencias.md).

El [PR del atajo de victoria](https://github.com/Alexis177/Five-Nights-at-ESCOM/pull/4) contiene el cambio independiente para finalizar la ronda con Ctrl+Shift+N.

## Validación automática

Con Python 3, ejecutar `python tools/validate_project.py` desde la raíz. GitHub Actions ejecuta esta comprobación al publicar cambios y abrir un PR. Revisa integridad del proyecto; la ejecución del juego se comprueba en GameMaker.

## Referencia de configuración

[Video de configuración incluido en el repositorio original](https://www.youtube.com/watch?v=wNQGLxLh3lc).

Utilicé IA como apoyo en el código y la documentación.

### Integración de las dos noches

ESC o P pausa y reanuda Culturales1 y N2. El botón Salir al Menú vuelve a MenuPrincipal. Ctrl+Shift+N completa la noche activa con batería disponible y conserva el guardado de progreso. El Intruso queda detenido durante el apagón. La validación automática es estática; las pruebas de esta integración en GameMaker siguen pendientes.
