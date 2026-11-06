var l6837E2B6_0 = global.JSBy;
switch(l6837E2B6_0)
{
	case 1:
	layer_sequence_destroy(SecGO);
	
		sprite_index = spr_PMGO11;
		image_index = 0;
	
		with(obj_GOStatic) image_alpha = 0.156;
	
		alarm_set(2, 403);
	
		break;
    case 2:
        sprite_index = spr_IntrusoGO;
        image_index = 0;
        with (obj_GOStatic) image_alpha = 0.156;
        alarm_set(2, 403);
        break;
	break;
}