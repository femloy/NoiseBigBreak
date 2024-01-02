function scr_collide()
{
	grounded = false;
	
	// vertical
	var vsp_final = vsp + vsp_carry;
	vsp_carry = 0;
	var target_y = round(y + vsp_final);
	var bbox_size_y = bbox_bottom - bbox_top;
	var t = abs(target_y - y) / bbox_size_y;
	var sv = sign(vsp_final);
	
	for (var i = 0; i < t; i++)
	{
		if (!scr_solid(x, y + (bbox_size_y * sv)))
		{
			y += (bbox_size_y * sv);
			if ((vsp_final > 0 && y >= target_y) || (vsp_final < 0 && y <= target_y))
			{
				y = target_y;
				break;
			}
			continue;
		}
		repeat (abs(target_y - y))
		{
			if (!scr_solid(x, y + sv))
				y += sv;
			else
			{
				vsp = 0;
				break;
			}
		}
		break;
	}
	
	// horizontal
	var hsp_final = hsp + hsp_carry;
	hsp_carry = 0;
	var target_x = round(x + hsp_final);
	var bbox_size_x = bbox_right - bbox_left;
	t = abs(target_x - x) / bbox_size_x;
	var sh = sign(hsp_final);
	var down = scr_solid(x, y + 1);
	
	for (i = 0; i < t; i++)
	{
		if (!scr_solid(x + (bbox_size_x * sh), y) && down == scr_solid(x + (bbox_size_x * sh), y + 1))
		{
			x += (bbox_size_x * sh);
			if ((hsp_final > 0 && x >= target_x) || (hsp_final < 0 && x <= target_x))
			{
				x = target_x;
				break;
			}
			continue;
		}
		repeat (abs(target_x - x))
		{
			// slopes
			for (var k = 1; k <= 3; k++)
			{
				if (scr_solid(x + sh, y) && !scr_solid(x + sh, y - k))
					y -= k;
				if (!scr_solid(x + sh, y) && !scr_solid(x + sh, y + 1) && scr_solid(x + sh, y + (k + 1)))
					y += k;
			}
			
			if (!scr_solid(x + sh, y))
				x += sh;
			else
			{
				hsp = 0;
				break;
			}
		}
	}
	
	// gravity
	if (vsp < 10)
		vsp += grav;
	
	// on ground check
	if vsp >= 0
		grounded |= scr_solid(x, y + 1);
}
function scr_collide_player()
{
	grounded = false;
	
	// vertical movement
	var vsp_final = vsp + vsp_carry;
	vsp_carry = 0;
	
	var target_y = round(y + vsp_final);
	var bbox_size_y = bbox_bottom - bbox_top;
	var t = abs(target_y - y) / bbox_size_y;
	var sv = sign(vsp_final);
	
	for (var i = 0; i < t; i++)
	{
		if (!scr_solid_player(x, y + (bbox_size_y * sv)))
		{
			y += (bbox_size_y * sv);
			if ((vsp_final > 0 && y >= target_y) || (vsp_final < 0 && y <= target_y))
			{
				y = target_y;
				break;
			}
			continue;
		}
		repeat (abs(target_y - y))
		{
			if (!scr_solid_player(x, y + sv))
				y += sv;
			else
			{
				vsp = 0;
				break;
			}
		}
		break;
	}
	
	// horizontal movement
	var hsp_final = hsp + hsp_carry;
	hsp_carry = 0;
	
	var target_x = round(x + hsp_final);
	var bbox_size_x = bbox_right - bbox_left;
	var t = abs(target_x - x) / bbox_size_x;
	var sh = sign(hsp_final);
	
	var down = scr_solid_player(x, y + 1);
	for (i = 0; i < t; i++)
	{
		if (!scr_solid_player(x + (bbox_size_x * sh), y) && down == scr_solid_player(x + (bbox_size_x * sh), y + 1) && !place_meeting(x + (bbox_size_x * sh), y, obj_slope) && !place_meeting(x, y, obj_slope) && !place_meeting(x + (bbox_size_x * sh), y + 1, obj_slope))
		{
			x += (bbox_size_x * sh);
			if ((hsp_final > 0 && x >= target_x) || (hsp_final < 0 && x <= target_x))
			{
				x = target_x;
				break;
			}
			continue;
		}
		repeat (abs(target_x - x))
		{
			// slopes (find a way to optimize them)
			var steepness = 4;
			with obj_convexslope
				if distance_to_object(other) < 1 steepness = max(image_yscale * 5, 12);
			
			for (var k = 1; k <= steepness; ++k)
			{
				// up slopes
				var infront = check_slope_at(x + sh, y);
				if (infront && !check_slope_at(x + sh, y - k))
					y -= k;
				
				// down slopes
				if place_meeting(x, y + 1, obj_slope) && (!infront && !scr_solid_player(x + sh, y + 1) && scr_solid_player(x + sh, y + k + 1))
					y += k;
			}
			
			if (!scr_solid_player(x + sh, y))
				x += sh;
			else
			{
				hsp = 0;
				break;
			}
		}
	}
	
	// gravity
	if (vsp < 20)
		vsp += grav;
	
	// moving platforms
	/*
	if (platformid != -4)
	{
		if (vsp < -1 || !instance_exists(platformid) || (!place_meeting(x, y + 16, platformid) || !place_meeting(x, y + 32, platformid)))
		{
			platformid = -4;
			y = floor(y);
		}
		else
		{
			grounded = true;
			vsp = grav;
			if (platformid.vsp > 0)
				vsp_carry = platformid.vsp;
			y = platformid.y - 46;
			if (!place_meeting(x, y + 1, platformid))
				y++;
			if (platformid.v_velocity != 0)
			{
				if (scr_solid(x, y))
				{
					for (i = 0; scr_solid(x, y); i++)
					{
						y--;
						if (i > 32)
							break;
					}
				}
				if (scr_solid(x, y))
				{
					for (i = 0; scr_solid(x, y); i++)
					{
						y++;
						if (i > 64)
							break;
					}
				}
			}
		}
	}
	*/
	
	// on ground check
	if vsp >= 0
		grounded |= scr_solid_player(x, y + 1);
	
	//if (platformid != -4 || (place_meeting(x, y + 1, obj_movingplatform) && !place_meeting(x, y - 3, obj_movingplatform)) || place_meeting(x, y + 8, obj_movingplatform && !place_meeting(x, y + 6, obj_movingplatform)))
	//	grounded = true;
	if (grounded && platformid == noone)
		y = floor(y);
}
