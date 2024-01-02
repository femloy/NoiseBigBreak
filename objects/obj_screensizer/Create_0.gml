#macro SCREEN_WIDTH 1280
#macro SCREEN_HEIGHT 720

gameframe_init();
gameframe_caption_font = fnt_caption;
gameframe_caption_icon = spr_ico;
gameframe_caption_icon_margin = 6;
gameframe_border_width = 2;

mouse_xprevious = mouse_x;
mouse_yprevious = mouse_y;
captionalpha = 0;
disappearbuffer = 0;
depth = -9999;
