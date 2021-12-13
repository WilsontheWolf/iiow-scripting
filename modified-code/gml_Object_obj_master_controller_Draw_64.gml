draw_gui_init()
if global.settingsValue[5]
{
    draw_text_formatting(c_white, fa_left, fa_middle, font_small)
    draw_set_alpha(0.4)
    draw_text(16, 32, ("fps:" + string(fps)))
    draw_text(16, 48, ("fps real: " + string(round(fps_real))))
    draw_text(16, 64, ("inst count: " + string(instance_number(all))))
    var mx = gui_mouse_x()
    var my = gui_mouse_y()
    draw_set_color(c_red)
    if (mouseDragX == -1 && mouseDragY == -1)
        draw_text((gui_mouse_x() - 2), (gui_mouse_y() - 8), ((string(mx) + ", ") + string(my)))
    else
    {
        draw_circle(mouseDragX, mouseDragY, 2, 0)
        draw_line(mouseDragX, mouseDragY, mx, my)
        draw_text((gui_mouse_x() - 2), (gui_mouse_y() - 8), ((string((mx - mouseDragX)) + ", ") + string((my - mouseDragY))))
    }
    draw_set_alpha(1)
}
draw_text_formatting(c_black, fa_center, fa_middle, font_large)
switch global.loadMode
{
    case "settings":
        draw_text_transformed((global.displayWidth / 2), (global.displayHeight / 2), "loading settings", wave(2, 2.5, 3, 0), wave(2, 2.5, 3, 0), 0)
        break
    case "audio":
        draw_text_transformed((global.displayWidth / 2), (global.displayHeight / 2), "loading audio", wave(2, 2.5, 3, 0), wave(2, 2.5, 3, 0), 0)
        break
    case "data":
        draw_text_transformed((global.displayWidth / 2), (global.displayHeight / 2), "loading data", wave(2, 2.5, 3, 0), wave(2, 2.5, 3, 0), 0)
        break
    case "hax":
        draw_text_transformed((global.displayWidth / 2), (global.displayHeight / 2), "Hacking in progress...", 1, 1, 0)
        break
}

if global.consoleVisible
{
    draw_sprite_ext(spr_gui_console, 0, consolePosX, consolePosY, 1, 1, 0, c_white, 0.99)
    draw_text_formatting(c_silver, fa_left, fa_top, font_console)
    var drawPos = 0
    for (var i = consoleOffset; i < min((consoleLength + 1), (consoleOffset + consoleLineMax)); i++)
    {
        var drawText = (((i == (consoleLength - consoleBufferLines) ? consoleInputPrefix : "") + (i > (consoleLength - consoleBufferLines) ? consoleInputTab : "")) + console[i])
        draw_set_color(c_silver)
        if (string_pos(consoleInputPrefix, drawText) == 1 || string_pos(consoleInputTab, drawText) == 1)
            draw_set_color(c_white)
        else if (string_pos("DEBUG: ", drawText) == 1)
            draw_set_color(make_color_rgb(110, 150, 220))
        else if (string_pos("ERROR: ", drawText) == 1)
            draw_set_color(make_color_rgb(234, 53, 15))
        else if (string_pos("WARNING: ", drawText) == 1)
            draw_set_color(make_color_rgb(255, 141, 0))
        else if (string_pos("SERVER: ", drawText) == 1)
            draw_set_color(make_color_rgb(0, 255, 0))
        draw_text((consolePosX + 8), ((consolePosY + 8) + (drawPos * consoleLineHeight)), drawText)
        drawPos++
    }
    if (alarm[2] > 30)
    {
        draw_set_color(c_white)
        var drawX = ((consolePosX + 8) + string_width((((consoleCursorLine == (consoleLength - consoleBufferLines) ? consoleInputPrefix : "") + (consoleCursorLine > (consoleLength - consoleBufferLines) ? consoleInputTab : "")) + string_copy(console[consoleCursorLine], 0, consoleCursorPosition))))
        var drawY = ((consolePosY + 16) + ((consoleCursorLine - consoleOffset) * consoleLineHeight))
        if (drawY < (consolePosY + consoleHeight))
        {
            var lineHeight = (consoleLineHeight / 2.5)
            draw_line(drawX, (drawY - lineHeight), drawX, (drawY + lineHeight))
        }
    }
    draw_set_color(c_white)
    draw_set_alpha(0.2)
    draw_line_width(consoleScrollPosX, consoleScrollPosY, consoleScrollPosX, (consoleScrollPosY + consoleScrollPosHeight), 2)
    draw_set_alpha(1)
    draw_sprite(spr_gui_scroll_button, 0, consoleScrollPosX, (consoleScrollPosY + (consoleOffsetMax != 0 ? (consoleScrollPosHeight * (consoleOffset / consoleOffsetMax)) : 0)))
}
if (global.pause && instance_number(par_ui_pauseable) == 0)
{
    draw_set_alpha(0.2)
    draw_set_color(c_black)
    draw_rectangle(0, 0, global.displayWidth, global.displayHeight, false)
    draw_set_alpha(1)
    draw_text_formatting(c_white, fa_center, fa_middle, font_large)
    draw_text_transformed((global.displayWidth / 2), ((global.displayHeight / 2) - 128), "paused", 4, 4, 0)
    for (i = 0; i < global.pauseAmount; i++)
        draw_text_transformed((global.displayWidth / 2), ((global.displayHeight / 2) + (i * 64)), global.pauseText[i], (1 + global.pauseHover[i]), (1 + global.pauseHover[i]), 0)
}
if (global.gifRecording != undefined && alarm[5] != 1)
{
    draw_set_alpha(0.5)
    draw_set_color(c_red)
    for (i = 0; i < 4; i++)
        draw_rectangle(i, i, ((global.displayWidth - i) - 1), ((global.displayHeight - i) - 1), true)
    draw_set_alpha(1)
}
draw_text_formatting(c_white, fa_left, fa_middle, font_medium)
draw_set_alpha(0.25)
draw_text(16, (global.displayHeight - 16), ((0 ? "DEV BUILD " : "beta ") + string(9)))
draw_set_alpha(1)
draw_gui_end()
