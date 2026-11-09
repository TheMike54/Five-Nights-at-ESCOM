if (global.EnergyBlackout) exit;
var siendo_visto = (global.CameraUp == 1 && global.CamaraActiva == camara_actual);

if (siendo_visto) {
    // Mirarlo lo hace retroceder una cámara
    camara_actual = max(1, camara_actual - 1);
} else if (camara_actual < camara_max) {
    camara_actual += 1;
} else {
    global.JSBy = 2;
    room_goto(GameOver);
}
alarm[0] = room_speed * 10;