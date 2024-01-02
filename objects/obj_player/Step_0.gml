live_auto_call;

if keyboard_check_pressed(ord("R"))
{
	audio_stop_all();
	room_restart();
}

var key_left = -keyboard_check(vk_left);
var key_right = keyboard_check(vk_right);
var key_up = keyboard_check(vk_up);
var key_down = keyboard_check(vk_down);
var key_down2 = keyboard_check_pressed(vk_down);
var key_jump = keyboard_check_pressed(ord("Z"));
var key_jump2 = keyboard_check(ord("Z"));
var move = key_left + key_right;

switch state
{
	case states.normal:
		hsp = xscale * movespeed;
		
		if (place_meeting(x + sign(hsp), y, obj_solid) or scr_solid_slope(x + sign(hsp), y))
		&& (!place_meeting(x + hsp, y, obj_destroyable) or movespeed <= 12)
			movespeed = 0;
		
		if sprite_index == spr_player_stop
		{
			if image_index >= image_number - 1
				sprite_index = spr_player_idle;
		}
		else if movespeed == 0
			sprite_index = spr_player_idle;
		
		if move != xscale && movespeed > 0
		{
			sprite_index = spr_player_stopping;
			
			movespeed = Approach(movespeed, 0, 0.7);
			if movespeed == 0 && move != 0
				xscale = move;
			else if movespeed == 0
			{
				image_index = 0;
				sprite_index = spr_player_stop;
			}
		}
		else if move != 0 && !place_meeting(x + move, y, obj_solid)
		{
			xscale = move;
			if sprite_index != spr_player_mach1 && sprite_index != spr_player_mach2 && sprite_index != spr_player_mach3 && sprite_index != spr_player_runland
			{
				mach2 = 0;
				
				image_index = 0;
				sprite_index = spr_player_mach1;
			}
			if sprite_index == spr_player_mach1 && image_index >= image_number - 1
				sprite_index = spr_player_mach2;
			
			if sprite_index == spr_player_runland && image_index >= image_number - 1
				sprite_index = spr_player_mach2;
			
			if mach2 < 50
			{
				if movespeed < 12
					movespeed += 0.4;
				else
					mach2++;
			}
			else
			{
				if sprite_index != spr_player_runland
					sprite_index = spr_player_mach3;
				if movespeed < 16
					movespeed = Approach(movespeed, 16, 0.4);
				else if movespeed < 19
					movespeed = Approach(movespeed, 19, 0.01);
			}
			scr_player_addslopemomentum(0.08, 0);
		}
		
		if key_jump
		{
			jumpstop = false;
			
			state = states.jump;
			image_index = 0;
			sprite_index = spr_player_jump;
			
			if xscale != move && move != 0
			{
				audio_play_sound(sfx_jump, 0, false);
				sprite_index = spr_player_backflip;
				vsp = -16;
				xscale = move;
				movespeed = 2;
			}
			else if movespeed > 12
			{
				audio_play_sound(sfx_highjump, 0, false);
				sprite_index = spr_player_glidejumpstart;
				vsp = -20;
			}
			else
			{
				audio_play_sound(sfx_jump, 0, false);
				if movespeed > 6
					vsp = -16;
				else
					vsp = -12;
			}
		}
		
		if !grounded
		{
			state = states.jump;
			sprite_index = spr_player_fall;
		}
		else if movespeed > 6 && key_down
		{
			state = states.slide;
			sprite_index = spr_player_crouchslip;
		}
		break;
	
	case states.jump:
		hsp = xscale * movespeed;
		
		if !jumpstop && !key_jump2 && vsp < 0
		{
			jumpstop = true;
			vsp = 0;
		}
		
		if move != xscale
		{
			var spd = 0.4;
			if move == 0
				spd = 0.1;
			
			movespeed = Approach(movespeed, 0, move == 0 ? 0.1 : 0.4);
			if movespeed == 0 && move != 0
				xscale = move;
		}
		else if movespeed < 10
		{
			var spd = 0.4;
			if sprite_index == spr_player_backflip
				spd = 0.2;
			movespeed = Approach(movespeed, 10, spd);
		}
		
		if sprite_index == spr_player_glidejump && vsp >= 0
		{
			image_index = 0;
			sprite_index = spr_player_glidefallstart;
		}
		
		if image_index >= image_number - 1
		{
			switch sprite_index
			{
				case spr_player_jump:
					sprite_index = spr_player_fall;
					break;
				case spr_player_glidejumpstart:
					sprite_index = spr_player_glidejump;
					break;
				case spr_player_glidefallstart:
					sprite_index = spr_player_glidefall;
					break;
			}
		}
		
		if grounded
		{
			audio_play_sound(sfx_land, 0, false);
			
			state = states.normal;
			image_index = 0;
			sprite_index = move != 0 ? spr_player_runland : spr_player_idle;
		}
		
		if place_meeting(x + sign(hsp), y, obj_solid)
		&& (!place_meeting(x + hsp, y, obj_destroyable) or movespeed <= 12)
		{
			audio_play_sound(sfx_wallslide, 0, false);
			
			state = states.wallslide;
			sprite_index = spr_player_wallslide;
		}
		
		if movespeed > 2 && key_down2
		{
			state = states.slide;
			sprite_index = spr_player_dive;
			vsp = 10;
		}
		break;
	
	case states.wallslide:
		movespeed = 0;
		if grounded
			state = states.normal;
		
		if !place_meeting(x + xscale, y, obj_solid) or move == -xscale
		{
			sprite_index = spr_player_fall;
			image_index = 0;
			state = states.jump;
		}
		else if key_jump
		{
			audio_play_sound(sfx_jump, 0, false);
			
			xscale *= -1;
			movespeed = 10;
			state = states.jump;
			sprite_index = spr_player_bounce;
			vsp = -12;
		}
		break;
	
	case states.slide:
		hsp = xscale * movespeed;
		if (place_meeting(x + sign(hsp), y, obj_solid) or scr_solid_slope(x + sign(hsp), y))
		&& !place_meeting(x + hsp, y, obj_destroyable)
			movespeed = 0;
		
		if grounded
		{
			if sprite_index == spr_player_dive
			{
				audio_play_sound(sfx_land, 0, false);
				sprite_index = spr_player_crouchslip;
			}
			movespeed = Approach(movespeed, 0, 0.1);
			
			if movespeed <= 0
				state = states.normal;
			
			if key_jump
			{
				jumpstop = false;
				sprite_index = spr_player_longjump;
				image_index = 0;
				state = states.jump;
				vsp = -12;
			}
			scr_player_addslopemomentum(0.4, 0.2);
		}
		else if place_meeting(x + sign(hsp), y, obj_solid) && !place_meeting(x + hsp, y, obj_destroyable)
		{
			audio_play_sound(sfx_wallslide, 0, false);
			
			state = states.wallslide;
			sprite_index = spr_player_wallslide;
		}
		break;
}

if grounded && state == states.normal
{
	if movespeed > 12
		set_machsnd(sfx_mach3);
	else if sprite_index == spr_player_mach2
		set_machsnd(sfx_mach2);
	else if sprite_index == spr_player_mach1
		set_machsnd(sfx_mach1);
	else
		set_machsnd(noone);
}
else
	set_machsnd(noone);

if state == states.wallslide
	grav = vsp < 0 ? 0.4 : 0.2;
else
	grav = 0.5;

// collide destructibles
if movespeed > 12 or state == states.slide
{
	with instance_place(x + hsp, y, obj_destroyable)
		instance_destroy();
}

scr_collide_player();
