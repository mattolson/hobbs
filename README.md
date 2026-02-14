# Hobbs

> **Warning:** This project is in early development and not ready for public use. APIs, file formats, and architecture are all subject to change. Feel free to watch or star for updates, but expect breaking changes.

Hobbs is a personal AI agent framework built on [Claude Code](https://docs.anthropic.com/en/docs/claude-code) and [agent-sandbox](https://github.com/mattolson/agent-sandbox). It serves as your primary point of contact for task execution, planning, and delegation to specialized sub-agents.

The framework is designed to learn and adapt over time. Through a persistent memory system, Hobbs remembers your preferences, understands your projects, and improves at the tasks you delegate. Sub-agents handle specialized work and develop their own operational expertise.

## Key Capabilities

- **Persistent memory** that carries context across sessions, with scoring based on recency and reinforcement
- **Sub-agent delegation** for specialized tasks, each with their own prompt templates and operational learnings
- **Secure data vault** for sensitive information with encryption at rest and access controls
- **Playbook capture** for documenting manual workflows and progressively automating them
- **Instance data separation** keeping personal data outside the public framework repo
- **Secure execution environment** via [agent-sandbox](https://github.com/mattolson/agent-sandbox) with network isolation and proxy-enforced allowlists

## Using Hobbs

You do not need to clone this repo to use Hobbs. The Hobbs agent is distributed as a Docker image.

```bash
# Create directories
mkdir -p ~/.local/share/hobbs ~/hobbs/workspace

# Download the compose file and network policy
curl -o ~/hobbs/docker-compose.yml <release-url>/docker-compose.yml
curl -o ~/hobbs/policy.yaml <release-url>/policy.yaml

# Start Hobbs
cd ~/hobbs
docker compose up -d
docker compose exec hobbs zsh
claude
```

See [Setup](docs/setup.md) for details on instance data, backups, file permissions, and configuration.

## Developing the Framework

To work on the Hobbs framework itself:

```bash
git clone https://github.com/mattolson/hobbs.git
cd hobbs
docker compose up -d
docker compose exec agent zsh
claude
```

This uses the devcontainer setup in `.devcontainer/`, which mounts the repo as the workspace with developer-specific instructions. See [Contributing](docs/contributing.md) for details.

## Architecture

Hobbs separates the framework (this repo) from the distributed image and from each user's instance data.

```
Framework repo                   # Source code, agent definitions, docs
  src/                           # Source files (single source of truth)
    agents/hobbs/CLAUDE.md       # Hobbs agent identity
    skills/                      # Skills
    templates/                   # Templates
  dist/                          # Deployment artifacts (Dockerfile, compose, policy)

Docker image (ghcr.io/mattolson/hobbs)
  ~/hobbs/.claude/CLAUDE.md      # Hobbs agent identity (baked in)
  ~/hobbs/.claude/skills/        # Hobbs skills (baked in)
  ~/hobbs/templates/             # Templates (baked in)
  ~/hobbs/workspace/             # Mount point for user's shared directory

User's host
  ~/.local/share/hobbs/          # Instance data (bind mount)
  ~/hobbs/workspace/              # Shared working directory (bind mount)
  ~/.config/agent-sandbox/       # Global Claude config via dotfiles
```

Claude Code configuration layers (bottom to top, all additive):
1. `~/.claude/CLAUDE.md` - user's global preferences (via dotfiles)
2. `~/hobbs/.claude/CLAUDE.md` - Hobbs agent identity (from image)
3. Project `.claude/CLAUDE.md` - project-specific instructions (if any)

## Documentation

- [Setup](docs/setup.md) - installation, instance data, backups
- [Roadmap](docs/roadmap.md) - project milestones and plan
- [Architecture](docs/architecture.md) - system design and data flow
- [Memory System](docs/memory.md) - how persistent memory works
- [Playbooks](docs/playbooks.md) - capturing and automating workflows

## License

[MIT](LICENSE)
