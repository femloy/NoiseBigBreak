function scr_solid(_x, _y)
{
	var old_x = x;
	var old_y = y;
	x = _x;
	y = _y;
	if (place_meeting(x, y, obj_solid))
	{
		x = old_x;
		y = old_y;
		return true;
	}
	if (y > old_y && place_meeting(x, y, obj_platform))
	{
		var num = instance_place_list(x, y, obj_platform, global.instancelist, false);
		var _collided = false;
		for (var i = 0; i < num; i++)
		{
			var b = ds_list_find_value(global.instancelist, i);
			if (id != b.id && !place_meeting(x, old_y, b) && place_meeting(x, y, b))
				_collided = true;
		}
		ds_list_clear(global.instancelist);
		if (_collided)
		{
			x = old_x;
			y = old_y;
			return true;
		}
	}
	if (check_slope(obj_slope))
	{
		x = old_x;
		y = old_y;
		return true;
	}
	x = old_x;
	y = old_y;
	return false;
}
function check_slope(slope_object)
{
	if live_call(slope_object) return live_result;
	
	var slope = instance_place(x, y, slope_object);
	with (slope)
	{
		var left = bbox_left;
		var bottom = bbox_bottom;
		var right = bbox_right;
		var top = bbox_top;
		
		if sign(image_xscale) == -1
		{
			left = bbox_right;
			right = bbox_left;
		}
		
		if object_index == obj_fuckedupslope
		{
			return place_meeting(x, y, other);
		}
		else if object_index == obj_convexslope
		{
			right += sprite_width;
			bottom += sprite_height;
			return collision_ellipse(left, top, right, bottom, other, true, false);
		}
		else
		{
			return rectangle_in_triangle(other.bbox_left, other.bbox_top, other.bbox_right, other.bbox_bottom,
				left, bottom, right, bottom, right, top);
		}
	}
	return false;
}
function check_slope_at(_x, _y)
{
	var old_x = x;
	var old_y = y;
	x = _x;
	y = _y;
	
	if check_slope(obj_slope)
	{
		x = old_x;
		y = old_y;
		return true;
	}
	
	x = old_x;
	y = old_y;
	return false;
}
function scr_solid_slope(_x, _y)
{
	var old_x = x;
	var old_y = y;
	x = _x;
	y = _y;
	if (check_slope(obj_slope))
	{
		var inst = instance_place(x, y, obj_slope);
		if (sign(inst.image_xscale) != xscale)
		{
			x = old_x;
			y = old_y;
			return true;
		}
	}
	x = old_x;
	y = old_y;
	return false;
}
function scr_solid_player(_x, _y)
{
	var old_x = x;
	var old_y = y;
	x = _x;
	y = _y;
	
	ds_list_clear(global.instancelist);
	var num = instance_place_list(x, y, obj_solid, global.instancelist, false);
	var _collided = false;
	for (var i = 0; i < num; i++)
	{
		var b = ds_list_find_value(global.instancelist, i);
		if (instance_exists(b))
		{
			switch (b.object_index)
			{
				default:
					_collided = true;
			}
		}
		if (_collided)
			break;
	}
	ds_list_clear(global.instancelist);
	
	if (_collided)
	{
		x = old_x;
		y = old_y;
		return true;
	}
	
	if (y > old_y/* && state != states.ladder*/ && place_meeting(x, y, obj_platform))
	{
		num = instance_place_list(x, y, obj_platform, global.instancelist, false);
		_collided = false;
		for (i = 0; i < num; i++)
		{
			b = ds_list_find_value(global.instancelist, i);
			if (!place_meeting(x, old_y, b) && place_meeting(x, y, b))
				_collided = true;
		}
		ds_list_clear(global.instancelist);
		if (_collided)
		{
			x = old_x;
			y = old_y;
			return true;
		}
	}
	
	/*
	if (y > old_y && state == states.grind && !place_meeting(x, old_y, obj_grindrail) && place_meeting(x, y, obj_grindrail))
	{
		x = old_x;
		y = old_y;
		return true;
	}
	*/
	
	if (check_slope(obj_slope))
	{
		x = old_x;
		y = old_y;
		return true;
	}
	
	/*
	if (state == states.grind && check_slope(obj_grindrailslope))
	{
		x = old_x;
		y = old_y;
		return true;
	}
	*/
	
	x = old_x;
	y = old_y;
	return false;
}
