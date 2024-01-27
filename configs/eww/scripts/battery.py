#! /usr/bin/env python3

"""
Quick and dirty python script to get the battery of the system in a pretty
string used for the ewww bar
"""

from pathlib import Path

BATTERY_ICONS = [" ", " ", " ", " ", " "]
CHARGING_ICON = "󱐋"

BATTERY_PATH = Path("/sys/class/power_supply/BAT1")

def file_read(file_name: str) -> str:
    try:
        with open(BATTERY_PATH / file_name, "r") as file:
            return file.read().strip()
    except (IOError, FileNotFoundError):
        return ""

def get_icon(level: int) -> str:
    jump = 100 / len(BATTERY_ICONS)

    # Cap value at len - 1 so there is no overflow since 100 // (100 / l) > l
    index = min(len(BATTERY_ICONS) - 1, int(level // jump))
    return BATTERY_ICONS[index]

def main():
    if not BATTERY_PATH.exists():
        return

    cap = file_read("capacity")
    is_charging = file_read("status") == "Charging"

    try:
        cap = int(cap)
    except ValueError:
        return

    icon = get_icon(cap)
    charging_icon = CHARGING_ICON if is_charging else ""

    print(f"{icon}{charging_icon}  {cap}%")

if __name__ == "__main__":
    main()
