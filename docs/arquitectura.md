# Arquitectura de Five Nights at ESCOM

Five Nights at ESCOM es un juego de GameMaker en el que el jugador es el guardia de ESCOM y debe
sobrevivir una noche (de 10 PM a 6 AM, unos 9 minutos reales) mientras el Prismoso camina hacia la
puerta. Para vigilarlo tiene cámaras y un láser que lo regresa a su punto de inicio, y ambos gastan
energía. Este documento explica cómo está organizado el repositorio, cómo está construido el juego y
cómo funciona la energía de principio a fin.

## 1. Estructura del repositorio

| Carpeta o archivo | Qué contiene |
|---|---|
| `Five Nights at ESCOM.yyp` | Índice del proyecto: lista todos los recursos y el orden de las rooms. Lo escribe el IDE |
| `Five Nights at ESCOM.resource_order` | Orden en que el IDE muestra los recursos |
| `objects/` | 80 objetos. Cada objeto es una carpeta con su `.yy` (metadatos y lista de eventos) y un `.gml` por evento |
| `rooms/` | 10 rooms (pantallas del juego); su `.yy` lista las instancias de objetos que contiene |
| `sprites/` | 860 sprites (imágenes y animaciones) |
| `sounds/` | 210 sonidos |
| `sequences/` | 13 secuencias (animaciones prearmadas, como la cortinilla de la noche) |
| `datafiles/` | Archivos que se empaquetan tal cual: el video del jumpscare `vd_PSJS1.mp4` |
| `options/` | Configuración por plataforma; `main` define 60 pasos por segundo y `windows` el nombre del ejecutable |
| `.github/` | Integración continua: `workflows/ci.yml` y el verificador `scripts/check_gamemaker.py` |
| `docs/` | Documentación del proyecto: arquitectura, pruebas, licencias, idea propia y evidencias |

El proyecto no tiene scripts ni funciones propias: toda la lógica está en los eventos de los
objetos. Casi todos los objetos se programaron con bloques (*Drag and Drop*); GameMaker guarda los
bloques en un `.dnd` y genera el `.gml` a partir de ellos.

**Punto de entrada.** El juego arranca en la primera room del `RoomOrderNodes` del `.yyp`:
`MenuPrincipal`. Desde ahí el flujo es `MenuPrincipal` → `Periodico` → `N1` (cortinilla) →
`Culturales1` (la oficina, donde está toda la jugabilidad) → `GameOver` o `Win` → de vuelta al menú.
Las rooms `N2`, `N134`, `N1345` y `Guardia` existen en el proyecto, pero ninguna otra room lleva a
ellas.

**`.gitignore`.** El repositorio original no tenía. El nuestro excluye:

- La configuración personal de cada integrante (`CLAUDE.local.md`, `.claude/settings.local.json`,
  `pr-body.md`): es de cada quien y no forma parte del proyecto.
- Secretos y archivos de firma (`.env`, `*.jks`, `*.keystore`, `*.pem`, `*.key`, `*.p12`,
  `google-services.json`, `local.properties`): nunca deben quedar en el historial.
- Exportaciones y compilados (`*.apk`, `*.aab`, `*.yyz`, `*.zip`): se generan desde el proyecto.
- Archivos del sistema operativo y de los editores (`Thumbs.db`, `Desktop.ini`, `.DS_Store`,
  `.vscode/`, `.idea/`, `*.bak`, `*.tmp`).

**Integración continua.** `.github/workflows/ci.yml` corre en cada Pull Request hacia `main` y en
cada push a `main`. GameMaker no se puede compilar en GitHub Actions, porque necesita el IDE y una
sesión iniciada, así que la CI revisa lo que sí se puede revisar sin compilar:

| Check | Qué comprueba |
|---|---|
| Convenciones de rama y commits | Que la rama empiece con `feature/`, `fix/`, `docs/` o `chore/`, y que cada mensaje tenga la forma `tipo: descripción` |
| Archivos prohibidos y tamaños | Que no se suban llaves, archivos de firma ni `.env`, y ningún archivo de más de 50 MB |
| Búsqueda de secretos | Que no haya tokens ni contraseñas en el historial |
| Proyecto GameMaker legible | Con `check_gamemaker.py`: que el `.yyp` y todos los `.yy` se puedan leer, que cada recurso del índice exista, que cada evento de un objeto tenga su `.gml` y que cada instancia de una room apunte a un objeto que existe. También que la energía inicial siga en `global.Bateria = 14400;` |

Lo que la CI no puede comprobar queda como **QA manual** en cada Pull Request: abrir el proyecto en
GameMaker, compilar con F5 y jugar los casos de `docs/pruebas.md`.

**Licencias.** La licencia del código y la procedencia de los recursos están en `docs/licencias.md`.

## 2. Arquitectura

![Arquitectura del juego](img/arquitectura.png)

GameMaker no separa el código en capas formales, pero las responsabilidades sí están repartidas:

| Parte | Dónde vive | Ejemplos |
|---|---|---|
| **Presentación** | Rooms, sprites, sonidos y secuencias | `Culturales1` (la oficina), `spr_Bat1` … `spr_Bat6` (la barra de energía) |
| **Interfaz** (entrada del jugador) | Eventos `Gesture` (clic o toque) de los botones y la posición del mouse para mover la vista | `obj_ButtonDown` sube y baja las cámaras; `obj_CLaserButton` prende el láser; `obj_Cam_01` … `obj_Cam_19` cambian de cámara |
| **Lógica** | Eventos `Step` (cada paso) y `Alarm` (cuentas regresivas) | `obj_BatCheck` revisa la energía; `obj_PM` mueve al Prismoso; `obj_WinTimer` avanza la hora |
| **Datos** | Variables `global.*`, que viven mientras el juego esté abierto aunque se cambie de room | `global.Bateria`, `global.Hora`, `global.PMPos`; `obj_Coco` las reinicia en cada partida nueva |

Los objetos no se llaman entre sí: se comunican escribiendo y leyendo variables globales. Por
ejemplo, el botón de cámaras pone `global.BatCamara = 1` y otro objeto, `obj_BatCamara`, ve esa
bandera y resta energía.

**Dependencias.** Ninguna externa: no hay bibliotecas, extensiones ni servicios. Todo lo que usa el
juego viene del propio motor de GameMaker (dibujo, audio y `video_open` para el jumpscare).

**Qué corre en el dispositivo.** Todo. El juego no usa red, no guarda partidas y no lee archivos
externos: el motor ejecuta los eventos 60 veces por segundo en la computadora del jugador y los
recursos van empaquetados en el ejecutable.
