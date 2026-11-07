var sx = display_get_gui_width() / 1280;
var sy = display_get_gui_height() / 720;
var old_colour = draw_get_colour();
var old_alpha = draw_get_alpha();
var old_font = draw_get_font();
var old_halign = draw_get_halign();
var old_valign = draw_get_valign();
draw_set_alpha(1);
draw_set_font(fnt_Privacidad);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

if (!privacy_open) {
    draw_set_colour(c_white);
    draw_text_transformed(75 * sx, 615 * sy, "Privacidad", 1.7 * sx, 1.7 * sy, 0);
} else {
    draw_set_colour(c_black);
    draw_rectangle(25 * sx, 20 * sy, 1255 * sx, 700 * sy, false);
    draw_set_colour(c_white);
    draw_rectangle(25 * sx, 20 * sy, 1255 * sx, 700 * sy, true);
    draw_text_transformed(75 * sx, 55 * sy,
        "Privacidad de Five Nights at ESCOM · " + string(privacy_page + 1) + "/2",
        2 * sx, 2 * sy, 0);

    var policy;
    if (privacy_page == 0) {
        policy = "Versión 0.1.0 · 23 de octubre de 2026\n\n"
            + "Responsable: Gabriel Hurtado Avilés (gabrielhuav).\n"
            + "Contacto de privacidad y soporte: gabrielhuav@gmail.com.\n\n"
            + "Esta versión funciona sin cuentas de usuario y no recopila ni comparte datos personales. "
            + "No incluye anuncios, compras integradas, analítica ni seguimiento. Los sonidos, imágenes "
            + "y video se incluyen en el juego; no se descargan durante la partida.\n\n"
            + "No solicita Internet, ubicación, contactos, cámara, micrófono ni archivos compartidos. "
            + "Las cámaras de la partida son parte del escenario ficticio y no usan la cámara del teléfono.\n\n"
            + "Los archivos internos que Android pueda crear para ejecutar el juego permanecen en tu "
            + "dispositivo. El distribuidor no los recibe. Puedes eliminarlos desde el almacenamiento "
            + "de Android o desinstalando el juego.";
    } else {
        policy = "Correo de soporte\n\n"
            + "Si escribes voluntariamente a gabrielhuav@gmail.com, usaremos tu correo y el mensaje "
            + "para atender tu solicitud. Se conservan durante el tiempo necesario para tramitarla "
            + "y las obligaciones aplicables. Puedes solicitar su eliminación al mismo correo. "
            + "No envíes contraseñas ni información sensible. El servicio de correo procesa los "
            + "mensajes según sus propias condiciones.\n\n"
            + "Google Play gestiona la descarga y la prueba cerrada según sus propias condiciones "
            + "y política de privacidad. El juego no recibe tu correo por estar en la lista de testers. "
            + "Los correos de participantes no se publican ni se incluyen en el juego.\n\n"
            + "El público objetivo comprende 16–17 años y 18 años o más. Contiene terror y sustos; "
            + "la clasificación de contenido de Google Play es independiente del público objetivo.\n\n"
            + "Si futuras versiones cambian el tratamiento de información, actualizaremos esta "
            + "política y la declaración de Seguridad de los datos antes de distribuirlas.";
    }
    draw_text_ext_transformed(75 * sx, 120 * sy, policy,
        21 / 1.35, 1120 / 1.35, 1.35 * sx, 1.35 * sy, 0);
    draw_text_transformed(75 * sx, 650 * sy, "Volver al menú", 1.7 * sx, 1.7 * sy, 0);
    draw_text_transformed(930 * sx, 650 * sy,
        privacy_page == 0 ? "Siguiente >" : "< Anterior", 1.7 * sx, 1.7 * sy, 0);
}

draw_set_colour(old_colour);
draw_set_alpha(old_alpha);
draw_set_font(old_font);
draw_set_halign(old_halign);
draw_set_valign(old_valign);
