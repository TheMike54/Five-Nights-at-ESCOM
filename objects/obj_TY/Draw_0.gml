// Keep the original author's credit while describing the continued release.
if (image_alpha <= 0) exit;

var old_colour = draw_get_colour();
var old_alpha = draw_get_alpha();
var old_font = draw_get_font();
var old_halign = draw_get_halign();
var old_valign = draw_get_valign();

draw_set_font(fnt_Privacidad);
draw_set_colour(c_white);
draw_set_alpha(image_alpha);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(640, 110, "¡Muchas gracias por jugar!", 2, 2, 0);
draw_text_transformed(640, 290,
    "Five Nights at ESCOM"
    + "\nVersión en desarrollo · " + GM_version
    + "\n\nProyecto original (2025): Carlos Adrián Hernández Torres"
    + "\nContinuación: Gabriel Hurtado Avilés"
    + "\n\nToca la pantalla para continuar.", 1.35, 1.35, 0);

draw_set_colour(old_colour);
draw_set_alpha(old_alpha);
draw_set_font(old_font);
draw_set_halign(old_halign);
draw_set_valign(old_valign);
