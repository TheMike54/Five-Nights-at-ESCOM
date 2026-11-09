global.game_paused = false;

// Touch and mouse requests are recorded in the Global Tap event and applied
// in the next Step, after the tap has been delivered to the other instances.
pause_request = false;
resume_request = false;
menu_request = false;

// Buttons in 1280x720 view units: [x1, y1, x2, y2].
// The pause button sits between the 325 px edge-scroll zone of the office
// and the clock of the camera view, so tapping it does not move the view.
btn_pause = [360, 16, 448, 104];
btn_resume = [490, 380, 790, 460];
btn_menu = [490, 480, 790, 560];
