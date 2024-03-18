
const entry = App.configDir + '/main.ts'
const outdir = '/tmp/ags/js'

try {
    await Utils.execAsync([
        'bun', 'build', entry,
        '--outdir', outdir,
        '--external', 'resource://*',
        '--external', 'gi://*',
    ])
} catch (error) {
    console.error(error)
}

const main = await import(`file://${outdir}/main.js`)

export default main.default


//
// const time = Variable('', {
//     poll: [1000, function() {
//         return Date().toString()
//     }],
// })
//
// const Bar = (/** @type {number} */ monitor) => Widget.Window({
//     monitor,
//     name: `bar${monitor}`,
//     anchor: ['top', 'left', 'right'],
//     exclusivity: 'exclusive',
//     child: Widget.CenterBox({
//         start_widget: Widget.Label({
//             hpack: 'center',
//             label: 'Welcome to AGS!',
//         }),
//         end_widget: Widget.Label({
//             hpack: 'center',
//             label: time.bind(),
//         }),
//     }),
// })
//
// export default {
//     windows: [Bar(0)],
// }
