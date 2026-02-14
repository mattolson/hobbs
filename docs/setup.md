# Setup

## Prerequisites

- Docker and Docker Compose
- A Claude API key or Claude Pro/Max subscription
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI

## Installation

```bash
git clone https://github.com/mattolson/hobbs.git
cd hobbs
```

## Instance Data Directory

Hobbs stores personal data following the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/). The default location is:

```
~/.local/share/hobbs/
```

Create it before starting the container:

```bash
mkdir -p ~/.local/share/hobbs
```

This directory stores your personal data (memories, foundation, playbooks, vault). It is bind-mounted into the container at `/home/dev/.hobbs` and persists across container rebuilds, restarts, and `docker compose down`.

The directory is not part of the git repo and is never shared.

## Starting the Sandbox

```bash
docker compose up -d
docker compose exec agent zsh
claude
```

## Backups

Your instance data lives at `~/.local/share/hobbs` on the host. Back it up however you back up any important directory:

```bash
# Simple copy
cp -r ~/.local/share/hobbs ~/.local/share/hobbs-backup-$(date +%Y%m%d)

# Or add to your existing backup system, rsync, etc.
rsync -a ~/.local/share/hobbs/ /path/to/backup/hobbs/
```

Since the data is just files on your host filesystem, it works with any backup tool. Consider backing up before major changes or periodically on a schedule.

## Data Safety

Unlike Docker volumes, your instance data will not be deleted by:

- `docker compose down` (even with `-v` flag, which only removes Docker volumes)
- `docker system prune --volumes`
- Deleting and recreating the compose project
- Rebuilding or replacing the container image

The only way to lose this data is to delete `~/.local/share/hobbs` on the host.

## File Permissions

The container runs as user `dev` (UID 500). If your host user has a different UID, you may need to adjust ownership:

```bash
# Check your UID
id -u

# If not 500, set ownership to match the container user
sudo chown -R 500:500 ~/.local/share/hobbs
```

## Custom Instance Data Path

To store instance data somewhere other than the default, set the `HOBBS_DATA` environment variable before starting the container:

```bash
export HOBBS_DATA=/path/to/your/data
docker compose up -d
```

Resolution order:
1. `HOBBS_DATA` if set
2. `~/.local/share/hobbs` (XDG default)

If you have a non-default `XDG_DATA_HOME`, set `HOBBS_DATA` to `${XDG_DATA_HOME}/hobbs`.
