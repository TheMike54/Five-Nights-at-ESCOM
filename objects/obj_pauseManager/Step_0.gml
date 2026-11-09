// Keyboard on Windows: ESC or P toggles the pause.
var _key = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("P"));
var _blackout = variable_global_exists("EnergyBlackout") && global.EnergyBlackout;

if (!global.game_paused) {
    if ((_key || pause_request) && !_blackout) {
        global.game_paused = true;
        instance_deactivate_all(true);
    }
} else if (menu_request) {
    // Reactivate before leaving so the room ends with a clean state.
    global.game_paused = false;
    instance_activate_all();
    room_goto(MenuPrincipal);
} else if (_key || resume_request) {
    global.game_paused = false;
    instance_activate_all();
}

pause_request = false;
resume_request = false;
menu_request = false;
