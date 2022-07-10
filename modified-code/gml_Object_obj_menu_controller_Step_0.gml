global.cameraX = (global.displayWidth / 2)
global.cameraY = (global.displayHeight / 2)
image_xscale = (min(((global.displayWidth - 384) - 128), (global.displayHeight - 32)) / 256)
image_yscale = image_xscale
x = ((global.displayWidth - 384) / 2)
y = round(((global.displayHeight / 2) + (wave(-2, 2, 5, 0) * image_xscale)))
if global.consoleVisible
    return;
text = menuText
amount = menuAmount
for (var i = 0; i < amount; i++)
{
    var hoverPrev = menuHover[i]
    menuHover[i] = point_in_rectangle(gui_mouse_x(), gui_mouse_y(), (global.displayWidth - 320), ((((64 + (global.displayHeight / 2)) - (40 * menuAmount)) + (i * 80)) - 36), global.displayWidth, ((((64 + (global.displayHeight / 2)) - (40 * menuAmount)) + (i * 80)) + 36))
    if menuHover[i]
    {
        if (!hoverPrev)
            audio_play_sound(snd_blip, 1, false)
        if (mouse_check_button_pressed(mb_left) || mouse_check_button_pressed(mb_right))
            audio_play_sound(snd_select, 1, false)
        switch text[i]
        {
            case "continue":
                if mouse_check_button_pressed(mb_left)
                {
                    global.gameMode = "continue"
                    event_user(0)
                }
                break
            case "test":
                if mouse_check_button_pressed(mb_left)
                {
                    global.gameMode = "multiplayer"
                    event_user(0)
                }
                break
            case "new game":
                if mouse_check_button(mb_left)
                {
                    newGameTime += 6
                    global.gameMode = "survival"
                    newGameText = "new survival game"
                    if (newGameTime >= newGameMax)
                        event_user(0)
                }
                else if mouse_check_button(mb_right)
                {
                    newGameTime += 6
                    global.gameMode = "sandbox"
                    newGameText = "new sandbox game"
                    if (newGameTime >= newGameMax)
                        event_user(0)
                }
                break
            case "tutorial":
                if mouse_check_button_pressed(mb_left)
                {
                    global.gameMode = "tutorial"
                    event_user(0)
                }
                break
            case "news":
                if mouse_check_button_pressed(mb_left)
                {
                    if instance_exists(obj_news_controller)
                    {
                        screen = "menu"
                        instance_destroy(obj_news_controller)
                    }
                    else
                    {
                        screen = "news"
                        instance_create_depth(x, y, (depth - 1), obj_news_controller)
                    }
                }
                break
            case "discord":
                if mouse_check_button_pressed(mb_left)
                    steam_activate_overlay_browser("https://discord.gg/c3NQd47")
                break
            case "settings":
                if mouse_check_button_pressed(mb_left)
                {
                    if instance_exists(obj_settings_controller)
                    {
                        screen = "menu"
                        instance_destroy(obj_settings_controller)
                    }
                    else
                    {
                        screen = "settings"
                        instance_create_depth(x, y, (depth - 1), obj_settings_controller)
                    }
                }
                break
            case "quit":
                if mouse_check_button_pressed(mb_left)
                    game_end()
                break
        }

    }
}
newGameTime = clamp((newGameTime - 5), 0, newGameMax)
image_alpha = 1
