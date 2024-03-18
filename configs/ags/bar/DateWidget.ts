import Button from "lib/comps/Button";


const date = Variable('', {
    poll: [1000, 'date +"%-I:%M %P"'],
});

const DateWidget = () => Button(
    Widget.Label({ label: date.bind() }),
);

export default DateWidget;
