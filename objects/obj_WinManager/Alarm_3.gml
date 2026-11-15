/// @DnDAction : YoYo Games.Common.If_Variable
/// @DnDVersion : 1
/// @DnDHash : 1130E8A7
/// @DnDArgument : "var" "Vol"
/// @DnDArgument : "op" "2"
if(Vol > 0)
{
	/// @DnDAction : YoYo Games.Common.Variable
	/// @DnDVersion : 1
	/// @DnDHash : 26B57A53
	/// @DnDParent : 1130E8A7
	/// @DnDArgument : "expr" "max(0, Vol - 0.1)"
	/// @DnDArgument : "var" "Vol"
	Vol = max(0, Vol - 0.1);

	/// @DnDAction : YoYo Games.Audio.Audio_Set_Volume
	/// @DnDVersion : 1.1
	/// @DnDHash : 6086804F
	/// @DnDParent : 1130E8A7
	/// @DnDArgument : "sound" "snd_TY"
	/// @DnDArgument : "volume" "Vol * global.vol_music"
	/// @DnDSaveInfo : "sound" "snd_TY"
	audio_sound_gain(snd_TY, Vol * global.vol_music, 0);

	/// @DnDAction : YoYo Games.Instances.Set_Alarm
	/// @DnDVersion : 1
	/// @DnDHash : 2BA4C172
	/// @DnDParent : 1130E8A7
	/// @DnDArgument : "steps" "6"
	/// @DnDArgument : "alarm" "3"
	alarm_set(3, 6);
}

/// @DnDAction : YoYo Games.Common.Else
/// @DnDVersion : 1
/// @DnDHash : 0820F0B8
else
{
	/// @DnDAction : YoYo Games.Sequences.Sequence_Destroy
	/// @DnDVersion : 1
	/// @DnDHash : 19ABB563
	/// @DnDParent : 0820F0B8
	/// @DnDArgument : "var" "SecWin"
	layer_sequence_destroy(SecWin);

	/// @DnDAction : YoYo Games.Audio.Stop_All_Audio
	/// @DnDVersion : 1
	/// @DnDHash : 07EE99F2
	/// @DnDParent : 0820F0B8
	audio_stop_all();

	/// @DnDAction : YoYo Games.Audio.Play_Audio
	/// @DnDVersion : 1.1
	/// @DnDHash : 767A8A25
	/// @DnDParent : 0820F0B8
	/// @DnDArgument : "soundid" "snd_CamChng"
	/// @DnDSaveInfo : "soundid" "snd_CamChng"
	audio_play_sound(snd_CamChng, 0, 0, 1.0, undefined, 1.0);

	/// @DnDAction : YoYo Games.Instances.Set_Alarm
	/// @DnDVersion : 1
	/// @DnDHash : 44CD6731
	/// @DnDParent : 0820F0B8
	/// @DnDArgument : "steps" "12"
	/// @DnDArgument : "alarm" "4"
	alarm_set(4, 12);
}