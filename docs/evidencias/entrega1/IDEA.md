# Ficha de idea — Five Nights at ESCOM

**Equipo:** -
**Integrantes:** 
* Chávez Romero Jonathan - 2024630102 
* Moreno Noguerón Ximena - 2024630201 
* Reyes Castellanos José Abel - 2020311353
**Repositorio:** https://github.com/xime-ngrn/Five-Nights-at-ESCOM-Forked
**Última actualización:** 29/09/2026

---

## 1. Ruta elegida y motivo

**Ruta:** FiveNightsAtESCOM (proyecto realizado con GameMaker, con exportación a Android).

**Motivo:** Para la elección del proyecto, nos atrajo la propuesta de modificar un videojuego móvil mundialmente conocido para darle un toque personal sobre nuestra identidad politécnica. A su vez, el aprender cómo se realiza el desarrollo de los módulos y la lógica detrás para que estos juegos lleguen a tener cinemáticas, tramas y desarrollo de niveles.

El proyecto ya tiene una noche jugable completa (que incluye cámaras, láser, batería, reloj y condición de victoria/derrota), lo que nos permite concentrarnos en extenderlo en lugar de construir la base desde cero, buscando implementar funcionalidades nuevas que abarquen la idea original del juego, ir pasando noche por noche hasta llegar al final.

## 2. Problema en una frase

Un estudiante que juega en sus ratos libres pierde todo su avance al cerrar el juego y,
al terminar la Noche 1, no tiene más contenido que jugar.

> Evidencia en el código base: el botón **Continuar** (`obj_Continuar`) siempre manda a la Noche 1 (`room_goto(N1)`), no existe ningún guardado, y las pantallas `Opciones` y `Extras` no tienen código.

## 3. Usuario y contexto

* **Quién:** estudiante de la ESCOM, de 18 a 25 años, que conoce los espacios de la escuela.
* **Dónde:** en su teléfono Android, en la escuela o en el transporte.
* **Cuándo:** en tiempos muertos de 10 a 15 minutos (entre clases, en el metro o el camión).

## 4. Alternativa actual

Hoy el usuario tiene que jugar la Noche 1 desde el principio cada vez que abre el juego,
o jugar otro juego del género (por ejemplo, la saga original) que no está ambientado en ESCOM.

## 5. Tarea principal

Sobrevivir una noche completa (de 10 PM a 6 AM en el reloj del juego) y que, al terminar o volver a abrir la aplicación, **Continuar** lo lleve directamente a la siguiente noche desbloqueada.

## 6. Criterio de éxito

* Al reabrir la app, **Continuar** lleva a la noche correcta en el 100 % de las pruebas de la matriz [`docs/PRUEBAS.md`](PRUEBAS.md).
* Al menos (4 de 5) personas de prueba completan la Noche 1 en **3** intentos o menos.
* La noche siguiente (noche 2) es perceptiblemente más difícil, según (4 de 5) personas de prueba.
* En la noche 2 se visualiza un personaje nuevo, donde el personaje avanza si no lo miras en su cámara durante cierto tiempo.

## 7. Alcance de la primera versión

| Entra en la v1 | Archivo(s) base que se tocarían |
|---|---|
| Guardado de la noche alcanzada en el dispositivo (`save.ini`) | `obj_WinManager`, `obj_Coco` |
| Botón **Continuar** funcional: lleva a la Noche 2 si hay partida guardada; si no, se muestra deshabilitado | `obj_Continuar` |
| Noche 2 jugable reutilizando la oficina, con mayor dificultad de Prismoso | room `N2`, `obj_Culturales1`, `obj_PM` |
| Nuevo personaje que aparece solo en la Noche 2, en 3–4 cámaras, que avanza si el jugador **no lo vigila** en su cámara | Objeto nuevo del personaje, `obj_GOManager` |
| Jumpscare simple del nuevo personaje (sprite a pantalla completa, sacudida y sonido) | Objeto nuevo del personaje, room `GameOver` |

## 8. Funciones aplazadas

- Noches 3, 4 y 5.
- Apariciones del nuevo personaje en más de 4 cámaras.
- Animación completa de Game Over del nuevo personaje (secuencia de varios cuadros).
- Pantalla de **Opciones** (volumen, brillo, idioma).
- Pantalla de **Extras** (galería de personajes, créditos).

**Motivo del aplazamiento:** priorizamos que el ciclo "jugar → ganar → guardar →
continuar" funcione completo, y que la Noche 2 se sienta distinta gracias a un
enemigo con una mecánica nueva, antes de agregar más noches o pantallas secundarias.

## 9. Hipótesis pendiente de validar

> **Estado: HIPÓTESIS SIN VALIDAR.** Todavía no tenemos evidencia real que la respalde. Queda pendiente hacer al menos 5 encuestas a estudiantes de la ESCOM.

Creemos que los estudiantes de la ESCOM volverían a abrir el juego si este recordara
su avance y la siguiente noche presentara un enemigo nuevo dentro del ambiente de la ESCOM que exige una estrategia distinta a la de la Noche 1, atrayendo su curiosidad y aportando un cambio a la dinámica del juego.

## 10. Evidencia que sostiene la idea

| Fecha | Método | Resultado real |
|---|---|---|
| 29/09/2026 | Estudiante de 6to semestre juega la noche 1 del juego base y responde 2 preguntas: ¿Volverías a jugarlo mañana? ¿Qué te haría continuar? |  |

## 11. Uso de asistentes de IA

| Herramienta | Parte del trabajo |
|---|---|
| Claude (Anthropic) | Creación del borrador de la estructura de esta ficha y revisión del código base |