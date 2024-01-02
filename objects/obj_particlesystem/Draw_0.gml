for(var i = 0; i < array_length(particles); i++)
{
	var par = particles[i];
	draw_sprite_ext(par.sprite, par.image_index, par.x, par.y, par.xscale, par.yscale, 0, c_white, 1);
	
	par.image_index += par.image_speed;
	if par.image_index >= sprite_get_number(par.sprite)
		array_delete(particles, i--, 1);
}
