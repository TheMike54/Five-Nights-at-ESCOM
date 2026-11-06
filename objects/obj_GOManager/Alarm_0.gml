var l3A51AFD2_0 = global.JSBy;
switch(l3A51AFD2_0)
{
	case 1:
	with(obj_PMJS) instance_destroy();
	
		audio_play_sound(snd_GameOver, 0, 0, 1.0, undefined, 1.0);
	
		SecGO = layer_sequence_create("Secuencia", 640, 360, sqn_PMGO);
	
		alarm_set(1, 20);
	
		break;
    case 2:
        with (obj_IntrusoJS) instance_destroy();
        audio_play_sound(snd_GameOver, 0, 0, 1.0, undefined, 1.0);
        alarm_set(1, 20);
        break;
	break;
}