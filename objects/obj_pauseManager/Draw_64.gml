var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _s = min(_gw / 1280, _gh / 720);
var _ox = (_gw - 1280 * _s) / 2;
var _oy = (_gh - 720 * _s) / 2;

var _old_colour = draw_get_colour();
var _old_alpha = draw_get_alpha();
var _old_halign = draw_get_halign();
var _old_valign = draw_get_valign();

if (!global.game_paused) {
    // Pause button, hidden during the energy blackout.
    if (!(variable_global_exists("EnergyBlackout") && global.EnergyBlackout)) {
        var _x1 = _ox + btn_pause[0] * _s, _y1 = _oy + btn_pause[1] * _s;
        var _x2 = _ox + btn_pause[2] * _s, _y2 = _oy + btn_pause[3] * _s;
        draw_set_alpha(0.6);
        draw_set_colour(c_black);
        draw_rectangle(_x1, _y1, _x2, _y2, false);
        draw_set_alpha(0.9);
        draw_set_colour(c_white);
        draw_rectangle(_x1, _y1, _x2, _y2, true);
        var _bw = (_x2 - _x1) * 0.16, _bh = (_y2 - _y1) * 0.5;
        var _cx = (_x1 + _x2) / 2, _cy = (_y1 + _y2) / 2;
        draw_rectangle(_cx - _bw * 1.6, _cy - _bh / 2, _cx - _bw * 0.6, _cy + _bh / 2, false);
        draw_rectangle(_cx + _bw * 0.6, _cy - _bh / 2, _cx + _bw * 1.6, _cy + _bh / 2, false);
    }
} else {
    // Dark overlay over the whole screen.
    draw_set_alpha(0.85);
    draw_set_colour(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);

    draw_set_alpha(1);
    draw_set_colour(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(_ox + 640 * _s, _oy + 250 * _s, "JUEGO EN PAUSA", 2.5 * _s, 2.5 * _s, 0);
    draw_text_transformed(_ox + 640 * _s, _oy + 320 * _s, "Toca Reanudar o presiona ESC / P", 1.2 * _s, 1.2 * _s, 0);

    var _buttons = [[btn_resume, "Reanudar"], [btn_menu, "Salir al Menú"]];
    for (var i = 0; i < 2; i++) {
        var _b = _buttons[i][0];
        var _x1 = _ox + _b[0] * _s, _y1 = _oy + _b[1] * _s;
        var _x2 = _ox + _b[2] * _s, _y2 = _oy + _b[3] * _s;
        draw_set_colour((i == 0) ? c_dkgray : c_maroon);
        draw_rectangle(_x1, _y1, _x2, _y2, false);
        draw_set_colour(c_white);
        draw_rectangle(_x1, _y1, _x2, _y2, true);
        draw_text_transformed((_x1 + _x2) / 2, (_y1 + _y2) / 2, _buttons[i][1], 1.5 * _s, 1.5 * _s, 0);
    }
}

draw_set_colour(_old_colour);
draw_set_alpha(_old_alpha);
draw_set_halign(_old_halign);
draw_set_valign(_old_valign);
