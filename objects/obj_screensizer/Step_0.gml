var cr = cr_default;
if (device_mouse_x_to_gui(0) != mouse_xprevious || device_mouse_y_to_gui(0) != mouse_yprevious) && gameframe_mouse_in_window()
{
    disappearbuffer = 100;
    mouse_xprevious = device_mouse_x_to_gui(0);
    mouse_yprevious = device_mouse_y_to_gui(0);
}
if disappearbuffer > 0
{
    captionalpha = Approach(captionalpha, 1, 0.2);
    disappearbuffer--;
}
else
    captionalpha = Approach(captionalpha, 0, 0.1);

window_set_cursor(cr);
gameframe_current_cursor = cr;
gameframe_alpha = captionalpha;
gameframe_set_cursor = cr != cr_none;
gameframe_update();

display_set_gui_size(SCREEN_WIDTH, SCREEN_HEIGHT);

if keyboard_check(vk_control) && keyboard_check_pressed(ord("R"))
	game_restart();
