draw_self();

// Replace the version baked into the legacy background; retain its author credit.
var old_colour = draw_get_colour();
var old_alpha = draw_get_alpha();
var old_font = draw_get_font();
var old_halign = draw_get_halign();
var old_valign = draw_get_valign();

draw_set_alpha(1);
draw_set_colour(c_black);
draw_rectangle(1100, 675, 1280, 720, false);
draw_set_colour(c_white);
draw_set_font(-1);
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_text(1265, 695, "v" + GM_version);

draw_set_colour(old_colour);
draw_set_alpha(old_alpha);
draw_set_font(old_font);
draw_set_halign(old_halign);
draw_set_valign(old_valign);
