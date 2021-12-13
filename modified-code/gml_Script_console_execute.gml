var input = (argument0 + " ")
if (string_pos("!", input) == 1)
{
    input = string_replace_all(input, "\"", "'")
    return NSP_execute_string(string_delete(input, 1, 1));
}
else if (string_pos("?", input) == 1)
{
    input = string_replace_all(input, "\"", "'")
    return NSP_evaluate(string_delete(input, 1, 1));
}
input = string_lower(input)
var argumentMap = ds_map_create()
var command = ""
var mode = "command"
var buffer = ""
var bufferKey = ""
var bufferValue = ""
if (string_pos("?", input) == (string_length(input) - 1))
{
    input = string_delete(input, (string_length(input) - 1), 1)
    ds_map_add(argumentMap, "help", "")
}
for (var i = 1; i <= string_length(input); i++)
{
    var char = string_char_at(input, i)
    switch char
    {
        case " ":
            switch mode
            {
                case "command":
                    command = buffer
                    buffer = ""
                    break
                case "value":
                    bufferValue = buffer
                    buffer = ""
                    if (bufferKey != "" && bufferValue != "")
                    {
                        if (string_char_at(bufferValue, 1) == "\\")
                        {
                            var assetCheck = string_delete(bufferValue, 1, 1)
                            if (asset_get_type(assetCheck) != -1)
                                bufferValue = asset_get_index(assetCheck)
                            else
                                return (("ERROR: value of <" + bufferKey) + "> is not a valid asset");
                        }
                        if (realify(bufferValue) != 0 || bufferValue == "0")
                            bufferValue = realify(bufferValue)
                        ds_map_add(argumentMap, bufferKey, bufferValue)
                        bufferKey = ""
                        bufferValue = ""
                    }
                    break
                case "key":
                    ds_map_add(argumentMap, buffer, "")
                    buffer = ""
                    break
            }

            mode = "key"
            break
        case ":":
        case "=":
            if (mode == "key")
            {
                bufferKey = buffer
                buffer = ""
            }
            mode = "value"
            break
        default:
            buffer += char
    }

}
if (asset_get_type(("cc_" + command)) != 6)
{
    ds_map_destroy(argumentMap)
    return "invalid command";
}
var returned = script_execute(asset_get_index(("cc_" + command)), argumentMap)
ds_map_destroy(argumentMap)
return returned;
