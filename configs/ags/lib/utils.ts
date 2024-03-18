


/**
 * Executes command via bash
 */
export async function bash2(cmd: string | string[]): Promise<string> {
    cmd = ["bash", "-c", (typeof cmd === "string" ? cmd : cmd.join(' '))];
    return await sh(cmd);

    return Utils.execAsync(cmd).catch(err => {
        console.error(typeof cmd === "string" ? cmd : cmd.join(" "), err);
        return "";
    });
}

export async function bash(strings: TemplateStringsArray | string, ...values: unknown[]) {
    const cmd = typeof strings === "string" ? strings : strings
        .flatMap((str, i) => str + `${values[i] ?? ""}`)
        .join("")

    return Utils.execAsync(["bash", "-c", cmd]).catch(err => {
        console.error(cmd, err)
        return ""
    })
}


/**
 * Executes command via sh
 */
export async function sh(cmd: string | string[]): Promise<string> {
    return Utils.execAsync(cmd).catch(err => {
        console.error(typeof cmd === "string" ? cmd : cmd.join(" "), err);
        return "";
    });
}
