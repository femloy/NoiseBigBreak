function Approach(a, b, amount)
{
	// https://www.youtube.com/watch?v=2FroAhEsuE8
	if (a < b)
	{
		a += amount;
		if (a > b)
			return b;
	}
	else
	{
		a -= amount;
		if (a < b)
			return b;
	}
	return a;
}
function try_solid(xoffset, yoffset, object, iterations)
{
	var old_x = x;
	var old_y = y;
	var n = -1;
	for (var i = 0; i < iterations; i++)
	{
		x += xoffset;
		y += yoffset;
		if (!scr_solid(x, y))
		{
			n = i + 1;
			break;
		}
	}
	x = old_x;
	y = old_y;
	return n;
}
function ledge_bump(iterations)
{
	var old_x = x;
	var old_y = y;
	x += (xscale * 4);
	var ty = try_solid(0, -1, obj_solid, iterations);
	x = old_x;
	if (ty != -1)
	{
		y -= ty;
		x += xscale;
		if (scr_solid(x, y))
		{
			x = old_x;
			y = old_y;
			return true;
		}
		return false;
	}
	return true;
}
function trace()
{
	var _string = "";
	for (var i = 0; i < argument_count; i++)
		_string += string(argument[i]);
	show_debug_message(_string);
}
function concat()
{
	var _string = "";
	for (var i = 0; i < argument_count; i++)
		_string += string(argument[i]);
	return _string;
}
function instance_create(x, y, obj, var_struct = {})
{
	return instance_create_depth(x, y, 0, obj, var_struct);
}