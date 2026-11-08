/// @description Save the volume settings
ini_open("progreso.ini");
ini_write_real("ajustes", "vol_music", global.vol_music);
ini_write_real("ajustes", "vol_sfx", global.vol_sfx);
ini_close();
