# Matriz de pruebas

Plataforma de referencia: Windows 11 Home 25H2 (compilación 26200.9457), GameMaker IDE 2026.0.0.16 con Runtime 2026.0.0.23, commit `d537768` de la rama `feature/2-energy-ends-round`. Pruebas ejecutadas el 4 de octubre de 2026 en una computadora con Windows.

| # | Caso | Plataforma | Pasos | Resultado esperado | Resultado real | Estado | Issue |
|---|---|---|---|---|---|---|---|
| 1 | Flujo principal | Windows 11, GameMaker LTS 2026.0.0.16 | 1. Ejecutar el juego con F5. 2. Pulsar "Nuevo Juego". 3. Esperar el periódico y la cortinilla de la noche 1. 4. En la oficina, subir las cámaras y usar el láser. 5. Dejar que el Prismoso llegue a la puerta sin usar el láser. | El juego pasa del menú a la oficina; al llegar el Prismoso a la puerta aparece el jumpscare, la pantalla de fin de partida y se regresa al menú. | El juego avanzó del menú a la oficina sin errores, las cámaras y el láser respondieron y la derrota por el Prismoso mostró el jumpscare y regresó al menú. No se jugó hasta las 6 AM, por lo que la victoria no se ejecutó en esta prueba. | Parcial | — |
| 2 | Datos vacíos o inválidos (energía agotada y valor fuera de rango) | Windows 11, GameMaker LTS 2026.0.0.16 | 1. Ejecutar el juego con F5 (ejecución nueva). 2. Pulsar "Nuevo Juego". 3. Subir las cámaras y encender el láser a la vez. 4. Esperar unos 2 minutos y observar la barra de energía. | La energía nunca queda en un valor negativo, la barra baja nivel por nivel hasta vaciarse y, al agotarse la energía, la ronda termina. | A los 2 minutos aproximadamente (las 12 AM del juego) la ronda terminó y se mostró el jumpscare. La barra de energía en la vista de cámaras se mantuvo llena todo el tiempo y nunca bajó de nivel. | Defecto | [#7](https://github.com/TheMike54/Five-Nights-at-ESCOM/issues/7) |
| 3 | Recreación (reiniciar la ronda) | Windows 11, GameMaker LTS 2026.0.0.16 | 1. Perder una partida. 2. Volver al menú y pulsar "Nuevo Juego". 3. Revisar la hora, la energía y los controles. 4. Repetir la derrota varias veces en la misma ejecución. | Cada partida nueva empieza a las 10 PM con la energía llena y los controles normales, y el video del jumpscare se reproduce en cada derrota. | Cada partida nueva empezó a las 10 PM con la energía llena y sin anomalías en los controles. En una misma ejecución, el video del jumpscare se vio en las derrotas 1 y 3 y en las derrotas 2 y 4 la pantalla quedó en negro hasta que apareció el texto de fin de partida. La consola de GameMaker muestra "Please close video player before attempting to play a new one". Minimizar la ventana y volver no se probó. | Defecto | [#6](https://github.com/TheMike54/Five-Nights-at-ESCOM/issues/6) |
| 4 | Red no disponible | — | — | — | No aplica: el juego no usa red. | N/A | — |
| 5 | Accesibilidad con texto ampliado (escala de Windows 125 %) | Windows 11, GameMaker LTS 2026.0.0.16 | 1. En Configuración > Sistema > Pantalla, cambiar la escala a 125 %. 2. Ejecutar el juego con F5. 3. Revisar el menú principal y una partida. 4. Regresar la escala a 100 % y repetir. | El título, los botones, la barra de energía y las cámaras se ven completos y se pueden usar. | Con la escala al 125 % el menú y la partida se ven completos, sin cortes en la ventana y con los botones y la barra de energía visibles. Al regresar a 100 % el juego también se ve correcto. | ✅ | — |

Capturas de los casos 1 y 5 en `docs/capturas/`: `caso1-juego-corriendo-1.png`, `caso1-juego-corriendo-2.png`, `caso5-escala-125-1.png`, `caso5-escala-125-2.png` y `caso5-escala-125-3.png`.

## Casos de la característica: la ronda termina al agotarse la energía (PR #5)

Plataforma: Windows 11, GameMaker IDE 2026.0.0.16 con Runtime 2026.0.0.23, commit `141f5e7` de la rama `feature/2-energy-ends-round`. Pruebas ejecutadas el 4 de octubre de 2026.

| # | Caso | Plataforma | Pasos | Resultado esperado | Resultado real | Estado | Issue |
|---|---|---|---|---|---|---|---|
| F1 | Ruta feliz | Windows 11, GameMaker LTS 2026.0.0.16 | 1. Nuevo juego. 2. En la oficina, subir solo las cámaras y dejarlas arriba hasta que se acabe la energía. | La pantalla se queda en negro y, en menos de 5 s, aparece el game over y se regresa al menú. | La pantalla quedó en negro 3 s; después se mostró el jumpscare, la pantalla de fin de partida y el menú principal. | ✅ | — |
| F2 | Dos consumidores (estado alterno) | Windows 11, GameMaker LTS 2026.0.0.16 | 1. Nuevo juego. 2. Encender el láser y subir las cámaras a la vez. 3. Esperar a que se acabe la energía. | Mismo resultado que F1; la energía nunca queda negativa. | Misma secuencia que F1 (3 s en negro, game over y menú). Con el valor normal de energía también terminó la ronda, después de unos minutos y con los 3 s en negro antes del game over. La barra de energía se quedó llena todo el tiempo: es el defecto #7, que esta característica no cambia. | ✅ | [#7](https://github.com/TheMike54/Five-Nights-at-ESCOM/issues/7) |
| F3 | Disparo único | Windows 11, GameMaker LTS 2026.0.0.16 | 1. Durante la pantalla negra de F1 o F2, pulsar los botones de cámaras y láser. | No pasa nada distinto y hay un solo game over. | Ningún botón responde durante la pantalla negra; hubo un solo game over. | ✅ | — |
| F4 | Sin agotar la energía | Windows 11, GameMaker LTS 2026.0.0.16 | 1. Nuevo juego. 2. Jugar la noche completa sin subir las cámaras y usando el láser solo cuando el Prismoso está en la puerta. | Se gana a las 6 AM y la regla no se dispara. | Se llegó a las 6 AM y a la pantalla de victoria, sin pantalla negra durante la noche. | ✅ | — |
| F5 | Recreación | Windows 11, GameMaker LTS 2026.0.0.16 | 1. Tras un game over por energía, pulsar "Nuevo Juego". | La noche empieza con la energía llena y los controles normales. | La noche empezó a las 10 PM con la batería llena y los controles funcionando. | ✅ | — |
| F6 | Carrera con el reloj | — | 1. Nuevo juego. 2. Subir las cámaras a partir del minuto 5:00. | Gana el apagón: game over, no victoria. | No se pudo ejecutar como está escrito: si no se usa el láser, el Prismoso llega a la puerta en segundos y termina la partida antes del minuto 5:00. | No ejecutable | — |

F1 y F2 se ejecutaron con la energía inicial bajada temporalmente a 600 en el evento Create de `obj_Culturales1`, para que se agotara en segundos (con el valor normal el Prismoso llega antes a la puerta). El valor se regresó a 14400 antes de cualquier commit. Los videos de F1 y F2 están en la descripción del PR #5.

Capturas: `docs/capturas/f4-victoria.png` (F4) y `docs/capturas/f5-bateria-llena.png` (F5).

## Defectos encontrados durante las pruebas

| Issue | Defecto | Dónde se observó |
|---|---|---|
| [#6](https://github.com/TheMike54/Five-Nights-at-ESCOM/issues/6) | El video del game over no se reproduce en una de cada dos derrotas de una misma ejecución | Caso 3 |
| [#7](https://github.com/TheMike54/Five-Nights-at-ESCOM/issues/7) | La barra de energía no baja con cámaras y láser activos a la vez | Casos 2 y F2 |
| [#8](https://github.com/TheMike54/Five-Nights-at-ESCOM/issues/8) | La cámara 19 muestra la imagen de la cámara 18 | Revisión de las cámaras durante el caso 1 |
