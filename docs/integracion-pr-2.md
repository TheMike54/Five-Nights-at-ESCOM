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
