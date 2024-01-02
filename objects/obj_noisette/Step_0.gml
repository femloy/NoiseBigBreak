if ds_queue_size(queue) >= 50
{
	x = ds_queue_dequeue(queue);
	y = ds_queue_dequeue(queue);
}
ds_queue_enqueue(queue, obj_player.x, obj_player.y);

if x != xprevious
{
	image_xscale = sign(x - xprevious);
	sprite_index = spr_noisette_move;
}
else
	sprite_index = spr_noisette_idle;
