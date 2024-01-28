#! /usr/bin/env python3

"""
Simple script to display a wallpaper using certain tag/theme and wallpaper

./wallpaper.py group up | Go to the next group
./wallpaper.py group down | Go to the prev group

./wallpaper.py img up   | Select the next image
./wallpaper.py img down   | Select the prev image

./wallpaper.py display    | Get a string representation of the current selection
"""


from os import system
import sys
import yaml
from pathlib import Path
from rich import print

WALLPAPERS_DIR = Path("~/.config/hypr/wallpapers").expanduser()

def get_groups(wallpaper_data: dict) -> dict[str, list]:
    groups = {"all": set()}
    
    for wallpaper in wallpaper_data["images"]:
        name: str = wallpaper["name"]
        if not (WALLPAPERS_DIR / name).is_file():
            continue

        for tag in wallpaper["tags"]:
            groups["all"].add(wallpaper["name"])
            if (imgs := groups.get(tag)) is not None:
                imgs.add(wallpaper["name"])
            else:
                imgs = {wallpaper["name"]}
            groups[tag] = imgs

    return { key: sorted(value) for key, value in groups.items()}


def display(wallpaper_data: dict, groups: dict) -> str:
    selected = wallpaper_data["selected"]
    selected_group = wallpaper_data["selected_group"]

    group_count = f"({[*groups.keys()].index(selected_group)+1}/{len(groups)})"
    imgs: list[str] = groups[selected_group]
    img_count = f"({imgs.index(selected)+1 if selected in imgs else '?'}/{len(imgs)})"

    return f"Group: '{selected_group}' {group_count} | Img: '{selected}' {img_count}"

def set_group(data: dict, group: str):
    data["selected_group"] = group

    with open(WALLPAPERS_DIR / "wallpaper.yaml", "w") as file:
        yaml.safe_dump(data, file)


def set_img(data: dict, img: str):
    data["selected"] = img

    with open(WALLPAPERS_DIR / "wallpaper.yaml", "w") as file:
        yaml.safe_dump(data, file)

def main(args: list[str]):
    with open(WALLPAPERS_DIR / "wallpaper.yaml", "r") as file:
        data = yaml.safe_load(file)

    groups = get_groups(data)

    if len(args) > 1 and args[1] == "display":
        print(display(data, groups))
        return

    selected_group = data["selected_group"]
    selected_img = data["selected"]
    
    if len(args) >= 3 and args[1] == "group":
        group_keys = [*groups.keys()]
        index = group_keys.index(selected_group)
        if args[2] == "up":
            index = (index + 1) % len(group_keys)
            set_group(data, group_keys[index])
            return
        if args[2] == "down":
            index = (index - 1) % len(groups)
            set_group(data, group_keys[index])
            return

    if len(args) >= 3 and args[1] == "img":
        imgs = groups[selected_group]
        index = imgs.index(selected_img) if selected_img in imgs else 0
        if args[2] == "up":
            index = (index + 1) % len(imgs)
            set_img(data, imgs[index])
            system(f"swww img {WALLPAPERS_DIR / imgs[index]} --transition-type grow --transition-pos 0.5,1.0")
            return
        if args[2] == "down":
            index = (index - 1) % len(imgs)
            set_img(data, imgs[index])
            system(f"swww img {WALLPAPERS_DIR / imgs[index]} --transition-type outer --transition-pos 0.5,1.0")
            return

    print("""
Incorrect Usage:
    ./wallpaper.py group next | Go to the next group
    ./wallpaper.py group prev | Go to the prev group

    ./wallpaper.py img next   | Select the next image
    ./wallpaper.py img prev   | Select the prev image

    ./wallpaper.py display    | Get a string representation of the current selection
    """, file=sys.stderr)



if __name__ == "__main__":
    main(sys.argv)
