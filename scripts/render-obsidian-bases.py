#!/usr/bin/env python3

from __future__ import annotations

import csv
import re
from pathlib import Path
from datetime import date


ROOT = Path(__file__).resolve().parents[1]

CONFIGS_TSV = ROOT / "common" / "keybinds" / "curated" / "config-modules.tsv"
KEYBINDS_TSV = ROOT / "common" / "keybinds" / "curated" / "keybinds.tsv"

OUT = ROOT / "obsidian" / "generated" / "Dotfiles"

TODAY = date.today().isoformat()


def slugify(text: str) -> str:
    text = text.strip().lower()
    text = re.sub(r"[^a-z0-9]+", "-", text)
    text = re.sub(r"-+", "-", text)
    return text.strip("-") or "item"


def yaml_quote(value: str) -> str:
    value = value or ""
    escaped = value.replace("\\", "\\\\").replace('"', '\\"')
    return f'"{escaped}"'


def read_tsv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []

    with path.open("r", encoding="utf-8", newline="") as f:
        return list(csv.DictReader(f, delimiter="\t"))


def write(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def render_config_note(row: dict[str, str]) -> None:
    title = row["title"]
    filename = slugify(title) + ".md"

    body = f"""---
type: config-module
title: {yaml_quote(title)}
tool: {yaml_quote(row["id"])}
area: {yaml_quote(row["area"])}
platform: {yaml_quote(row["platform"])}
status: {yaml_quote(row["status"])}
priority: {yaml_quote(row["priority"])}
source_path: {yaml_quote(row["source_path"])}
repo_path: {yaml_quote(row["repo_path"])}
parity_target: {yaml_quote(row["parity_target"])}
updated: {yaml_quote(TODAY)}
tags:
  - config/{row["area"]}
  - platform/{row["platform"]}
  - tool/{row["id"]}
---

# {title}

## Purpose

Describe what this config controls.

## Current paths

| Type | Path |
|---|---|
| Live path | `{row["source_path"]}` |
| Repo path | `{row["repo_path"]}` |

## Parity

| Field | Value |
|---|---|
| Platform | `{row["platform"]}` |
| Parity target | `{row["parity_target"]}` |
| Status | `{row["status"]}` |

## Notes

- 

## Tasks

- [ ] Confirm live path
- [ ] Confirm repo path
- [ ] Confirm keybind extraction
- [ ] Confirm Windows parity target
"""

    write(OUT / "Configs" / filename, body)


def render_keybind_note(row: dict[str, str]) -> None:
    title = f'{row["app"]}: {row["action"]}'
    filename = slugify(row["app"] + "-" + row["parity_action"]) + ".md"

    body = f"""---
type: keybind
title: {yaml_quote(title)}
app: {yaml_quote(row["app"])}
area: {yaml_quote(row["area"])}
platform: {yaml_quote(row["platform"])}
key: {yaml_quote(row["key"])}
action: {yaml_quote(row["action"])}
frequency: {yaml_quote(row["frequency"])}
importance: {yaml_quote(row["importance"])}
parity_action: {yaml_quote(row["parity_action"])}
updated: {yaml_quote(TODAY)}
tags:
  - keybind/{row["area"]}
  - platform/{row["platform"]}
  - app/{row["app"]}
  - frequency/{row["frequency"]}
  - importance/{row["importance"]}
---

# {title}

| Field | Value |
|---|---|
| App | `{row["app"]}` |
| Area | `{row["area"]}` |
| Platform | `{row["platform"]}` |
| Key | `{row["key"]}` |
| Action | {row["action"]} |
| Frequency | `{row["frequency"]}` |
| Importance | `{row["importance"]}` |
| Parity action | `{row["parity_action"]}` |

## Notes

- 

## Windows / cross-platform parity

- macOS:
- Windows:
- WSL:
"""

    write(OUT / "Keybinds" / filename, body)


def render_config_base() -> None:
    text = """filters:
  and:
    - 'type == "config-module"'

properties:
  title:
    displayName: Title
  tool:
    displayName: Tool
  area:
    displayName: Area
  platform:
    displayName: Platform
  status:
    displayName: Status
  priority:
    displayName: Priority
  source_path:
    displayName: Live path
  repo_path:
    displayName: Repo path
  parity_target:
    displayName: Parity target

views:
  - type: table
    name: "All configs"
    order:
      - file.name
      - area
      - platform
      - status
      - priority
      - parity_target

  - type: table
    name: "Workspace"
    filters:
      and:
        - 'area == "workspace"'
    order:
      - file.name
      - platform
      - status
      - parity_target

  - type: table
    name: "Terminal and editor"
    filters:
      or:
        - 'area == "terminal"'
        - 'area == "editor"'
        - 'area == "shell"'
    order:
      - file.name
      - area
      - platform
      - status

  - type: table
    name: "Needs parity"
    filters:
      and:
        - 'parity_target != "none"'
        - 'parity_target != ""'
    order:
      - file.name
      - platform
      - parity_target
      - status
"""
    write(OUT / "Bases" / "Config Modules.base", text)


def render_keybind_base() -> None:
    text = """filters:
  and:
    - 'type == "keybind"'

properties:
  app:
    displayName: App
  area:
    displayName: Area
  platform:
    displayName: Platform
  key:
    displayName: Key
  action:
    displayName: Action
  frequency:
    displayName: Frequency
  importance:
    displayName: Importance
  parity_action:
    displayName: Parity action

views:
  - type: table
    name: "All keybinds"
    order:
      - app
      - area
      - platform
      - key
      - action
      - frequency
      - importance

  - type: table
    name: "Rare but important"
    filters:
      or:
        - 'frequency == "rare"'
        - 'importance == "high"'
    order:
      - app
      - key
      - action
      - frequency
      - importance

  - type: table
    name: "Workspace"
    filters:
      and:
        - 'area == "workspace"'
    order:
      - app
      - platform
      - key
      - action

  - type: table
    name: "Terminal/editor"
    filters:
      or:
        - 'area == "terminal"'
        - 'area == "editor"'
        - 'area == "shell"'
    order:
      - app
      - key
      - action
      - frequency

  - type: table
    name: "Windows parity"
    filters:
      and:
        - 'platform != "windows"'
    order:
      - parity_action
      - app
      - platform
      - key
      - action
"""
    write(OUT / "Bases" / "Keybinds.base", text)


def main() -> None:
    configs = read_tsv(CONFIGS_TSV)
    keybinds = read_tsv(KEYBINDS_TSV)

    for row in configs:
        render_config_note(row)

    for row in keybinds:
        render_keybind_note(row)

    render_config_base()
    render_keybind_base()

    print(f"Wrote Obsidian Bases setup to: {OUT}")


if __name__ == "__main__":
    main()
