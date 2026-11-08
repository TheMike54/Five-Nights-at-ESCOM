/// @description Load the saved volume settings
ini_open("progreso.ini");
global.vol_music = clamp(round(ini_read_real("ajustes", "vol_music", 1) * 10) / 10, 0, 1);
global.vol_sfx = clamp(round(ini_read_real("ajustes", "vol_sfx", 1) * 10) / 10, 0, 1);
ini_close();
