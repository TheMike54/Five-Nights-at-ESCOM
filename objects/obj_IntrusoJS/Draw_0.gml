// Temblor aleatorio alrededor del centro de la pantalla
var _dx = irandom_range(-12, 12);
var _dy = irandom_range(-12, 12);
draw_sprite_ext(spr_IntrusoJS, 0, 640 + _dx, 360 + _dy, escala, escala, 0, c_white, 1);