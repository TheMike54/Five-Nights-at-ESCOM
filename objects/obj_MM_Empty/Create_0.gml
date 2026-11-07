/// @DnDAction : YoYo Games.Audio.Stop_All_Audio
/// @DnDVersion : 1
/// @DnDHash : 0789DC93
audio_stop_all();

/// @DnDAction : YoYo Games.Audio.Play_Audio
/// @DnDVersion : 1.1
/// @DnDHash : 1D8C7B6B
/// @DnDArgument : "soundid" "snd_MM"
/// @DnDArgument : "loop" "1"
/// @DnDSaveInfo : "soundid" "snd_MM"
audio_play_sound(snd_MM, 0, 1, 1.0, undefined, 1.0);

privacy_open = false;
privacy_page = 0;
// Keep the display awake only while the Android game is in the foreground.
if (os_type == os_android) os_powersave_enable(false);
