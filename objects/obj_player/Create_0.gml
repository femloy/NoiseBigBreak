live_auto_call;

enum states
{
	normal,
	mach,
	jump,
	slide,
	hurt,
	wallslide
}

hp = 4;
image_speed = 0.35;
hsp = 0;
vsp = 0;
grounded = false;
grav = 0.5;
state = states.normal;
hsp_carry = 0;
vsp_carry = 0;
platformid = noone;
xscale = 1;
yscale = 1;
movespeed = 0;
mach2 = 0;
jumpstop = false;

machsnd = noone;
machsnd_play = noone;

set_machsnd = function(sound)
{
	if machsnd == sound
		exit;
	
	if machsnd != noone
		audio_stop_sound(machsnd_play);
	
	if sound != noone
	{
		machsnd = sound;
		machsnd_play = audio_play_sound(sound, 0, true);
	}
	else
		machsnd = noone;
}
scr_player_addslopemomentum = function(slow_acc, fast_acc)
{
	with (instance_place(x, y + 1, obj_slope))
	{
		if (sign(image_xscale) == -sign(other.xscale))
		{
			if abs(image_yscale) < abs(image_xscale) // wide slope
				other.movespeed += slow_acc;
			else // normal slope
				other.movespeed += fast_acc;
		}
	}
}
