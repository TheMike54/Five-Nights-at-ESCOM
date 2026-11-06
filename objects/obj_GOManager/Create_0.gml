audio_stop_all();

SecGO = 0;
InstGO = 0;

var l410F1E72_0 = global.JSBy;
switch(l410F1E72_0)
{
    case 1:
    InstGO = instance_create_layer(0, 0, "Estatica", obj_PMJS);

        alarm_set(0, 620);

        break;
     case 2:
        InstGO = instance_create_layer(0, 0, "Estatica", obj_IntrusoJS);
        alarm_set(0, 150); // 2.5 s de susto
        break;
    break;
}