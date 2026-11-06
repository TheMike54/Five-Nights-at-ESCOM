/// @DnDAction : YoYo Games.Instances.Set_Sprite
/// @DnDVersion : 1
/// @DnDHash : 024F72E7
/// @DnDArgument : "spriteind" "spr_Win18"
/// @DnDSaveInfo : "spriteind" "spr_Win18"
sprite_index = spr_Win18;
image_index = 0;

/// @DnDAction : YoYo Games.Sequences.Sequence_Destroy
/// @DnDVersion : 1
/// @DnDHash : 0B11BB19
/// @DnDArgument : "var" "SecWin"
layer_sequence_destroy(SecWin);

/// @DnDAction : YoYo Games.Common.Execute_Code
/// @DnDVersion : 1
/// @DnDHash : 46E0F60A
/// @DnDArgument : "code" "/// @description Execute Code$(13_10)if (global.Noche == 1) {$(13_10)    // Noche 1 ganada: volver al menú principal (Continuar ya queda habilitado)$(13_10)    alarm_set(4, 426);$(13_10)} else {$(13_10)    // Última noche disponible: mostrar los agradecimientos$(13_10)    alarm_set(1, 426);$(13_10)}"
/// @description Execute Code
if (global.Noche == 1) {
    // Noche 1 ganada: volver al menú principal (Continuar ya queda habilitado)
    alarm_set(4, 426);
} else {
    // Última noche disponible: mostrar los agradecimientos
    alarm_set(1, 426);
}