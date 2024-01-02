if !scr_solid(x, y + 1) && !place_meeting(x, y + 1, obj_player)
	grounded = false;
else if !grounded
	instance_destroy();

if !grounded
{
	vsp += 0.25;
	y += vsp;
}
