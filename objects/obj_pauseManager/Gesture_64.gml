// Global Tap: touch on Android and mouse click on Windows.
// Convert the tap to 1280x720 view units, matching the letterboxed game area
// (Android and Windows use "keep aspect ratio").
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _s = min(_gw / 1280, _gh / 720);
var _ox = (_gw - 1280 * _s) / 2;
var _oy = (_gh - 720 * _s) / 2;
var _x = (event_data[? "guiposX"] - _ox) / _s;
var _y = (event_data[? "guiposY"] - _oy) / _s;

if (!global.game_paused) {
    if (point_in_rectangle(_x, _y, btn_pause[0], btn_pause[1], btn_pause[2], btn_pause[3])) {
        pause_request = true;
    }
} else if (point_in_rectangle(_x, _y, btn_resume[0], btn_resume[1], btn_resume[2], btn_resume[3])) {
    resume_request = true;
} else if (point_in_rectangle(_x, _y, btn_menu[0], btn_menu[1], btn_menu[2], btn_menu[3])) {
    menu_request = true;
}
