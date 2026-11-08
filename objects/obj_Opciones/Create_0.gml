// Options panel: music volume, sound effects volume and progress reset.
// Drawn in the Draw event at depth 150, between the static overlay (100) and the
// glitch animation (200), so the menu static keeps running on top of the panel.
depth = 150;

options_open = false;
confirm_open = false;

// Set to true by the tap that the panel handles in this step, so the other
// menu buttons ignore it. Cleared in End Step.
tap_consumed = false;

// Volume levels go from 0 to 1 in steps of 0.1.
if (!variable_global_exists("vol_music")) global.vol_music = 1;
if (!variable_global_exists("vol_sfx")) global.vol_sfx = 1;

// Layout in room coordinates (1280x720). Touch targets are at least 90 units
// tall: about 8 mm on a 6" phone, above the 48 dp Android minimum.
panel_x1 = 25;
panel_y1 = 20;
panel_x2 = 1255;
panel_y2 = 700;
btn_size = 96;
row_y = [170, 320];        // top of the music row and the sound effects row
minus_x = 305;
plus_x = 859;
bar_x = 425;
bar_block_w = 34;
bar_block_h = 60;
bar_gap = 8;
back_zone = [60, 595, 390, 685];
reset_zone = [915, 595, 1235, 685];
confirm_box = [250, 170, 1030, 550];
cancel_zone = [300, 420, 560, 516];
erase_zone = [720, 420, 980, 516];

event_user(0); // load saved settings
event_user(2); // apply volume
