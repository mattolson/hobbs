# Architecture

## Design Principles

**Framework vs distribution vs instance.** The public repo contains source code and documentation. A Docker image is built from the repo and distributed to users. Each user's personal data lives in a separate instance data directory. These three layers never mix.

**CLAUDE.md layering.** Claude Code walks the directory tree and loads CLAUDE.md files from every level, all additive. Hobbs uses this to layer user preferences, the Hobbs agent identity, and project-specific instructions without conflicts.

**Memory as files.** The initial memory system uses plain files (Markdown and JSON) rather than a database. This keeps the system inspectable, editable, and version-controllable. SQLite or vector search can be added later if needed.

**Convention over configuration.** Agents discover memories, playbooks, and configs through well-known directory paths rather than complex configuration.

**Progressive automation.** Tasks move from manual to documented to semi-automated to fully autonomous. Each stage is useful on its own.

## Two Modes

### User Mode

For people using Hobbs as their personal agent. They pull the published Docker image and run it with their own instance data and workspace. They do not need the framework source code.

### Developer Mode

For people working on the Hobbs framework itself. They clone the repo and use the devcontainer setup, which mounts the repo as the workspace with developer-specific CLAUDE.md instructions.

## Container Layout (User Mode)

```
/home/dev/
  hobbs/
    .claude/
      CLAUDE.md                  # Hobbs agent identity (baked into image)
      skills/                    # Hobbs skills (baked into image)
    templates/                   # Playbook and agent templates (baked into image)
    workspace/                   # User's shared working directory (bind mount)
      my-project/                # Could be a git repo with its own .claude/
        .claude/CLAUDE.md        # Project-specific instructions (untouched)
  .claude/                       # User's global Claude config (dotfiles + state volume)
    CLAUDE.md                    # User's personal preferences
    settings.json
    skills/
  .hobbs/                        # Instance data (bind mount)
    foundation.md
    memory/
    playbooks/
    skills/                        # User-created skills
    vault/
```

Claude Code discovers CLAUDE.md files and skills by walking up the directory tree. From `/home/dev/hobbs/workspace/my-project/`, it loads:

1. `my-project/.claude/CLAUDE.md` - project-specific instructions
2. `/home/dev/hobbs/.claude/CLAUDE.md` - Hobbs agent identity
3. `/home/dev/.claude/CLAUDE.md` - user's global preferences

All three are additive. Nothing is overwritten or hidden.

Skills follow the same discovery pattern. `~/.hobbs/skills/` is not an ancestor of the working directory, so Claude Code cannot discover it directly. At shell startup, `hobbs-init.sh` symlinks `~/.hobbs/skills/` to `~/hobbs/workspace/.claude/skills/` if it exists, making instance-level skills discoverable alongside framework skills.

## System Overview

```
+--------------------------------------------------+
|  Docker Container (hobbs)                         |
|                                                   |
|  +--------------------------------------------+  |
|  | Claude Code                                 |  |
|  |                                             |  |
|  |  CLAUDE.md layers:                          |  |
|  |  [user global] + [hobbs identity] + [project]  |
|  |                                             |  |
|  |  +---------------------------------------+  |  |
|  |  | Hobbs (top-level agent)               |  |  |
|  |  | - Orchestration and planning          |  |  |
|  |  | - Memory management                   |  |  |
|  |  | - Task delegation                     |  |  |
|  |  | - Playbook capture                    |  |  |
|  |  +---------------------------------------+  |  |
|  |       |           |           |              |  |
|  |  +--------+  +--------+  +--------+         |  |
|  |  | Sub-   |  | Sub-   |  | Sub-   |         |  |
|  |  | agent  |  | agent  |  | agent  |         |  |
|  |  +--------+  +--------+  +--------+         |  |
|  +--------------------------------------------+  |
|                                                   |
|  Mounts:                                          |
|  ~/hobbs/.claude   -> agent identity (from image) |
|  ~/hobbs/workspace -> shared working dir (bind)   |
|  ~/.hobbs          -> instance data (bind)        |
|  ~/.claude         -> Claude state (volume)       |
+--------------------------------------------------+
         |
    [proxy: enforce]
         |
    allowed: github, claude APIs
```

## Data Flow

### Session Startup

1. Claude Code starts in `/home/dev/hobbs/workspace/`
2. Claude Code walks up and loads:
   - `~/.claude/CLAUDE.md` (user's global preferences, from dotfiles)
   - `~/hobbs/.claude/CLAUDE.md` (Hobbs agent identity, from image)
   - Any project-level CLAUDE.md in the workspace
3. Hobbs agent instructions direct it to load `~/.hobbs/foundation.md` (core values, principles, long-term goals). Always loaded, never filtered or pruned.
4. Hobbs loads `~/.hobbs/claude.md` if it exists (personal instruction overlay)
5. Active memories from `~/.hobbs/memory/active/` are read and injected into context
6. Agent is ready for interaction

### Memory Write

1. Agent identifies something worth remembering during a session
2. Memory is written to `~/.hobbs/memory/` with metadata (tags, timestamp, source)
3. If the memory relates to an existing entry, the existing entry is reinforced (count incremented, timestamp updated)
4. If the memory conflicts with an existing entry, the old entry is marked superseded

### Task Delegation

1. Hobbs receives a task and determines the appropriate sub-agent
2. Agent definition is loaded (from image or `~/.hobbs/agents/` for custom agents)
3. Foundation is always included (never filtered out)
4. Additional memories are filtered by the agent's tag configuration
5. Sub-agent is spawned via Claude Code's Task tool with: prompt + foundation + filtered memories + operational config
6. Sub-agent executes and returns results
7. Sub-agent's operational learnings are written back to its config
8. Task outcome feeds into the retrospective/memory system

### Playbook Lifecycle

1. User describes a manual workflow via `/capture-playbook`
2. Playbook is written to `~/.hobbs/playbooks/` as structured Markdown
3. Over time, playbook is refined through `/review-playbooks` sessions
4. Automation opportunities are identified and steps are converted to skills or agent tasks

## Directory Layouts

### Framework Repo

```
/workspace/                        # Developer's working directory
  .claude/
    CLAUDE.md                      # Developer instructions (not Hobbs identity)
  src/                             # Source files (single source of truth)
    agents/
      hobbs/
        CLAUDE.md                  # Hobbs agent identity
    skills/
      capture-playbook/
        SKILL.md
      review-playbooks/
        SKILL.md
    shell.d/
      hobbs-init.sh                # Startup script (instance skill linking)
    templates/
      playbook.md                  # Playbook template
  dist/                            # Deployment artifacts
    Dockerfile                     # Builds the published image (copies from src/)
    docker-compose.yml             # Template compose file for users
    policy.yaml                    # Default network policy
  docs/                            # Documentation
  tests/                           # Tests
```

### Published Image

```
/home/dev/hobbs/                   # Hobbs wrapper directory
  .claude/
    CLAUDE.md                      # Hobbs agent identity
    skills/
      capture-playbook/SKILL.md
      review-playbooks/SKILL.md
  templates/
    playbook.md
  workspace/                       # Mount point for user's shared directory
```

### Instance Data

On the host, instance data follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/) and defaults to `~/.local/share/hobbs/`. Inside the container, it is bind-mounted at `~/.hobbs`. All agent code and documentation references use the container path (`~/.hobbs`).

```
~/.local/share/hobbs/   (host)
~/.hobbs/               (container)
  foundation.md                    # Core values, principles, long-term goals
  config.yaml                      # Instance configuration
  claude.md                        # Personal instruction overlay
  memory/
    active/                        # Loaded at session start
    archive/                       # Searchable but not auto-loaded
  playbooks/                       # Documented workflows
  skills/                          # User-created skills (symlinked at startup)
  agents/
    hobbs/
      operational.md               # Hobbs operational learnings
    custom/                        # User-defined sub-agents
  vault/
    keys/                          # Encryption keys
    data/                          # Encrypted data files
  logs/
    audit.log                      # Access and operation log
    tasks/                         # Task history and retrospectives
```

## Sandbox Environment

The agent runs in a Docker container with the following security properties:

- **Network isolation:** All outbound traffic routes through a proxy that enforces an allowlist defined in `policy.yaml`.
- **Capability restrictions:** The container has `NET_ADMIN` and `NET_RAW` for firewall setup, but the agent user cannot modify iptables directly.
- **Volume separation:** Claude state, instance data, and the workspace are separate mounts with appropriate permissions.
- **Hobbs identity is read-only:** The `~/hobbs/.claude/` directory is baked into the image. The user cannot accidentally modify the agent identity from inside the container.

## Technology Choices

- **Runtime:** Claude Code (CLI) with Claude as the backing model
- **Memory storage:** Markdown and JSON files (initially), with SQLite as a future option for queryable history
- **Encryption:** age or SOPS for vault data (works offline, no external KMS needed)
- **Container:** Docker with Docker Compose, mitmproxy for network policy enforcement
- **Distribution:** Docker image published to GitHub Container Registry
- **Skills:** Claude Code custom slash commands (Markdown prompt templates)
