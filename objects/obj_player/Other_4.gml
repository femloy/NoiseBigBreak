live_auto_call;

var door_obj = noone;
with obj_doorX
{
	if door == other.targetDoor
	{
		door_obj = id;
		break;
	}
}

if door_obj
{
	x = door_obj.x + 16;
	y = door_obj.y - 14;
	
	var hallway = instance_place(x, y, obj_hallway);
	if hallway
		x = hallway.x + hallway.sprite_width + (-sign(hallway.image_xscale) * 200);
	
	var hallway = instance_place(x, y, obj_verticalhallway);
	if hallway
	{
		trace(verticalpos);
		
		x = hallway.x + (hallway.sprite_width * verticalpos);
		var bbox_size = abs(bbox_right - bbox_left);
		x = clamp(x, hallway.x + bbox_size, hallway.bbox_right - bbox_size);
		
		if hallway.image_yscale < 0
			y = hallway.bbox_bottom + 32;
		else
			y = hallway.bbox_top - 78;
		
		vsp = verticalspd;
		if state == states.wallslide
		{
			var move = verticalpos > .5 ? 1 : -1;
			for(var i = 1; i < 32; i++)
			{
				if place_meeting(x + i * move, y, obj_solid)
				{
					x += (i - 1) * move;
					break;
				}
			}
		}
	}
}

instance_create(x, y, obj_noisette);
