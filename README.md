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

## Architecture

Hobbs separates the framework (this repo) from instance data (your personal memories, playbooks, vault, and agent customizations).

```
/workspace/                      # Framework (public repo)
  templates/                     # Reusable templates (playbooks, agents)
  src/                           # Framework code
  agents/                        # Agent definitions
  docs/                          # Documentation
  .claude/skills/                # Claude Code skills

~/.local/share/hobbs/            # Instance data (private, bind mount)
  foundation.md                  # Core values, principles, long-term goals
  config.yaml                    # Personal configuration
  claude.md                      # Personal instruction overlay
  memory/                        # Memories (preferences, projects, retrospectives)
  playbooks/                     # Documented workflows
  agents/                        # Personal agent customizations
  vault/                         # Encrypted sensitive data
  logs/                          # Audit and task history
```

## Prerequisites

- Docker and Docker Compose
- A Claude API key or Claude Pro/Max subscription
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI

## Getting Started

```bash
# Clone the repo
git clone https://github.com/mattolson/hobbs.git
cd hobbs

# Create your instance data directory
mkdir -p ~/.local/share/hobbs

# Start the sandbox
docker compose up -d
docker compose exec agent zsh

# Initialize your instance data
# hobbs init - NOT IMPLEMENTED YET

# Start Claude Code
claude
```

See [Setup](docs/setup.md) for details on instance data, backups, file permissions, and custom data paths.

## Sandbox Environment

Hobbs runs inside [agent-sandbox](https://github.com/mattolson/agent-sandbox), which provides a secure execution environment for AI agents. The container enforces network restrictions through a proxy with an allowlist defined in `.devcontainer/policy.yaml`. All outbound traffic must pass through this proxy, preventing unauthorized network access. See the agent-sandbox documentation for details on the security model.

## Documentation

- [Setup](docs/setup.md) - installation, instance data, backups
- [Roadmap](docs/roadmap.md) - project milestones and plan
- [Architecture](docs/architecture.md) - system design and data flow
- [Memory System](docs/memory.md) - how persistent memory works
- [Playbooks](docs/playbooks.md) - capturing and automating workflows

## License

[MIT](LICENSE)
