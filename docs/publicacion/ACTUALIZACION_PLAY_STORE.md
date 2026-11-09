# Actualizaciones de Five Nights at ESCOM en Google Play

## Estado actual (8 de noviembre de 2026)

- **0.1.1 (código 1001)**, commit `0adaaaa`, rama `prepare/android-night2-update`: Noche 2, Intruso y Continuar. Envío 2 a revisión el 7 nov 2026, 12:43 (Ciudad de México), pista cerrada Alpha, México, lista 26-O Y 2027-1 (184 cuentas). El propietario informó el 8 nov que la actualización ya se lanzó; la IA no pudo verificarlo en Console (el navegador integrado no tenía sesión).
- AAB 0.1.1: SHA-256 `6C3DF2D04BB5FB2EF508DDAEFC41B92AE34D2CC91C4620D08BC56884C8296E88`. Informe completo y presentación: `C:\Users\gabri\Downloads\Respaldo Five Nights at ESCOM Play Store\actualizaciones\0.1.1-1001\`.
- **Después del lanzamiento** se integró en `main` la release 0.1.1 y el PR #2 (pausa, apagón, atajo), con el `.yyp` resuelto en formato nativo, sin el duplicado `docs/licencias.md` y con el controlador de pausa no persistente. Ver `docs/integracion-pr-2.md`.
- Pendiente para la próxima versión: control táctil de pausa y prueba en Android, QA manual del PR #2 en GameMaker, código de versión ≥ 1002 tras consultar Console, y revisar si la política o la ficha requieren cambios.

Lo que sigue es el contexto de preparación escrito el 5 nov 2026, antes de la 0.1.1; se conserva como historial.

# Preparación de actualización y tutorial de GameMaker

Solicitud del propietario,5noviembre2026: vincular este repositorio local a un proyecto de Codex, preparar la actualización con los cambios existentes en PR de su fork y documentar el paso a paso usando el formato de la presentación institucional Android/PlayStore indicada enAGENTS.md. GitHub Desktop está instalado.

## Evidencia verificada al preparar el proyecto

- Checkout limpio al inicio en `prepare/google-play-closed-test`, commit `5808e2cb625a4474795ee57045965a12ba40d076`.
- `origin` es gabrielhuav/Five-Nights-at-ESCOM; `upstream` es CarlosAdrianHernandezTorres/Five-Nights-at-ESCOM.
- Se actualizó únicamente la información de `origin`. No se integraron cambios de código ni se modificaron PR remotos.
- `origin/main`: `f62f9f0`, PR#4 integrado el29octubre2026: [Feature/night 2 and Intruso added](https://github.com/gabrielhuav/Five-Nights-at-ESCOM/pull/4). Incluye noche2, nuevo enemigo, susto y guardado/continuar.
- PR#2 abierto: [pausa y regreso al menú](https://github.com/gabrielhuav/Five-Nights-at-ESCOM/pull/2), cabeza `14d2cb7c44c5f0085e150f7efaa675b75e3ce163`. La rama fuente pertenece a Alexis177; el PR destino es el fork del propietario. Se obtuvo para inspección mediante `origin refs/pull/2/head`, referencia local `origin/pr-2`, sin añadir otro remoto ni escribir en otro fork.
- PR#2 figuraCONFLICTING frente a main y sus pruebas declaradas sonWindows/teclado. `obj_pauseManager` alterna pausa conESC/P; necesita adaptación y prueba táctil paraAndroid. Revisar también alarmas, batería, audio, instancias y limpieza al regresar al menú.
- Una simulación de fusión entre la rama de publicación ymain detectó15archivos en conflicto. La simulación no cambió el árbol de trabajo. No resolver todos conours/theirs.

## Riesgos concretos que debe resolver la integración

`origin/main` aún declara nombreDEMO, paquetecom.company.game, mínimo21, target35 y soporte de mandos activado. Tampoco contiene el panel de privacidad y fuente que sí están en la rama enviada aPlay. Tomarmain directamente como versión de publicación perdería preparativos importantes.

Preparar una rama de actualización en el fork que combine los cambios jugables deseados con la preparaciónAndroid de5808e2c. Revisar semánticamenteYYP, resource_order, eventos y recursos; conservar la privacidad y su protección frente a toques, el ícono, créditos, identidad y permisos. Resolver la navegaciónContinuar con el nuevo guardado sin impedir acceder al aviso de privacidad. No mezclar variantesGML/DnD inconsistentes.

## Identidad y antecedentes del primer envío

- JuegoFive Nights at ESCOM, gratis, es-419, México, público16–17 y18+.
- Paquete `ovh.gabrielhuav.fivenightsatescom`. Primera versión0.1.0,código1000, Androidmínimo24/objetivo36, ARM64.
- IDE2026.0.0.16LTS2026/runtime2026.0.0.23. Comprobar de nuevo el entorno instalado antes de compilar.
- Llave de carga y alias enAGENTS.md. CertificadoSHA256 `590D41B6D23761C0DD8C4E7EE588AA88106F5737D8322EEAD386F3FA968AB4D3`.
- AAB enviado: `C:\Users\gabri\Downloads\1151055 Administracion\Publicacion Five Nights at ESCOM\compilaciones\Five-Nights-at-ESCOM-0.1.0-5808e2c-release.aab`.
- SHA256 `64E04D55153B047F1BC3C3BCB9E10113869AF15499FC8634F458BAB95AC7185F`.
- Último estadoPlay comprobado en este chat: envíoID1,24octubre2026,18:01,En revisión. No asumir que sigue igual: consultar el estado actual, códigos de versión existentes y distribución antes de preparar otro lanzamiento.
- Cuenta previstagabrielhuav, appID4976238243139466166, pista cerradaAlpha4700087635787385375. Lista26-O Y2027-1 con184cuentas en la última verificación.
- Console: https://play.google.com/console/u/0/developers/7500976678857575574/app/4976238243139466166/publishing
- Política: https://gabrielhuav.github.io/Five-Nights-at-ESCOM/privacy/. Comprobar si el nuevo contenido/funciones requiere actualizarla y revisarIARC/seguridad de datos.
- Respaldo privado: `C:\Users\gabri\Downloads\Respaldo Five Nights at ESCOM Play Store`. No subirlo al repo: contiene la llave.
- Evidencias e informe anterior: `C:\Users\gabri\Downloads\1151055 Administracion\Publicacion Five Nights at ESCOM`.

## Guion de ejecución y documentación

1. Registrar el proyecto local enCodex con carpeta `C:\dev\Five-Nights-at-ESCOM`. No clonar una segunda copia. Verificar el proyecto registrado con la herramienta de proyectos. Su creación mediante la interfaz requiere intervención del propietario porque no hay herramienta para crear proyectos y la habilidadWindows prohíbe automatizarChatGPT.
2. GitHubDesktop: agregar el repositorio local existente si aún no está; verificarCurrent repository,origin y rama. DocumentarFetch origin y los PR. No publicar cambios enupstream.
3. Definir la rama de integración y resolver los conflictos preservando ambas aportaciones y la configuraciónPlay. RevisarPR#2 paraAndroid antes de decidir que forma parte del release; no describirlo como integrado si no lo está.
4. Abrir elYYP de esta carpeta enGameMaker. Revisar compilación, recursos faltantes y cambios delIDE. Documentar resolución de conflictos y controles táctiles reales.
5. Probar nueva instalación y actualización sobre la versión anterior, guardado/Continuar, noches1/2,Intruso,victoria/derrota, pausa/reanudar/salir, cámaras,láser,batería,segundo plano y privacidad. No aprobar casos sólo por las notas de otros autores. Separar pruebas propias de evidencia delPR.
6. Comprobar requisitos vigentes dePlay y compatibilidad16KB. Elegir nueva versión/código mayor que todos los deConsole y documentar paquete constante. No cambiar la llave de carga.
7. GenerarAABrelease firmado desdeGameMaker. Verificar firma, certificado, paquete, versión, ABI, alineación16KB ySHA256. Registrar commit y rutas exactas.
8. Actualizar la pista cerrada existente y las novedades; revisar si las nuevas noches/sustos cambianIARC, ficha, privacidad, permisos o datos. Conservar países/testers salvo indicación del propietario.
9. Revisar errores/advertencias y resumen completo. Mostrar resultado concreto y solicitar autorización antes del nuevo envío y su posible activación automática.
10. Tras autorización, enviar y registrar estado real, fecha,ID y enlaces disponibles. Los14días dependen de la participación continua requerida; no inferir el cumplimiento a partir de fechas o del tamaño de la lista.

## Presentación de referencia y entrega nueva

Referencia leída sin modificar:53diapositivas,16:9(10×5.625pulgadas), tipografíaCalibri/CalibriLight, portadaIPN/ESCOM, autorGabriel Hurtado Avilés, títulos numerados, capturas completas, recuadros editables, pie de figura y contexto/fuentes en notas.

SHA256 del original: `637D27251E45C9D80D971AD20F5F9DEFAB6D88360A3340800465FC5C847C6112`.

Crear una presentación separada en la carpeta de publicación, con título propuesto `Actualizar Five Nights at ESCOM en Google Play con GameMaker`. Sustituir las rutasKMP/Flutter por el flujo realGameMaker. No copiar las capturasSalonesUAM como evidencia de este juego.

Plan de capítulos: portada/objetivo, versión anterior yPR, agregar repo aCodex/GitHubDesktop, integración y conflictos, proyectoGameMaker, pruebasAndroid, firma existente y nueva versión, generación/verificaciónAAB, actualización de pista cerrada, resumen/autorización, envío/estado real y respaldo. Usar capturas nuevas del proceso y marcar evidencia anterior con su fecha. Incluir únicamente pasos realizados y resultados comprobados al cerrar la entrega.

Pendientes al crear este contexto: registro manual del proyectoCodex, integración/QA del nuevo código, compilación y nueva presentación. No hay nuevoAAB ni envío de actualización todavía.
