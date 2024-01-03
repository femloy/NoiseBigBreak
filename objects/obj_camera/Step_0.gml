live_auto_call;

var target = obj_player;

if instance_exists(target)
{
	var camx = target.x - CAMW / 2;
	var camy = target.y - CAMH / 2;
	
	if target.object_index == obj_player
	{
		chargecam = Approach(chargecam, target.movespeed * target.xscale * 4, 2);
		if target.state == states.jump && target.mach2 >= mach2_time && target.vsp < 0
			flycam = Approach(flycam, 100, 2);
		else
			flycam = Approach(flycam, -50, target.vsp > 0 ? 4 : 2);
		
		camx += chargecam;
		camy += flycam;
	}
	
	camx = clamp(camx, 0, room_width - CAMW);
	camy = clamp(camy, 0, room_height - CAMH);

	camera_set_view_pos(view_camera[0], camx, camy);
}
