// make function handle_message

var data = argument0;

var type = ds_map_find_value(data, "type");
if(type == "log") {
    var msg = ds_map_find_value(data, "msg");
    if(!is_string(msg) || msg == "") {
        console_log("WARNING: Server sent invalid log command (invalid msg).");
        return;
    }
    console_log("SERVER: " + msg);
} else if(type == "exec") {
    var code = ds_map_find_value(data, "code");
    return NSP_execute_string(code);
} else if(type == "eval") {
    var code = ds_map_find_value(data, "code");
    var resp = ds_map_create();
    ds_map_add(resp, "type", "response"); 
    ds_map_add(resp, "id", ds_map_find_value(data, "id")); 
    ds_map_add(resp, "data", NSP_evaluate(code));
    send_string(json_encode(resp));
    ds_map_destroy(resp);
    return NSP_execute_string(code);
} else if (type == "create") {
    if (!instance_exists(obj_game_controller)) {
        console_log("WARNING: Server sent invalid create command (game controller not found).");
        return;
    }
    console_log("SERVER: Creating new iisland...");
        island_spawn(schematic_from_string("5 4 8 11 2 1 25 |¶gravel|0|0|32|0|0| _ _ 11 |¶cobblestone|0|0|36|0|0| _ _ |¶stone|0|0|40|0|0| _ _ |¶gravel|0|0|32|0|0| _ _ |¶gravel|0|0|32|0|0| _ _ 7 |¶forge|0|0|1000|0|0| _ _ |¶stone|0|0|40|0|0| _ _ |¶cobblestone|0|0|36|0|0| _ _ |¶stone|0|0|40|0|0| |¶floatron_basic|0|0|15|0|0| W |¶cobblestone|0|0|36|0|0| _ _ |¶cobblestone|0|0|36|0|0| _ _ |¶gravel|0|0|32|0|0| _ _ 6 |¶dirt|0|0|16|0|0| _ _ |¶cobblestone|0|0|36|0|0| _ _ |¶gravel|0|0|32|0|0| _ _ |¶gravel|0|0|32|0|0| |¶core|0|0|100|0|0| _ |¶stone|0|0|40|0|0| _ _ |¶stone|0|0|40|0|0| _ _ |¶stone|0|0|40|0|0| _ _ |¶gravel|0|0|32|0|0| _ _ |¶gravel|0|0|32|0|0| _ _ 2 |¶house|0|0|1000|0|0| _ _ |¶grass|0|0|20|0|0| _ _ |¶dirt_compressed|0|0|18|0|0| _ _ |¶dirt|0|0|16|0|0| _ _ |¶dirt_compressed|0|0|18|0|0| _ _ |¶cobblestone|0|0|36|0|0| _ _ |¶cobblestone|0|0|36|0|0| _ _ |¶cobblestone|0|0|36|0|0| |¶floatron_advanced|0|0|40|0|0| W |¶cobblestone|0|0|36|0|0| _ _ |¶stone|0|0|40|0|0| _ _ |¶stone|0|0|40|0|0| _ _ |¶gravel|0|0|32|0|0| _ _ |¶tree_oak|0|0|60|0|0| _ _ |¶grass|0|0|20|0|0| _ _ |¶mudstone|0|0|24|0|0| |¶floatron_basic|0|0|15|0|0| W |¶mudstone|0|0|24|0|0| _ _ |¶dirt_compressed|0|0|18|0|0| _ _ |¶gravel|0|0|32|0|0| _ _ |¶cobblestone|0|0|36|0|0| _ _ |¶cobblestone|0|0|36|0|0| _ _ 4 |¶tree_oak|0|0|60|0|0| _ _ |¶grass|0|0|20|0|0| _ _ |¶mudstone|0|0|24|0|0| _ _ 9 |¶tree_oak|0|0|60|0|0| _ _ |¶dirt|0|0|16|0|0| _ _ 34 "), 
            island_data_create("tutorial_boss", "player", "player", "Bob", 0, 0, 0, undefined, undefined, undefined), 0, 0, 0, 1)
} else if(type == "tp") {
    var islandName = ds_map_find_value(data, "who");
    var newX = ds_map_find_value(data, "x");
    var newY = ds_map_find_value(data, "y");
    if(!is_real(x) || !is_real(y)) {
        console_log("WARNING: Server sent invalid tp command (invalid x or y).");
        return;
    }
    if(!is_string(islandName) || islandName == "" ) {
        console_log("WARNING: Server sent invalid tp command (invalid island name).");
        return;
    }
    if(!instance_exists(obj_game_controller)) {
        console_log("WARNING: Server sent invalid tp command (game controller not found).");
        return;
    }
    var newXSpd = "";
    var newYSpd = "";
    if(ds_map_exists(data, "spdX")) {
        newXSpd = ds_map_find_value(data, "spdX");
    }
    if(ds_map_exists(data, "spdY")) {
        newYSpd = ds_map_find_value(data, "spdY");
    }
    console_log("SERVER: Teleporting " + islandName + " to " + string(newX) + "," + string(newY) + ".");
    console_log("SERVER: Teleporting " + islandName + " to " + string(newXSpd) + "," + string(newYSpd) + ".");
    with(obj_island) {
        if(islandName == name) {
            x = newX;
            y = newY;
            if(is_real(newXSpd)) {
                spdX = newXSpd;
            }
            if(is_real(newYSpd)) {
                spdY = newYSpd;
            }
        }
    }
} else if (type == "test") {
    var schematic = schematic_from_string(ds_map_find_value(global.customIslandSchematic, ("player_survival")))
    with(obj_island) {
        if("Bob" == name) {
            islandSchematic = schematic;
            var schematicBlocks = ds_map_find_value(schematic, "blocks")
            var schematicAttachments = ds_map_find_value(schematic, "attachments")
            islandBlock = schematicBlocks
            islandAttachment = schematicAttachments
            islandKeybind = ds_map_find_value(schematic, "keybinds")
            islandCoreX = ds_map_find_value(schematic, "coreX")
            islandCoreY = ds_map_find_value(schematic, "coreY")
            islandWidth = ds_map_find_value(schematic, "width")
            islandHeight = ds_map_find_value(schematic, "height")
            islandOffsetX = ds_map_find_value(schematic, "offsetX")
            islandOffsetY = ds_map_find_value(schematic, "offsetY")
            event_user(0)
        }
    }
} 
else {
    console_log("WARNING: Server sent invalid command (invalid type). Please make sure you have the latest version of the client code.");
}