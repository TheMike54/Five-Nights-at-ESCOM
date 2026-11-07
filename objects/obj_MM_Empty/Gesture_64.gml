var px = device_mouse_x_to_gui(0) * 1280 / display_get_gui_width();
var py = device_mouse_y_to_gui(0) * 720 / display_get_gui_height();

if (!privacy_open) {
    if (point_in_rectangle(px, py, 60, 600, 300, 655)) {
        privacy_open = true;
        privacy_page = 0;
    }
} else if (point_in_rectangle(px, py, 60, 625, 300, 690)) {
    privacy_open = false;
} else if (point_in_rectangle(px, py, 900, 625, 1220, 690)) {
    privacy_page = 1 - privacy_page;
}
