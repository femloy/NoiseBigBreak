if state == 0
{
	if ds_queue_size(queue) >= 80
	{
		interp = Approach(interp, 1, 0.01);
		x = lerp(x, ds_queue_dequeue(queue), interp);
		y = lerp(y, ds_queue_dequeue(queue), interp);
	}
	ds_queue_enqueue(queue, obj_player.x, obj_player.y);
}
else
{
	interp = 0;
	ds_queue_clear(queue);
}

// helping points
var point = noone;
with obj_player
{
	with instance_nearest(x, y, obj_noisette_point)
	{
		if distance_to_object(other) < SCREEN_WIDTH / 3
			point = id;
	}
}

if instance_exists(point)
{
	state = 1;
	x = lerp(x, point.x, 0.1);
	y = lerp(y, point.y, 0.1);
	
	if distance_to_object(point) < 50
	{
		x = point.x;
		y = point.y;
	}
}
else
	state = 0;

// sprite
if x != xprevious or y != yprevious
	sprite_index = spr_noisette_move;
else
	sprite_index = spr_noisette_idle;

if x != xprevious
	image_xscale = sign(x - xprevious);
