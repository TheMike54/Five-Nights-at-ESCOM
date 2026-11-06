// Leer el progreso guardado
ini_open("progreso.ini");
var _ganada = ini_read_real("progreso", "noche_ganada", 0);
ini_close();

// Continuar solo se habilita si ya se ganó la Noche 1
habilitado = (_ganada >= 1);

// Si no está habilitado, se ve atenuado
image_alpha = habilitado ? 1 : 0.4;