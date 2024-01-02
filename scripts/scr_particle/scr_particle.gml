function create_particle(x, y, sprite, xscale = 1)
{
	with obj_particlesystem
	{
		array_push(particles, {
			x: x,
			y: y,
			sprite: sprite,
			image_index: 0,
			image_speed: sprite_get_speed(sprite),
			xscale: xscale,
			yscale: 1
		});
	}
}
