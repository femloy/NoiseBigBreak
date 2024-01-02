with other
{
	targetRoom = other.targetRoom;
	targetDoor = other.targetDoor;
	
	if !instance_exists(obj_fadeout)
	{
		verticalspd = vsp;
		verticalpos = (x - other.x) / other.sprite_width;
		
		instance_create(0, 0, obj_fadeout);
	}
}
