// make function mp_game_loop;

if (room == rm_load) return;

timer ++;

if timer mod 60 == 0 {
    var resp = ds_map_create();
    ds_map_add(resp, "type", "game_state"); 

    var state = "unkown";
    if (instance_exists(obj_build_controller)) state = "build";
    else if(instance_exists(obj_menu_controller)) state = "menu";
    else if (instance_exists(obj_game_controller)) state = "game";
    ds_map_add(resp, "state", "game");

    if(state == "game") {
        ds_map_add(resp, "player_x", global.player.x);
        ds_map_add(resp, "player_y", global.player.y);
        ds_map_add(resp, "player_spd_x", global.player.spdX);
        ds_map_add(resp, "player_spd_y", global.player.spdY);
        ds_map_add(resp, "player_schematic", schematic_to_string(global.playerSchematic, 0, 1));
    }
    send_string(json_encode(resp));
    ds_map_destroy(resp);
}