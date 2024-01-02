live_auto_call;

event_inherited();
switch state
{
	case 1:
		player.state = states.actor;
		player.sprite_index = spr_player_mach1;
		player.image_index = 0;
		player.hsp = 0;
		player.vsp = 0;
		player.x = x;
		player.y = y;
		player.xscale = image_xscale;
		
		state = 2;
		break;
	
	case 2:
		if player.image_index >= player.image_number - 1
		{
			player.mach2 = 50;
			player.movespeed = 16;
			player.state = states.normal;
			state = 3;
		}
		break;
	
	case 3:
		if !place_meeting(x, y, player)
			state = 0;
		break;
}
