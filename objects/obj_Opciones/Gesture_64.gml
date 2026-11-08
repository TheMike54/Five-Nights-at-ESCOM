// Global tap: opens the panel from its menu button and handles every tap while it is open.
// The privacy panel owns menu input while open.
if (instance_exists(obj_MM_Empty) && obj_MM_Empty.privacy_open) exit;

var px = event_data[? "posX"];
var py = event_data[? "posY"];

if (!options_open) {
    if (point_in_rectangle(px, py, bbox_left - 10, bbox_top - 10, bbox_right + 10, bbox_bottom + 10)) {
        options_open = true;
        confirm_open = false;
        tap_consumed = true;
        with (obj_NuevoJuego) visible = false;
        with (obj_Continuar) visible = false;
        with (obj_Salir) visible = false;
    }
    exit;
}

tap_consumed = true;

if (confirm_open) {
    if (point_in_rectangle(px, py, cancel_zone[0], cancel_zone[1], cancel_zone[2], cancel_zone[3])) {
        confirm_open = false;
    } else if (point_in_rectangle(px, py, erase_zone[0], erase_zone[1], erase_zone[2], erase_zone[3])) {
        event_user(4); // erase saved progress
        confirm_open = false;
    }
    exit;
}

// Volume buttons: each tap moves the level 10 %.
var kinds = [0, 1]; // 0 = music, 1 = sound effects
for (var r = 0; r < 2; r++) {
    var top = row_y[r];
    var delta = 0;
    if (point_in_rectangle(px, py, minus_x, top, minus_x + btn_size - 1, top + btn_size - 1)) delta = -1;
    if (point_in_rectangle(px, py, plus_x, top, plus_x + btn_size - 1, top + btn_size - 1)) delta = 1;
    if (delta != 0) {
        if (kinds[r] == 0) {
            global.vol_music = clamp(round(global.vol_music * 10) + delta, 0, 10) / 10;
        } else {
            global.vol_sfx = clamp(round(global.vol_sfx * 10) + delta, 0, 10) / 10;
        }
        event_user(2); // apply volume
        if (kinds[r] == 1) event_user(3); // play a sample sound effect
        event_user(1); // save settings
        exit;
    }
}

if (point_in_rectangle(px, py, back_zone[0], back_zone[1], back_zone[2], back_zone[3])) {
    options_open = false;
    with (obj_NuevoJuego) visible = true;
    with (obj_Continuar) visible = true;
    with (obj_Salir) visible = true;
} else if (point_in_rectangle(px, py, reset_zone[0], reset_zone[1], reset_zone[2], reset_zone[3])) {
    confirm_open = true;
}
