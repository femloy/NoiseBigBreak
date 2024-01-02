if state == 0 && place_meeting(x, y, obj_noisette) && place_meeting(x, y, obj_player)
{
	player = instance_place(x, y, obj_player);
	state = 1;
}
