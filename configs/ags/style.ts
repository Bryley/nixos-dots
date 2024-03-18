import { bash, sh } from "lib/utils";
import { FileMonitorEvent } from "types/@girs/gio-2.0/gio-2.0.cjs";


const theme = {
    "backdrop": "#2b2b2b",
    "foreground": "#d6d6d6",
    "backdrop-light": "#424242",
    "backdrop-dark": "#303030",
    "success": "#4FA61C",
    "error": "#A82D2D",
}

async function findScssFiles(): Promise<string[]> {
    return (await sh(`fd ".scss" ${App.configDir}`)).split(/\s+/);
}

export async function updateCss() {
    const scssFiles = await findScssFiles();
    const varsFile = `${TMP}/vars.scss`;
    const vars = Object.entries(theme).map(([key, value]) => `$${key}: ${value};`).join("\n");
    await Utils.writeFile(vars, varsFile);

    let contents = [varsFile, ...scssFiles].map(file => `@import '${file}'`).join("\n");
    contents = await bash`echo "${contents}" | sass --stdin -I /`;

    const output = `${TMP}/style.css`;

    await Utils.writeFile(contents, output);

    App.resetCss();
    App.applyCss(output);
    console.log("Reloaded CSS");
}


export async function autoreloadCss() {
    const scssFiles = await findScssFiles();

    for (const file of scssFiles) {
        console.log(file);
        Utils.monitorFile(
            file,
            (_, event) => {
                // Only update once if the file changes
                if (event === FileMonitorEvent.CHANGED) {
                    updateCss();
                }
            },
        );
    }
}

