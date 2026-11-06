# Pruebas — Parte 3: "Add Night 2"

Matriz de QA para la característica `feature/night-2` (issue a enlazar cuando Ximena la
abra). Casos ejecutados sobre un build local (GameMaker no compila en CI para esta ruta,
ver nota en `.github/workflows/pr-quality-gate.yml`).

**SHA base:** `7ab6b0399ff609349ae73159be7901c03eb799ae`
**SHA probado:** `66be57f` (incluye sistema de cámaras de N2 y ajuste de dificultad a 10s/8 cámaras)
**Dispositivo/entorno:** macOS (Apple Silicon), GameMaker IDE v2026.0.0.16, Runtime v2026.0.0.23

| ID | Tipo | Autor / fecha | Precondiciones | Pasos | Esperado | Real | Estado | Evidencia |
|----|------|----------------|-----------------|-------|----------|------|--------|-----------|
| RF-01 | Ruta feliz | Jose Abel Reyes Castellanos / 2026-10-08 | Partida con Noche 1 recién superada | 1. Ganar Noche 1. 2. Volver al menú. 3. Tocar "Continuar". | El botón está habilitado y lleva directo a la Noche 2 (`room N2`), no a Noche 1. | Confirmado: tras ganar la Noche 1, "Continuar" llevó directo a la sala N2. | Aprobado | [night2-05](night2-05-qa-n2-sin-vigilar-camara.png) |
| LIM-02 | Límite / alterno | [Nombre] / [fecha] | Partida nueva, sin ninguna noche superada (`save.ini` inexistente o en 0) | 1. Abrir el menú principal sin haber jugado antes. | El botón "Continuar" se muestra deshabilitado (opacidad reducida) y no reacciona al toque. | [PENDIENTE] | [PENDIENTE] | [captura] |
| REG-03 | Regresión | [Nombre] / [fecha] | Build con los cambios de Noche 2 aplicados | 1. Iniciar "Nueva partida" (no Continuar). 2. Jugar la Noche 1 normalmente hasta perder o ganar. | La Noche 1 se comporta igual que antes del cambio: batería, cámaras y personajes PM sin alterar. | [PENDIENTE] | [PENDIENTE] | [captura/video] |
| NAV-04 | Navegación / estado | [Nombre] / [fecha] | Noche 1 recién superada (progreso guardado) | 1. Ganar Noche 1. 2. Cerrar la app por completo. 3. Reabrir la app. 4. Tocar "Continuar". | El progreso persiste tras cerrar la app: "Continuar" sigue habilitado y lleva a Noche 2. | [PENDIENTE] | [PENDIENTE] | [captura] |
| A11Y-05 | Accesibilidad | [Nombre] / [fecha] | Menú principal visible | 1. Medir el área táctil del botón "Continuar" en ambos estados. 2. Verificar contraste del estado deshabilitado contra el fondo. | El botón mantiene un área táctil ≥ al resto de los botones del menú; el estado deshabilitado es distinguible pero legible (no desaparece). | [PENDIENTE] | [PENDIENTE] | [captura] |
| COMPAT-06 | Entorno / compatibilidad | Jose Abel Reyes Castellanos / 2026-10-08 | — | Registrar versión de GameMaker Runtime, dispositivo/emulador y SO usados para correr el build. | Build corre sin errores de compilación ni crashes al cargar `N2` o `GameOver`. | Corrió sin errores de compilación; se jugó Noche 1 y se llegó a N2 y a GameOver sin crashes (macOS, GameMaker Runtime v2026.0.0.23). | Aprobado | — |
| RF-07 | Ruta feliz (Intruso) | Jose Abel Reyes Castellanos / 2026-10-08 | En la sala N2, con `obj_Intruso` recién colocado (prueba corrida con la configuración inicial: 5s por cámara, 4 cámaras máx.) | 1. Llegar a N2 (vía "Continuar"). 2. No vigilar ninguna cámara durante ~20 segundos (4 ciclos de 5s). | Se dispara el jumpscare de `obj_Intruso` (case 2 de `obj_GOManager`) y aparece la pantalla de Game Over. | Confirmado: tras ~20s sin vigilar cámaras, apareció el jumpscare y la pantalla de Game Over, tal como se diseñó. | Aprobado | [night2-05](night2-05-qa-n2-sin-vigilar-camara.png) / [night2-06](night2-06-qa-jumpscare-gameover.png) |
| RF-08 | Ruta feliz (Intruso, vigilancia) | Jose Abel Reyes Castellanos / 2026-10-08 | Sala `N2` con el sistema de cámaras completo (capas de `Culturales1` copiadas), dificultad final: 10s por cámara, 8 cámaras máx. | 1. Entrar al panel de cámaras y seleccionar exactamente la cámara donde está `obj_Intruso`. 2. Mantenerla seleccionada cuando se cumpla cada revisión de 10s. 3. Salir del panel de cámaras (sin seleccionar su cámara) y esperar otra revisión de 10s. | Mientras se vigila su cámara exacta en el instante de cada revisión, `obj_Intruso` no avanza; al salir del panel de cámaras (aunque `global.CamaraActiva` siga apuntando a su cámara), sí avanza en la siguiente revisión. | Confirmado en ambos sentidos: vigilar su cámara exacta lo detiene; salir del panel de cámaras hace que vuelva a avanzar aunque la última cámara seleccionada coincida con la suya (requirió agregar el chequeo de `global.CameraUp` además de `global.CamaraActiva`). | Aprobado | — |

## Estado de la Noche 2 (personaje nuevo + jumpscare)

Implementado por Jose Abel Reyes Castellanos: `obj_Intruso` (mecánica de vigilancia de
cámara) y el `case 2` correspondiente en `obj_GOManager` (Crear, Alarma 0, Alarma 1) para
su jumpscare. Evidencia del desarrollo (código agregado y colocación en la sala `N2`):

![Instancia de obj_Intruso colocada en la sala N2](night2-01-room-n2-intruso-colocado.png)

*`obj_Intruso` colocado en la sala N2, junto al enemigo existente de la Noche 1.*

![case 2 agregado al evento Crear de obj_GOManager](night2-02-gomanager-crear-case2.png)

*Evento Crear de `obj_GOManager`, ya convertido a código, con el `case 2` nuevo junto al
`case 1` original (sin modificar).*

![case 2 agregado a Alarma 0 de obj_GOManager](night2-03-gomanager-alarma0-case2.png)

*Alarma 0 de `obj_GOManager` con el `case 2` nuevo.*

![case 2 agregado a Alarma 1 de obj_GOManager](night2-04-gomanager-alarma1-case2.png)

*Alarma 1 de `obj_GOManager` con el `case 2` nuevo.*

**Prueba de juego completa (ver RF-07):** se jugó la Noche 1 completa, se ganó, se usó
"Continuar" para llegar a N2, y se dejó de vigilar las cámaras durante ~20 segundos — el
jumpscare de `obj_Intruso` se disparó correctamente y llevó a la pantalla de Game Over.

![Sala N2 con obj_Intruso, sin vigilar cámaras](night2-05-qa-n2-sin-vigilar-camara.png)

*Sala N2 justo después de llegar por "Continuar", en una captura temprana (antes de que
se agregara el sistema de cámaras de Ximena — ver capturas más recientes abajo).*

![Jumpscare y pantalla de Game Over](night2-06-qa-jumpscare-gameover.png)

*Resultado tras ~20 segundos sin vigilar las cámaras: jumpscare y Game Over disparados por el `case 2` de `obj_GOManager`.*

![Panel de cámaras completo con obj_Intruso visible en Cámara 02](night2-07-camara-sistema-con-intruso.png)

*Sistema de cámaras de Ximena ya integrado: panel completo (19 cámaras, batería, minimapa) con `obj_Intruso` visible correctamente dentro de la Cámara 02 seleccionada — confirma que la mecánica de vigilancia (RF-08) funciona con el sistema de cámaras real, no solo en una sala vacía.*

**Actualización:** el caso de vigilancia (ver RF-08) ya se probó y quedó aprobado. La
sala `N2` ya tiene el sistema completo de cámaras/batería/UI (antes solo tenía el fondo
negro, ver nota en la captura `night2-05`), y la dificultad final quedó en 10 segundos
por cámara, hasta la Cámara 8, con `obj_PM` (enemigo de la Noche 1) también activo.

## Hallazgos

[PENDIENTE — defectos encontrados durante las pruebas, cada uno como issue reproducible
del repositorio, enlazada aquí.]
