# Architecture

## Design Principles

**Framework vs instance separation.** The public repo contains the framework: agent definitions, templates, skills, and tooling. Personal data (memories, playbooks, vault contents, agent customizations) lives outside the repo in a dedicated instance data directory. This makes accidental data leakage structurally impossible.

**Memory as files.** The initial memory system uses plain files (Markdown and JSON) rather than a database. This keeps the system inspectable, editable, and version-controllable. SQLite or vector search can be added later if needed.

**Convention over configuration.** Agents discover memories, playbooks, and configs through well-known directory paths rather than complex configuration.

**Progressive automation.** Tasks move from manual to documented to semi-automated to fully autonomous. Each stage is useful on its own.

## System Overview

```
+--------------------------------------------------+
|  Docker Container (agent-sandbox)                 |
|                                                   |
|  +--------------------------------------------+  |
|  | Claude Code                                 |  |
|  |                                             |  |
|  |  +---------------------------------------+  |  |
|  |  | Hobbs (top-level agent)               |  |  |
|  |  |                                       |  |  |
|  |  | - Orchestration and planning          |  |  |
|  |  | - Memory management                   |  |  |
|  |  | - Task delegation                     |  |  |
|  |  | - Playbook capture                    |  |  |
|  |  +---------------------------------------+  |  |
|  |       |           |           |              |  |
|  |  +--------+  +--------+  +--------+         |  |
|  |  | Sub-   |  | Sub-   |  | Sub-   |         |  |
|  |  | agent  |  | agent  |  | agent  |         |  |
|  |  | A      |  | B      |  | C      |         |  |
|  |  +--------+  +--------+  +--------+         |  |
|  +--------------------------------------------+  |
|                                                   |
|  Volumes:                                         |
|  /workspace        -> framework repo (shared)     |
|  ~/.hobbs          -> instance data (private)     |
|  ~/.claude         -> Claude Code state           |
+--------------------------------------------------+
         |
    [proxy: enforce]
         |
    allowed: github, claude APIs
```

## Data Flow

### Session Startup

1. Claude Code starts and loads `/workspace/.claude/CLAUDE.md` (framework instructions)
2. Framework instructions direct the agent to load `~/.hobbs/claude.md` (personal overlay)
3. Foundation is loaded from `~/.hobbs/foundation.md` (core values, principles, long-term goals). This is always loaded and never filtered or pruned.
4. Active memories from `~/.hobbs/memory/active/` are read and injected into context
5. Agent is ready for interaction

### Memory Write

1. Agent identifies something worth remembering during a session
2. Memory is written to `~/.hobbs/memory/` with metadata (tags, timestamp, source)
3. If the memory relates to an existing entry, the existing entry is reinforced (count incremented, timestamp updated)
4. If the memory conflicts with an existing entry, the old entry is marked superseded

### Task Delegation

1. Hobbs receives a task and determines the appropriate sub-agent
2. Agent definition is loaded from `/workspace/agents/` (base) with any overrides from `~/.hobbs/agents/`
3. Foundation is always included (never filtered out)
4. Additional memories are filtered by the agent's tag configuration
5. Sub-agent is spawned via Claude Code's Task tool with: prompt + foundation + filtered memories + operational config
5. Sub-agent executes and returns results
6. Sub-agent's operational learnings are written back to its config
7. Task outcome feeds into the retrospective/memory system

### Playbook Lifecycle

1. User describes a manual workflow via `/capture-playbook`
2. Playbook is written to `~/.hobbs/playbooks/` as structured Markdown
3. Over time, playbook is refined through `/review-playbooks` sessions
4. Automation opportunities are identified and steps are converted to skills or agent tasks
5. Generalizable patterns are extracted into `/workspace/templates/` for the public framework

## Directory Layout

### Framework (public repo: /workspace)

```
/workspace/
  CLAUDE.md                      # Framework-level agent instructions
  .claude/
    skills/                      # Claude Code skills (slash commands)
      capture-playbook/
        SKILL.md
      review-playbooks/
        SKILL.md
  templates/
    playbook.md                  # Playbook template
  agents/                        # Base agent definitions
    hobbs/
      prompt.md
    templates/                   # Starter sub-agent templates
  src/                           # Framework code
    memory/                      # Memory management
    agents/                      # Agent registry and runner
    vault/                       # Encryption and access control
  docs/                          # Documentation
  tests/                         # Tests
```

### Instance Data (private: ~/.hobbs)

```
~/.hobbs/
  foundation.md                  # Core values, principles, long-term goals
  config.yaml                    # Instance configuration
  claude.md                      # Personal instruction overlay
  memory/
    active/                      # Loaded at session start
    archive/                     # Searchable but not auto-loaded
  playbooks/                     # Documented workflows
  agents/
    hobbs/
      operational.md             # Hobbs operational learnings
    custom/                      # User-defined sub-agents
  vault/
    keys/                        # Encryption keys
    data/                        # Encrypted data files
  logs/
    audit.log                    # Access and operation log
    tasks/                       # Task history and retrospectives
```

## Sandbox Environment

The agent runs in a Docker container with the following security properties:

- **Network isolation:** All outbound traffic routes through a proxy that enforces an allowlist defined in `.devcontainer/policy.yaml`.
- **Read-only devcontainer config:** The `.devcontainer/` directory is mounted read-only, preventing the agent from modifying its own sandbox configuration.
- **Capability restrictions:** The container has `NET_ADMIN` and `NET_RAW` for firewall setup, but the agent user cannot modify iptables directly.
- **Volume separation:** Claude state, instance data, and the workspace are separate volumes with appropriate permissions.

## Technology Choices

- **Runtime:** Claude Code (CLI) with Claude as the backing model
- **Memory storage:** Markdown and JSON files (initially), with SQLite as a future option for queryable history
- **Encryption:** age or SOPS for vault data (works offline, no external KMS needed)
- **Container:** Docker with Docker Compose, mitmproxy for network policy enforcement
- **Skills:** Claude Code custom slash commands (Markdown prompt templates)
