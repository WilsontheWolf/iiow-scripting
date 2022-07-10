const fs = require('fs/promises');
const path = require('path');

(async () => {
    const files = await fs.readdir('./expressionRuntime/');
    const filesToConvert = files.filter(file => !file.includes('.'));
    await fs.rm('./import-me/', { recursive: true }).catch(() => { });
    await fs.mkdir('./import-me/');
    const macros = [];
    const filesToConvertPromises = filesToConvert.map(async file => {
        const filePath = path.join('./expressionRuntime/', file, `${file}.gml`);
        let contents = await fs.readFile(filePath, 'utf8');
        contents = contents.replace(/([\w\.]+)\[\|((?:\[\w+?\]|[^\]\[])+?)\](?!\s+=\s)/g, 'ds_list_find_value($1, $2)');
        contents = contents.replace(/([\w\.]+)\[\|((?:\[\w+?\]|[^\]\[])+?)\](?:\s+=\s)(.+);/g, 'ds_list_set($1, $2, $3);');
        contents = contents.replace(/([\w\.]+)\[\?((?:\[\w+?\]|[^\]\[])+?)\](?!\s+=\s)/g, 'ds_map_find_value($1, $2)');
        contents = contents.replace(/([\w\.]+)\[\?((?:\[\w+?\]|[^\]\[])+?)\](?:\s+=\s)(.+);/g, 'ds_map_set($1, $2, $3);');
        // Large chance this breaks something
        contents = contents.replace(/\[@((?:\[.+?\]|[^\]\[])+?)\]/g, '[$1]');
        const newPath = path.join('./import-me/', `gml_Script_${file}.gml`);

        contents = contents.replace(/#macro (\S+)\s+(\S+)\r?\n/g, (match, macroName, macroContents) => {
            macros.push({
                name: macroName,
                contents: macroContents
            });
            return '';
        });

        return [contents, newPath];
    });
    let newFiles = await Promise.all(filesToConvertPromises);

    // Macros
    const macroRegex = macros.map(({ name }) => name.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')).join('|');

    newFiles = newFiles.map(([contents, newPath]) => {
        contents = contents.replace(new RegExp(`\\b(${macroRegex})\\b`, 'g'), (match, macroName) => {
            const macro = macros.find(({ name }) => name === macroName);
            return macro.contents;
        });
        return [contents, newPath];
    });

    // Write files
    await Promise.all(newFiles.map(([contents, newPath]) => fs.writeFile(newPath, contents)));

})();
