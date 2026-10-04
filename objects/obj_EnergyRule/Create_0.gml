/// Regla de energía: termina la ronda cuando global.Bateria se agota.
/// Vive en la room Culturales1. No dibuja nada salvo el apagón (Draw GUI).

energy_threshold = 0;     // energía en la que se dispara la regla
blackout_steps   = 1;     // duración del apagón en frames (60 frames = 1 s)
triggered        = false; // ya se disparó en esta noche
blackout_timer   = 0;     // frames que faltan de apagón
