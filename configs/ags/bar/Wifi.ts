const network = await Service.import('network');

const WifiIndicator = () => Widget.Box({
    children: [
        // Widget.Icon({
        //     icon: network.wifi.bind('icon_name'),
        // }),
        Widget.Label({
            label: network.wifi.bind('ssid')
                .as(ssid => ssid || 'Unknown'),
        }),
    ],
});

// TODO icons

// const WiredIndicator = () => Widget.Icon({
//     icon: network.wired.bind('icon_name'),
// });
const WiredIndicator = () => Widget.Label({
    label: "Wired",
});

const NetworkIndicator = () => Widget.Stack({
    items: [
        ['wifi', WifiIndicator()],
        ['wired', WiredIndicator()],
    ],
    shown: network.bind('primary').as(p => p || 'wifi'),
});

export default NetworkIndicator;
