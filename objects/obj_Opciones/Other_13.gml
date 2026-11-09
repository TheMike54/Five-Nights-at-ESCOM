/// @description Play a sample sound effect at the current volume
// Short camera sound, so the player hears the new effects volume right away.
// Stop the previous sample first so quick taps do not stack.
audio_stop_sound(snd_CamChng);
audio_play_sound(snd_CamChng, 0, false);
