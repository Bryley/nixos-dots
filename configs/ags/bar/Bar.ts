import Battery from "./Battery";
import DateWidget from "./DateWidget";
import NetworkIndicator from "./Wifi";
import Workspaces from "./Workspaces";

const Bar = (monitor: number) => Widget.Window({
    name: `bar-${monitor}`,
    exclusivity: 'exclusive',
    anchor: ["top", "left", "right"],
    child: Widget.CenterBox({
        startWidget: BarLeft(),
        centerWidget: BarCenter(),
        endWidget: BarRight(),
    }),
});

const lab = () => Widget.Label({
    css: "font-size: 10px",
    label: "TODO",
});

const BarLeft = () => Widget.Box({
    hpack: "start",
    spacing: 8,
    children: [
        Workspaces(),
    ],
});

const BarCenter = () => Widget.Box({
    spacing: 8,
    children: [
        DateWidget(),
    ],
});

const BarRight = () => Widget.Box({
    hpack: "end",
    spacing: 8,
    children: [
        NetworkIndicator(),
        Battery(),
    ],
});

export default Bar;
