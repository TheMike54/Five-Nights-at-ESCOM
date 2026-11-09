# Integración del PR 2

Se integró gabrielhuav/main (f62f9f0) en Alexis177/feature/luis-changes (14d2cb7), conservando ambos historiales.

## Resolución

- 20 archivos en conflicto: metadatos GameMaker, salas, README, validador y alarma de victoria.
- Se conserva la Noche 2 jugable, el Intruso, sus recursos y jumpscare, Continuar y el guardado del progreso.
- Se conserva el apagón, su bloqueo de victoria, el atajo Ctrl+Shift+N y el menú de pausa.
- Se coloca exactamente un controlador de pausa en Culturales1 y N2.
- El atajo usa la victoria normal y su guardado en ambas noches.
- El Intruso detiene su avance durante el apagón, evitando interrumpir esa secuencia.
- Se conservan las dos series de documentación y participantes.

## Validación realizada

- El validador del proyecto pasa: 1180 recursos.
- Revisión adicional: 164 eventos y 1937 referencias; referencias existentes, instancias y orden de creación comprobados.
- Sin marcadores de conflicto ni archivos sin resolver.
- Dos declaraciones de eventos sin archivo ya estaban presentes en ambas ramas: obj_Bat/Create_0.gml y obj_ButtonUp/Alarm_0.gml (y sus fuentes visuales). No se inventó su contenido.
- No se compiló ni ejecutó el juego en GameMaker. Las evidencias anteriores pertenecen a las versiones anteriores.

## Pruebas manuales pendientes

1. Abrir el proyecto, compilar y empezar Nuevo Juego.
2. Pausar con ESC y P: revisar reloj, batería y enemigos; reanudar.
3. Salir al menú desde pausa y empezar otra partida.
4. Ganar Noche 1 normalmente; verificar que Continuar abre N2.
5. Repetir pausa y salida en N2; comprobar el avance, vigilancia y jumpscare del Intruso.
6. Usar Ctrl+Shift+N en ambas noches y comprobar guardado y transición de victoria.
7. Agotar energía en ambas noches; comprobar que el apagón termina en Game Over y bloquea el atajo.

## Integración final en gabrielhuav/main (8 nov 2026)

El PR se fusionó sobre la release Android 0.1.1 (`0adaaaa`), la versión enviada a Google Play, en el commit `ba44384`. GitHub lo marca como fusionado.

- Único conflicto: `Five Nights at ESCOM.yyp`. Se partió del archivo nativo de la release (incluye `fnt_Privacidad`) y se añadió `obj_pauseManager`.
- No se incorporó `docs/licencias.md`: duplicaba en minúsculas al `docs/LICENCIAS.md` existente y en Windows provoca colisión de rutas.
- Commit `1250001`: se restauró el formato que escribe GameMaker (comas finales, una instancia por línea) en nueve archivos. Un análisis estructural confirmó que no hay cambios semánticos.
- Commit `9aa6044`: `obj_pauseManager` dejó de ser persistente. Como ya está colocado en Culturales1 y N2, cada partida acumulaba instancias, la pausa llegaba al menú y reanudar podía requerir dos pulsaciones.
- Validación: `tools/validate_project.py` pasa con 1181 recursos. Una revisión adicional de eventos, instancias y orden de creación no encontró problemas nuevos.
- **No se compiló ni ejecutó en GameMaker.** Las pruebas manuales listadas arriba siguen pendientes. La pausa sólo responde a teclado: antes de publicarla en Android hace falta un control táctil y prueba en dispositivo.
