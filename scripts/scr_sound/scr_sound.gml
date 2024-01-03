function sound_play_3d(sound, x, y)
{
	if live_call(sound, x, y) return live_result;
	
	return audio_play_sound_at(sound, -x, y, 1000, 1000, 0, 3, false, 0);
}
