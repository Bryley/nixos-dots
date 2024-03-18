
const hyprland = await Service.import("hyprland");

const Workspaces = () => {
    return Widget.Box({
        className: "workspace",
        children: Array(10).fill(false).map((_, i) => Widget.Label({
            // label: `${i}`,
            vpack: "center",
            setup: self => self.hook(hyprland, () => {
                self.toggleClassName("active", hyprland.active.workspace.id === i + 1)
                self.toggleClassName("occupied", (hyprland.getWorkspace(i + 1)?.windows || 0) > 0)
            }),
        })),
    })
};

export default Workspaces;
