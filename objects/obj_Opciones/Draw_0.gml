if (!options_open) {
    draw_self();
    exit;
}

var old_colour = draw_get_colour();
var old_alpha = draw_get_alpha();
var old_font = draw_get_font();
var old_halign = draw_get_halign();
var old_valign = draw_get_valign();

draw_set_font(fnt_Privacidad);

// Panel: same frame as the privacy panel, slightly see-through.
draw_set_alpha(0.92);
draw_set_colour(c_black);
draw_rectangle(panel_x1, panel_y1, panel_x2, panel_y2, false);
draw_set_alpha(1);
draw_set_colour(c_white);
draw_rectangle(panel_x1, panel_y1, panel_x2, panel_y2, true);
draw_rectangle(panel_x1 + 1, panel_y1 + 1, panel_x2 - 1, panel_y2 - 1, true);

draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text_transformed(75, 82, "Opciones", 2.9, 2.9, 0);

// Volume rows.
var labels = ["Música", "Efectos"];
var levels = [global.vol_music, global.vol_sfx];
for (var r = 0; r < 2; r++) {
    var top = row_y[r];
    var mid = top + btn_size / 2;
    var filled = round(levels[r] * 10);

    draw_set_colour(c_white);
    draw_set_halign(fa_left);
    draw_text_transformed(75, mid, labels[r], 2.2, 2.2, 0);

    // Minus and plus buttons: 96x96 frames with a 3 px border.
    for (var b = 0; b < 3; b++) {
        draw_rectangle(minus_x + b, top + b, minus_x + btn_size - 1 - b, top + btn_size - 1 - b, true);
        draw_rectangle(plus_x + b, top + b, plus_x + btn_size - 1 - b, top + btn_size - 1 - b, true);
    }
    draw_rectangle(minus_x + 30, mid - 2, minus_x + btn_size - 31, mid + 2, false);
    draw_rectangle(plus_x + 30, mid - 2, plus_x + btn_size - 31, mid + 2, false);
    draw_rectangle(plus_x + btn_size / 2 - 2, mid - 18, plus_x + btn_size / 2 + 2, mid + 18, false);

    // Level bar: 10 blocks, filled up to the current level.
    var by1 = mid - bar_block_h / 2;
    var by2 = mid + bar_block_h / 2;
    for (var i = 0; i < 10; i++) {
        var bx1 = bar_x + i * (bar_block_w + bar_gap);
        var bx2 = bx1 + bar_block_w - 1;
        if (i < filled) {
            draw_set_colour(c_white);
            draw_rectangle(bx1, by1, bx2, by2, false);
        } else {
            draw_set_colour(make_colour_rgb(90, 90, 90));
            draw_rectangle(bx1, by1, bx2, by2, true);
            draw_rectangle(bx1 + 1, by1 + 1, bx2 - 1, by2 - 1, true);
        }
    }

    draw_set_colour(make_colour_rgb(191, 191, 191));
    draw_set_halign(fa_right);
    draw_text_transformed(1090, mid, string(filled * 10) + " %", 1.9, 1.9, 0);
}

// Bottom actions.
draw_set_halign(fa_left);
draw_set_colour(c_white);
draw_text_transformed(back_zone[0] + 15, (back_zone[1] + back_zone[3]) / 2, "Volver al menú", 2.1, 2.1, 0);
draw_set_colour(make_colour_rgb(191, 191, 191));
draw_text_transformed(reset_zone[0] + 15, (reset_zone[1] + reset_zone[3]) / 2, "Borrar progreso", 2.1, 2.1, 0);

// Confirmation before erasing the saved progress.
if (confirm_open) {
    draw_set_alpha(0.55);
    draw_set_colour(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
    draw_rectangle(confirm_box[0], confirm_box[1], confirm_box[2], confirm_box[3], false);
    draw_set_colour(c_white);
    draw_rectangle(confirm_box[0], confirm_box[1], confirm_box[2], confirm_box[3], true);
    draw_rectangle(confirm_box[0] + 1, confirm_box[1] + 1, confirm_box[2] - 1, confirm_box[3] - 1, true);

    draw_set_halign(fa_left);
    draw_text_transformed(confirm_box[0] + 50, confirm_box[1] + 60, "Borrar el progreso", 2.3, 2.3, 0);
    draw_set_colour(make_colour_rgb(191, 191, 191));
    draw_text_transformed(confirm_box[0] + 50, confirm_box[1] + 130, "Se borran las noches ganadas y Continuar se desactiva.", 1.5, 1.5, 0);
    draw_text_transformed(confirm_box[0] + 50, confirm_box[1] + 166, "El volumen que elegiste se conserva.", 1.5, 1.5, 0);

    draw_set_colour(c_white);
    draw_set_halign(fa_center);
    var zones = [cancel_zone, erase_zone];
    var texts = ["Cancelar", "Borrar"];
    for (var z = 0; z < 2; z++) {
        var zz = zones[z];
        for (var k = 0; k < 3; k++) {
            draw_rectangle(zz[0] + k, zz[1] + k, zz[2] - k, zz[3] - k, true);
        }
        draw_text_transformed((zz[0] + zz[2]) / 2, (zz[1] + zz[3]) / 2, texts[z], 2.1, 2.1, 0);
    }
}

draw_set_colour(old_colour);
draw_set_alpha(old_alpha);
draw_set_font(old_font);
draw_set_halign(old_halign);
draw_set_valign(old_valign);
