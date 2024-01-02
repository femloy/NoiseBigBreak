if abs(distance_to_object(obj_player)) < 25
	gotowardsplayer = true;

if gotowardsplayer
{
	move_towards_point(obj_player.x, obj_player.y, movespeed);
	movespeed++;
}
