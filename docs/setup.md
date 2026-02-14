# Setup

## Prerequisites

- Docker and Docker Compose
- A Claude API key or Claude Pro/Max subscription

Claude Code is pre-installed in the Hobbs Docker image. You do not need to install it on your host.

## Quick Start

```bash
# Create directories
mkdir -p ~/.local/share/hobbs ~/hobbs/workspace

# Get the compose file and network policy
curl -o ~/hobbs/docker-compose.yml <release-url>/docker-compose.yml
curl -o ~/hobbs/policy.yaml <release-url>/policy.yaml

# Start Hobbs
cd ~/hobbs
docker compose up -d
docker compose exec hobbs zsh
claude
```

## Directories

Hobbs uses two host directories:

### Hobbs Directory (~/hobbs)

The top-level directory contains the compose file and network policy. The `workspace/` subdirectory is where you and Hobbs collaborate on files. Only the workspace subdirectory is bind-mounted into the container.

```
~/hobbs/
  docker-compose.yml    # Container configuration
  policy.yaml           # Network allowlist
  workspace/            # Shared working directory (bind-mounted)
```

Inside the container, `~/hobbs/workspace/` mounts at `/home/dev/hobbs/workspace/`.

### Instance Data (~/.local/share/hobbs)

Your personal data: memories, foundation, playbooks, vault. This follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/).

Inside the container, this mounts at `/home/dev/.hobbs/`.

This is the data you want to protect and back up. See Backups below.

## Configuration

Environment variables control host paths:

| Variable | Default | Description |
|----------|---------|-------------|
| `WORKSPACE` | `~/hobbs/workspace` | Shared working directory |
| `HOBBS_DATA` | `~/.local/share/hobbs` | Instance data |
| `TZ` | `America/Los_Angeles` | Timezone |

Example with custom paths:

```bash
WORKSPACE=~/projects HOBBS_DATA=~/my-hobbs-data docker compose up -d
```

## User-Level Claude Config

If you have an existing `~/.claude/CLAUDE.md`, `settings.json`, or skills on your host, these flow into the container through the [agent-sandbox dotfiles mechanism](https://github.com/mattolson/agent-sandbox). Place them in:

```
~/.config/agent-sandbox/dotfiles/.claude/
```

These are mounted read-only and apply globally inside the container. Hobbs layers its own identity on top without modifying your global config.

## Backups

Instance data lives at `~/.local/share/hobbs` on the host. Back it up like any directory:

```bash
# Simple copy
cp -r ~/.local/share/hobbs ~/.local/share/hobbs-backup-$(date +%Y%m%d)

# Or use your existing backup system
rsync -a ~/.local/share/hobbs/ /path/to/backup/hobbs/
```

## Data Safety

Instance data is a bind mount, not a Docker volume. It will not be deleted by:

- `docker compose down` (even with `-v`)
- `docker system prune --volumes`
- Deleting and recreating the compose project
- Rebuilding or replacing the container image

The only way to lose this data is to delete `~/.local/share/hobbs` on the host.

## File Permissions

The container runs as user `dev` (UID 500). If your host user has a different UID, adjust ownership:

```bash
# Check your UID
id -u

# If not 500, set ownership to match the container user
sudo chown -R 500:500 ~/.local/share/hobbs
```

## Network Policy

The proxy enforces an allowlist defined in `policy.yaml`. By default, only GitHub and Claude API traffic is allowed. To add services for your workflows, edit `policy.yaml` and restart the proxy:

```bash
docker compose restart proxy
```
