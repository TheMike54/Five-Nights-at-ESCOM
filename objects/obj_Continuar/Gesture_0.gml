// The privacy panel owns menu input while open.
if (instance_exists(obj_MM_Empty) && obj_MM_Empty.privacy_open) exit;
// The options panel owns menu input while open.
if (instance_exists(obj_Opciones) && (obj_Opciones.options_open || obj_Opciones.tap_consumed)) exit;

if (habilitado) {
    global.Noche = 2;
    room_goto(N2);
}
