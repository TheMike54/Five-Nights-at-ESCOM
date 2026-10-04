if (!triggered) {
    if (global.Bateria <= energy_threshold) {
        triggered      = true;
        blackout_timer = blackout_steps;
        global.Bateria = energy_threshold;

        // Apagar consumidores y controles: mismo estado que deja obj_BatCheck en su case 0.
        global.BatCamara    = 0;
        global.BatLaser     = 0;
        global.Laser        = 0;
        global.BatConteo    = 0;
        global.CameraUp     = 0;
        global.blockCam     = 0;
        global.CambioCamara = 0;

        // Silencio total durante el apagón.
        audio_stop_all();

        // Congelar el reloj y al Prismoso: la ronda termina por esta regla.
        with (obj_WinTimer) {
            alarm[0] = -1;
        }
        with (obj_PM) {
            alarm[0] = -1;
            alarm[1] = -1;
            alarm[2] = -1;
        }
    }
} else {
    blackout_timer -= 1;
    if (blackout_timer <= 0) {
        // Reutiliza el game over existente: obj_GOManager solo reacciona a JSBy == 1.
        global.JSBy = 1;
        room_goto(GameOver);
    }
}
