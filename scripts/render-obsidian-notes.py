#!/usr/bin/env python3

from __future__ import annotations

import json
import os
from pathlib import Path
from datetime import date

import yaml


ROOT = Path(os.environ.get("DOTFILES_ROOT", Path(__file__).resolve().parents[1]))
OUT = ROOT / "obsidian" / "generated"

CONFIG_MODULES = ROOT / "common" / "keybinds" / "curated" / "config-modules.yaml"
CURATED_KEYBINDS = ROOT / "common" / "keybinds" / "curated" / "keybinds.yaml"

TODAY = date.today().isoformat()


def write_note(path: Path, frontmatter: dict, body: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)

    yaml_text = yaml.safe_dump(
        frontmatter,
        sort_keys=False,
        allow_unicode=True,
        default_flow_style=False,
    ).strip()

    path.write_text(
        f"---\n{yaml_text}\n---\n\n{body}\n",
        encoding="utf-8",
    )


def load_yaml(path: Path) -> dict:
    if not path.exists():
        return {}

    return yaml.safe_load(path.read_text(encoding="utf-8")) or {}


def load_jsonl(path: Path) -> list[dict]:
    if not path.exists():
        return []

    rows = []

    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()

        if not line:
            continue

        try:
            rows.append(json.loads(line))
        except json.JSONDecodeError:
            continue

    return rows


def load_tsv(path: Path) -> list[dict]:
    if not path.exists():
        return []

    rows = []

    for line in path.read_text(encoding="utf-8").splitlines():
        parts = line.split("\t")

        while len(parts) < 4:
            parts.append("")

        rows.append(
            {
                "key_table": parts[0],
                "key": parts[1],
                "command": parts[2],
                "note": parts[3],
            }
        )

    return rows


def load_tmux_raw(path: Path) -> list[str]:
    if not path.exists():
        return []

    return path.read_text(encoding="utf-8").splitlines()


def escape_table(value: object) -> str:
    return str(value or "").replace("|", "\\|").replace("\n", " ")


def render_config_modules() -> None:
    data = load_yaml(CONFIG_MODULES)
    configs = data.get("configs", [])

    for cfg in configs:
        title = cfg.get("title", cfg.get("id", "Untitled"))

        frontmatter = {
            "type": "config-module",
            "title": title,
            "tool": cfg.get("id"),
            "area": cfg.get("area"),
            "platforms": [cfg.get("platform")],
            "status": cfg.get("status"),
            "priority": cfg.get("priority"),
            "source_path": cfg.get("source_path"),
            "repo_path": cfg.get("repo_path"),
            "parity_target": cfg.get("parity_target"),
            "keybind_importance": cfg.get("keybind_importance"),
            "updated": TODAY,
            "tags": [
                f"config/{cfg.get('area')}",
                f"platform/{cfg.get('platform')}",
                f"tool/{cfg.get('id')}",
            ],
        }

        body = f"""# {title}

## Purpose

Describe what this config controls.

## Current paths

| Type | Path |
|---|---|
| Live path | `{cfg.get("source_path", "")}` |
| Repo path | `{cfg.get("repo_path", "")}` |

## Keybinds to remember

See [[Keybinds Dashboard]].

## Cross-platform parity

| Concept | This config | Parity target | Notes |
|---|---|---|---|
|  | {title} | {cfg.get("parity_target", "")} |  |

## Setup / restore notes

Add setup or restore commands here.

## Cleanup tasks

- [ ] Confirm live path
- [ ] Confirm repo path
- [ ] Confirm generated keybind extraction
- [ ] Confirm Windows parity target
"""

        write_note(OUT / "Configs" / f"{title}.md", frontmatter, body)


def render_keybind_dashboard() -> None:
    curated = load_yaml(CURATED_KEYBINDS).get("keybinds", [])

    nvim_rows = load_jsonl(
        ROOT / "common" / "keybinds" / "generated" / "nvim.jsonl"
    )

    tmux_rows = load_tsv(
        ROOT / "common" / "keybinds" / "generated" / "tmux.tsv"
    )

    tmux_raw = load_tmux_raw(
        ROOT / "common" / "keybinds" / "generated" / "tmux.txt"
    )

    frontmatter = {
        "type": "dashboard",
        "title": "Keybinds Dashboard",
        "area": "system",
        "updated": TODAY,
        "tags": ["dashboard/keybinds", "system/dotfiles"],
    }

    lines = []

    lines.append("# Keybinds Dashboard")
    lines.append("")
    lines.append("## Curated keybinds")
    lines.append("")
    lines.append("| App | Area | Platform | Key | Action | Frequency | Importance |")
    lines.append("|---|---|---|---|---|---|---|")

    for row in curated:
        lines.append(
            "| "
            + escape_table(row.get("app"))
            + " | "
            + escape_table(row.get("area"))
            + " | "
            + escape_table(row.get("platform"))
            + " | `"
            + escape_table(row.get("key"))
            + "` | "
            + escape_table(row.get("action"))
            + " | "
            + escape_table(row.get("frequency"))
            + " | "
            + escape_table(row.get("importance"))
            + " |"
        )

    lines.append("")
    lines.append("## Rare or high-importance keybinds")
    lines.append("")
    lines.append("| App | Key | Action |")
    lines.append("|---|---|---|")

    for row in curated:
        if row.get("frequency") == "rare" or row.get("importance") == "high":
            lines.append(
                "| "
                + escape_table(row.get("app"))
                + " | `"
                + escape_table(row.get("key"))
                + "` | "
                + escape_table(row.get("action"))
                + " |"
            )

    lines.append("")
    lines.append("## Extracted Neovim keymaps")
    lines.append("")
    lines.append("| Mode | Key | Action |")
    lines.append("|---|---|---|")

    for row in nvim_rows:
        action = escape_table(row.get("action"))
        key = escape_table(row.get("key"))
        mode = escape_table(row.get("mode"))

        if action and action != "<callback>":
            lines.append(f"| {mode} | `{key}` | {action} |")

    lines.append("")
    lines.append("## Extracted tmux keymaps")
    lines.append("")

    if tmux_rows:
        lines.append("| Table | Key | Command | Note |")
        lines.append("|---|---|---|---|")

        for row in tmux_rows:
            lines.append(
                "| "
                + escape_table(row.get("key_table"))
                + " | `"
                + escape_table(row.get("key"))
                + "` | `"
                + escape_table(row.get("command"))
                + "` | "
                + escape_table(row.get("note"))
                + " |"
            )

    elif tmux_raw:
        lines.append("Raw tmux output:")
        lines.append("")
        lines.append("~~~text")

        for line in tmux_raw:
            lines.append(line)

        lines.append("~~~")

    else:
        lines.append("No tmux keymap export found yet.")

    write_note(
        OUT / "Keybinds Dashboard.md",
        frontmatter,
        "\n".join(lines),
    )


def main() -> None:
    render_config_modules()
    render_keybind_dashboard()
    print(f"Wrote Obsidian notes to {OUT}")


if __name__ == "__main__":
    main()
