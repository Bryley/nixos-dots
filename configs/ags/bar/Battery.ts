import Button from "lib/comps/Button";

const battery = await Service.import('battery');

const Level = () => {
    const lev = Widget.LevelBar({
        mode: 1,
        maxValue: 10,
        value: battery.bind('percent').as(p => p / 10),
    });
    const update = () => {
        lev.toggleClassName("low", battery.percent <= 20);
    };
    update();
    return lev.hook(battery, update);
}

const Battery = () => Button(Widget.Box({
    className: "w-battery",
    spacing: 3,
    children: [
        Widget.Label({ label: battery.bind("percent").as(v => `${v}%`) }),
        Level(),
    ],
}));

export default Battery;
