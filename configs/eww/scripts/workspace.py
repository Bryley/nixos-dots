#! /usr/bin/env python3

import sys
from time import sleep
import subprocess
import json

from rich import print

def get_workspace_data(monitor_id: str) -> dict:
    result = subprocess.run(
        ["hyprctl", "workspaces", "-j"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    workspaces = json.loads(result.stdout)
    workspaces = [ ws for ws in workspaces if str(ws['monitorID']) == monitor_id ]

    result = subprocess.run(
        ["hyprctl", "monitors", "-j"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    monitors = json.loads(result.stdout)
    monitors = [ monitor for monitor in monitors if str(monitor["id"]) == monitor_id ][0]

    return {
        "active": monitors["activeWorkspace"]["id"],
        "workspaces": [ws["id"] for ws in workspaces],
    }

# "      "
def pretty_str(workspace_data: dict) -> str:
    icons = []
    active = workspace_data["active"]
    workspaces = workspace_data["workspaces"]

    workspaces.sort()

    max_value = max(active, workspaces[-1])

    for workspace in range(1, max_value+1):
        icon = ""
        if workspace == active:
            icon = ""
        elif workspace in workspaces:
            icon = ""
        icons.append(icon)

    return " ".join(icons)

def main(monitor_id: str):
    last_workspaces = None
    while True:
        workspaces = get_workspace_data(monitor_id)

        if workspaces != last_workspaces:
            print(pretty_str(workspaces))

        last_workspaces = workspaces
        sleep(0.1)

if __name__ == "__main__":
    main(sys.argv[1])
