# Five Nights at ESCOM — trabajo autorizado

## Repositorio y conservación

- Trabajar exclusivamente en el fork https://github.com/gabrielhuav/Five-Nights-at-ESCOM. `origin` debe apuntar a ese fork. No hacer push ni abrir PR contra `upstream` (autor original).
- Comprobar estado, remotos y ramas antes de modificar. Conservar cambios ajenos y créditos de Carlos Adrián Hernández Torres y colaboradores.
- Proyecto GameMaker: `Five Nights at ESCOM.yyp`. No aplicar procedimientos de compilación KMP o Flutter a este proyecto.
- Revisar `docs/publicacion/ACTUALIZACION_PLAY_STORE.md` antes de preparar la siguiente actualización.
- Conservar el formato nativo de GameMaker en `.yy`, `.yyp` y `.resource_order` (comas finales; una instancia por línea en salas). No reescribirlos con herramientas JSON. Validar con `python tools/validate_project.py`. Evitar rutas que sólo difieran en mayúsculas.

## Estado al 8 de noviembre de 2026

- Play: 0.1.0 (código 1000, `5808e2c`) y 0.1.1 (código 1001, `0adaaaa`, Noche 2 e Intruso) ya enviadas a la prueba cerrada Alpha. La 0.1.1 se envió a revisión el 7 nov; el propietario informó su lanzamiento el 8 nov (no verificado en Console por la IA).
- `main` = release 0.1.1 + PR #2 integrado (pausa ESC/P, apagón por batería, atajo Ctrl+Shift+N) + controlador de pausa no persistente. No compilado ni probado en GameMaker; no publicado.
- El PR #6 (panel de Opciones de TheMike54) se actualizó con `main` y añade la pausa táctil (botón en pantalla, Reanudar y Salir al Menú vía Gesture). Falta compilarlo y probarlo en dispositivo Android antes de publicarlo. La próxima compilación debe usar un código mayor que el máximo de Console (al menos 1002).
- GitHub Pages publica la política desde `prepare/google-play-closed-test:/docs`: no borrar esa rama; cambiar la fuente de Pages requiere autorización. `prepare/android-night2-update` conserva el commit exacto de la 0.1.1; los PR #5 y #6 apuntan a esa rama.

## Firma y publicación

- Nunca buscar, leer, registrar, mostrar o versionar contraseñas. El propietario las introduce localmente.
- Llave de carga existente fuera del repo: `C:\Users\gabri\.android\keystores\five-nights-at-escom-upload.jks`; alias `upload-five-nights-at-escom`. No crear otra ni reutilizar llaves de otros proyectos.
- Conservar paquete `ovh.gabrielhuav.fivenightsatescom`, ícono pixel art rojo, privacidad y permisos mínimos de la preparación Android anterior.
- Comprobar el código máximo de versión en Play antes de elegir uno mayor. Los códigos 1000 y 1001 ya se utilizaron; nunca reusarlos para otra compilación.
- Pedir autorización expresa antes de cambiar de cuenta, enviar a revisión, publicar o publicar una política web. Una autorización anterior de envío no autoriza automáticamente el envío de una nueva versión. Explicar si la aprobación puede activar el lanzamiento automáticamente.
- No garantizar aprobación de Google ni presentar una versión guardada o en revisión como publicada.
- No leer ni capturar correos de estudiantes ni enviarles mensajes sin instrucción expresa. Reutilizar la lista existente26-O Y2027-1; no crear/importar otra.

## Documentación de la actualización

- El usuario solicitó una presentación nueva que documente pasos reales de actualización usando como referencia visual:
  `C:\Users\gabri\Downloads\Planeacion Didactica Android 27-1\ENTREGA_FINAL\Con_autor\Unidad_5\05_Tutorial_Publicar_en_Google_Play_KMP_Flutter_DAMN.pptx`.
- Conservar el original y otros PPTX/DOCX. Crear una presentación separada, adaptada a GameMaker y a actualizar un juego ya existente en Play.
- Mantener formato institucional, autoría, capturas completas y focos editables. Añadir acciones, comprobación y resultado real de cada paso. No simular capturas ni declarar pruebas o publicaciones no realizadas.
- Guardar capturas PNG numeradas, ancho máximo1600px e índice en la carpeta de publicación del usuario. No mostrar secretos ni correos de estudiantes.
