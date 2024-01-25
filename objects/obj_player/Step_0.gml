live_auto_call;

if !keyboard_check(vk_control) && keyboard_check_pressed(ord("R"))
{
	ds_list_clear(global.saveroom);
	event_perform(ev_create, 0);
	targetDoor = "";
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

if key_jump
	input_buffer_jump = 10;
if input_buffer_jump > 0
	input_buffer_jump--;

switch state
{
	case states.normal:
		hsp = xscale * movespeed;
		
		if (place_meeting(x + sign(hsp), y, obj_solid) or scr_solid_slope(x + sign(hsp), y))
		&& (!place_meeting(x + hsp, y, obj_destroyable) or movespeed <= 12)
		{
			if place_meeting(x, y + 1, obj_slope)
			{
				vsp = -movespeed;
				sound_play_3d(sfx_wallslide, x, y);
			
				state = states.wallslide;
				sprite_index = spr_player_wallslide;
				grounded = false;
				movespeed = 0;
				
				exit;
			}
			movespeed = 0;
		}
		
		if sprite_index == spr_player_stop
		{
			if image_index >= image_number - 1
			{
				image_index = 0;
				sprite_index = spr_player_idle;
			}
		}
		else if sprite_index == spr_player_turn
		{
			if image_index >= image_number - 1
				sprite_index = spr_player_mach2;
		}
		else if movespeed == 0
			sprite_index = spr_player_idle;
		
		if movespeed < 12
			mach2 = 0;
		
		if move != xscale && movespeed > 0
		{
			if sprite_index != spr_player_stopping
			{
				create_particle(x, y, spr_dashcloud, xscale);
				if mach2 >= mach2_time
				{
					audio_stop_sound(sfx_stop);
					sound_play_3d(sfx_stop, x, y);
				}
				sprite_index = spr_player_stopping;
			}
			mach2 = 0;
			
			movespeed = Approach(movespeed, 0, 0.7);
			if movespeed == 0 && move != 0
			{
				xscale = move;
				image_index = 0;
				sprite_index = spr_player_turn;
			}
			else if movespeed == 0
			{
				image_index = 0;
				sprite_index = spr_player_stop;
			}
		}
		else if move != 0 && !place_meeting(x + move, y, obj_solid)
		{
			if ++part_time >= 16
			{
				part_time = 0;
				create_particle(x, y, spr_dashcloud, xscale);
			}
			
			xscale = move;
			if sprite_index != spr_player_mach1 && sprite_index != spr_player_mach2 && sprite_index != spr_player_mach3 && sprite_index != spr_player_runland && sprite_index != spr_player_turn
			{
				image_index = 0;
				sprite_index = spr_player_mach1;
			}
			if image_index >= image_number - 1 && (sprite_index == spr_player_mach1 or sprite_index == spr_player_runland or sprite_index == spr_player_turn)
				sprite_index = spr_player_mach2;
			
			if mach2 < mach2_time && movespeed <= 12
			{
				if movespeed < 12
					movespeed += 0.4;
				else
					mach2++;
			}
			else
			{
				mach2 = mach2_time;
				
				sprite_index = spr_player_mach3;
				if movespeed < 16
					movespeed = Approach(movespeed, 16, 0.4);
				else if movespeed < 19
					movespeed = Approach(movespeed, 19, 0.01);
			}
			scr_player_addslopemomentum(0.08, 0.04);
		}
		
		if input_buffer_jump
		{
			input_buffer_jump = 0;
			create_particle(x, y, spr_highjumpcloud2);
			
			jumpstop = false;
			state = states.jump;
			
			if xscale != move && move != 0
			{
				sound_play_3d(sfx_jump, x, y);
				sprite_index = spr_player_backflip;
				vsp = -16;
				xscale = move;
				movespeed = 2;
				
				jumpclouds = 10;
			}
			else if mach2 >= mach2_time
			{
				sound_play_3d(sfx_highjump, x, y);
				sprite_index = spr_player_glidejumpstart;
				vsp = -16;
				jumpclouds = 16;
			}
			else
			{
				sound_play_3d(sfx_jump, x, y);
				vsp = -14;
				
				if movespeed >= 12
				{
					sprite_index = spr_player_mach2jump;
					jumpclouds = 10;
				}
				else
					sprite_index = spr_player_jump;
			}
		}
		
		if !grounded
		{
			state = states.jump;
			sprite_index = spr_player_fall;
		}
		else if key_down
		{
			sound_play_3d(sfx_slide, x, y);
			movespeed = max(movespeed, 10);
			
			state = states.slide;
			image_index = 0;
			sprite_index = spr_player_forkstart;
		}
		break;
	
	case states.jump:
	case states.bounce:
		hsp = xscale * movespeed;
		
		if --jumpclouds > 0 && vsp < 0
		{
			if ++part_time >= (16 - jumpclouds) / 3
			{
				part_time = 0;
				create_particle(x, y + 50, spr_cloudeffect);
			}
		}
		else if movespeed >= 16
		{
			if ++part_time >= 8
			{
				part_time = 0;
				create_particle(x, y, spr_cloudeffect);
			}
		}
		
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
			if movespeed == 0 && move != 0 && sprite_index != spr_player_backflip && sprite_index != spr_player_backflipfall
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
				case spr_player_mach2jump:
					sprite_index = spr_player_mach2fall;
					break;
				case spr_player_backflip:
					sprite_index = spr_player_backflipfall;
					break;
			}
		}
		
		if grounded
		{
			create_particle(x, y, spr_landcloud);
			sound_play_3d(sfx_land, x, y);
			
			state = states.normal;
			image_index = 0;
			sprite_index = move != 0 ? spr_player_runland : spr_player_idle;
		}
		
		if place_meeting(x + sign(hsp), y, obj_solid)
		&& (!place_meeting(x + hsp, y, obj_destroyable) or movespeed <= 12)
		{
			if state == states.bounce
				movespeed = 0;
			else
			{
				sound_play_3d(sfx_wallslide, x, y);
			
				state = states.wallslide;
				sprite_index = spr_player_wallslide;
				vsp = min(vsp, 0);
			}
		}
		
		if movespeed > 2 && key_down2
		{
			sound_play_3d(sfx_groundpound, x, y);
			
			state = states.slide;
			sprite_index = spr_player_dive;
			vsp = 10;
		}
		break;
	
	case states.wallslide:
		movespeed = 0;
		
		if ++part_time >= 8
		{
			part_time = 0;
			create_particle(x + xscale * 10, y, spr_cloudeffect);
		}
		
		if grounded
		{
			sound_play_3d(sfx_land, x, y);
			create_particle(x, y, spr_landcloud);
			state = states.normal;
		}
		vsp = min(vsp, 8);
		
		sprite_index = vsp > 0 ? spr_player_wallslidedown : spr_player_wallslide;
		
		if !place_meeting(x + xscale, y, obj_solid) or move == -xscale
		{
			sprite_index = spr_player_fall;
			image_index = 0;
			state = states.jump;
		}
		else if input_buffer_jump
		{
			input_buffer_jump = 0;
			sound_play_3d(sfx_jump, x, y);
			
			xscale *= -1;
			movespeed = 10;
			state = states.jump;
			sprite_index = spr_player_bounce;
			vsp = -14;
		}
		break;
	
	case states.slide:
		hsp = xscale * movespeed;
		if (place_meeting(x + sign(hsp), y, obj_solid) or scr_solid_slope(x + sign(hsp), y))
		&& !place_meeting(x + hsp, y, obj_destroyable)
			movespeed = 0;
		
		if sprite_index == spr_player_forkstart && image_index >= image_number - 1
			sprite_index = spr_player_crouchslip;
		
		if grounded
		{
			if sprite_index == spr_player_dive
			{
				sound_play_3d(sfx_land, x, y);
				
				state = states.normal;
				sprite_index = spr_player_runland;
				image_index = 0;
			}
			else
			{
				if ++part_time >= 16
				{
					part_time = 0;
					create_particle(x, y, spr_dashcloud, xscale);
				}
				movespeed = Approach(movespeed, 0, 0.1);
			
				if movespeed <= 0
					state = states.normal;
			
				if input_buffer_jump
				{
					input_buffer_jump = 0;
					sound_play_3d(sfx_jump, x, y);
					create_particle(x, y, spr_highjumpcloud2);
				
					jumpstop = false;
					sprite_index = spr_player_longjump;
					image_index = 0;
					state = states.jump;
					vsp = -14;
					jumpclouds = 12;
				}
				scr_player_addslopemomentum(0.4, 0.2);
			}
		}
		else if place_meeting(x + sign(hsp), y, obj_solid) && !place_meeting(x + hsp, y, obj_destroyable)
		{
			sound_play_3d(sfx_wallslide, x, y);
			
			state = states.wallslide;
			sprite_index = spr_player_wallslide;
		}
		break;
	
	case states.hurt:
		if grounded && vsp >= 0
		{
			state = states.normal;
			movespeed = 0;
			inv = 80;
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

if state != states.jump && state != states.normal
	mach2 = 0;

if state == states.wallslide or (state == states.jump && mach2 >= mach2_time && vsp < 0)
	grav = 0.25;
else
	grav = 0.5;

// collide destructibles
if state == states.bounce
{
	with instance_place(x, y + vsp + 1, obj_destroyable)
	{
		other.vsp = -14;
		other.grounded = false;
		instance_destroy();
	}
}
if movespeed > 12 or state == states.slide
{
	with instance_place(x + hsp, y, obj_destroyable)
		instance_destroy();
	with instance_place(x, y + vsp + 1, obj_destroyable)
		instance_destroy();
}

scr_collide_player();

if inv > 0
{
	image_alpha = 1 - (floor(inv / 3) % 2);
	inv--;
}
else
{
	image_alpha = 1;
	inv = 0;
}

// spikes
var spike = instance_nearest(x, y, obj_spike);
if spike && abs(distance_to_object(spike)) < 1
{
	if state == states.bounce
	{
		vsp = -14;
		grounded = false;
	}
	else
		scr_hurtplayer();
}

if mouse_check_button_pressed(mb_left)
{
	x = mouse_x;
	y = mouse_y;
}
