live_auto_call;

enum states
{
	normal,
	mach,
	jump,
	slide,
	hurt,
	wallslide,
	bounce,
	actor,
	hitstun
}
#macro mach2_time 30

depth = -6;
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
inv = 0;

input_buffer_jump = 0;

verticalpos = 0;
verticalspd = 0;

targetRoom = 0;
targetDoor = "A";

scr_player_addslopemomentum = function(acc, dec)
{
	with (instance_place(x, y + 1, obj_slope))
	{
		if sign(image_xscale) == -sign(other.xscale) && other.movespeed < 19
			other.movespeed += acc;
		else if other.movespeed > 12
			other.movespeed -= dec;
	}
}
scr_hurtplayer = function()
{
	if state == states.hurt or inv > 0
		exit;
	
	hp--;
	if hp <= 0
		instance_destroy();
	
	sound_play_3d(sfx_hurt, x, y);
	grounded = false;
	movespeed = 0;
	hsp = xscale * -6;
	vsp = -10;
	state = states.hurt;
	sprite_index = spr_player_hurt;
}

// effects
machsnd = noone;
machsnd_play = noone;
part_time = 0;
jumpclouds = 0;

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
