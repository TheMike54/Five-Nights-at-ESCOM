/// @description Erase the saved progress and keep the volume settings
ini_open("progreso.ini");
ini_section_delete("progreso");
ini_close();

// Refresh Continue right away: dimmed and disabled
with (obj_Continuar)
{
	habilitado = false;
	image_alpha = 0.4;
}
