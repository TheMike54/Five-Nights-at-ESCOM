/// @description Apply the volume settings to the game sounds
// The gain is set on each sound asset, not on the sound that is playing: every
// later audio_play_sound of that asset uses it, so none of the game's calls
// to audio_play_sound has to change.

// Music: the tracks that play in a loop in the background
// (main menu, office, thanks screen).
var music = [snd_MM, snd_BKMusic, snd_TY];

// Sound effects: every other sound the game plays.
var effects = [snd_6AM, snd_CamChng, snd_CamDown, snd_CamUp, snd_Electricidad,
    snd_EmptyButton, snd_Footsteps, snd_GameOver, snd_IntrusoJS, snd_Laser,
    snd_Night, snd_PMJS, snd_Reload];

for (var i = 0; i < array_length(music); i++) {
    audio_sound_gain(music[i], global.vol_music, 0);
}
for (var i = 0; i < array_length(effects); i++) {
    audio_sound_gain(effects[i], global.vol_sfx, 0);
}
