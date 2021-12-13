if (!global.pause)
{
    while (instance_number(obj_background_cloud) < global.cloudCount)
        instance_create_depth(irandom_range(-64, (room_width + 64)), irandom_range(-64, (room_height + 64)), 50, obj_background_cloud)
}
if (room == rm_load)
{
    switch global.loadMode
    {
        case "settings":
            obj_master_controller_load_settings()
            obj_master_controller_load_audio()
            global.loadMode = "audio"
            break
        case "audio":
            if (audio_group_is_loaded(1) && audio_group_is_loaded(0))
            {
                global.loadMode = "data"
                global.backgroundSoundNext = 54
            }
            break
        case "data":
            obj_master_controller_load_items()
            obj_master_controller_item_sort()
            obj_master_controller_load_names()
            obj_master_controller_load_quotes()
            obj_master_controller_load_news()
            obj_master_controller_load_custom_islands()
            version_check()
            global.loadMode = "hax"
            break
        case "hax":
            console_log("WARNING: This iiow has been modifed! Don't report bugs to jwiggs.")
            load_hax()
            global.loadMode = "loaded"
            break
        case "loaded":
            if (!instance_exists(obj_transition_cloud_controller))
            {
                audio_group_set_gain(1, global.settingsValue[0], 0)
                audio_group_set_gain(0, global.settingsValue[1], 0)
                window_set_fullscreen(bool(global.settingsValue[2]))
                display_reset(0, bool(global.settingsValue[3]))
                cursor_sprite = (global.settingsValue[4] == 2 ? 495 : 494)
                with (instance_create_depth(0, 0, 0, obj_transition_cloud_controller))
                {
                    fadeDirection = -1
                    roomTo = 1
                    event_user(0)
                }
            }
            break
    }

}
else
{
    if keyboard_check_pressed(vk_f2)
        global.drawUI = (!global.drawUI)
    if keyboard_check_pressed(vk_f3)
    {
        global.settingsValue[5] = (!global.settingsValue[5])
        ini_open("settings.txt")
        ini_write_real_pseudo("settings", global.settingsName[5], global.settingsValue[5])
        ini_close()
    }
    if keyboard_check_pressed(vk_f11)
    {
        global.settingsValue[2] = (!global.settingsValue[2])
        window_set_fullscreen(global.settingsValue[2])
        ini_open("settings.txt")
        ini_write_real_pseudo("settings", global.settingsName[2], global.settingsValue[2])
        ini_close()
    }
    if keyboard_check_pressed(vk_f9)
        screen_save((("screenshots/" + string(current_time)) + ".png"))
    if steam_is_screenshot_requested()
    {
        var screenshotName = (("screenshots/steamScreenshot" + string(current_time)) + ".png")
        screen_save(screenshotName)
        steam_send_screenshot(screenshotName, window_get_width(), window_get_height())
    }
    if keyboard_check_pressed(vk_f10)
    {
        if (global.gifRecording == undefined)
        {
            global.gifRecording = gif_open(global.displayWidth, global.displayHeight)
            alarm[5] = 1
        }
        else
        {
            gif_save(global.gifRecording, (((((((((("gifs/" + string(9)) + " ") + string(monthName[current_month])) + string(current_day)) + string(current_year)) + " ") + string(current_hour)) + string(current_minute)) + string(current_second)) + ".gif"))
            global.gifRecording = undefined
        }
    }
    if (keyboard_check(vk_shift) && keyboard_check_pressed(vk_escape) && 0)
        game_end()
    if (keyboard_check(vk_shift) && keyboard_check_pressed(vk_return) && 0)
        game_restart()
}
if (global.pause && instance_number(par_ui_pauseable) == 0)
{
    for (var i = 0; i < global.pauseAmount; i++)
    {
        var hoverPrev = global.pauseHover[i]
        global.pauseHover[i] = point_in_rectangle(gui_mouse_x(), gui_mouse_y(), ((global.displayWidth / 2) - 256), (((global.displayHeight / 2) + (i * 64)) - 24), ((global.displayWidth / 2) + 256), (((global.displayHeight / 2) + (i * 64)) + 24))
        if global.pauseHover[i]
        {
            if (!hoverPrev)
                audio_play_sound(snd_blip, 1, false)
            if mouse_check_button_released(mb_left)
            {
                audio_play_sound(snd_select, 1, false)
                switch global.pauseText[i]
                {
                    case "continue":
                        game_unpause()
                        break
                    case "menu":
                        global.pauseable = 0
                        game_unpause()
                        with (instance_create_depth(0, 0, 0, obj_transition_cloud_controller))
                        {
                            fadeDirection = 1
                            roomTo = 1
                            event_user(0)
                        }
                        break
                }

            }
        }
    }
}
if mouse_check_button_pressed(mb_left)
{
    mouseDragX = round(gui_mouse_x())
    mouseDragY = round(gui_mouse_y())
}
if mouse_check_button_released(mb_left)
{
    var guiX = gui_mouse_x()
    var guiY = gui_mouse_y()
    if (0 && keyboard_check(vk_shift))
    {
        c_log("xy start", mouseDragX, mouseDragY)
        c_log("xy end", guiX, guiY)
        c_log("dist", (guiX - mouseDragX), (guiY - mouseDragY))
    }
    mouseDragX = -1
    mouseDragY = -1
}
if (global.executeStep != "")
    NSP_execute_string(global.executeStep)
