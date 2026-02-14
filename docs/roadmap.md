# Roadmap

## Parallel Track: Playbook Capture

This track runs alongside all milestones. The goal is to document manual workflows now so they can be progressively automated as the framework matures.

- Document recurring tasks as structured playbooks in the instance data directory
- Use the `/capture-playbook` skill to record new workflows through conversation
- Use the `/review-playbooks` skill to refine, update, and identify automation opportunities
- Extract generalizable patterns into shared templates over time

Playbooks follow a lifecycle: manual process -> documented playbook -> Claude Code skill -> semi-automated with human oversight -> fully autonomous agent.

## Milestone 1: Foundation and Memory System

The prerequisite for everything else. Without persistent memory, nothing learns.

**Goals:**
- Define the memory schema (format, metadata fields, tags, scoring)
- Build the memory storage layer (read, write, search, update)
- Implement instance data separation (framework repo vs personal data volume)
- Set up the CLAUDE.md loading chain (framework instructions + personal overlay)
- Build memory injection so relevant memories load at session start
- Design the foundation layer (core values, principles, long-term goals in ~/.hobbs/foundation.md)
- Create `hobbs init` to scaffold instance data directory, including a guided conversation to co-create the initial foundation.md

**Memory metadata fields:**
- Content (the actual memory)
- Tags (domain, agent, topic)
- Created timestamp
- Last accessed timestamp
- Reinforcement count (how many times confirmed or referenced)
- Source context (what session or task produced this memory)
- Confidence indicator

**Memory scoring:**
- Recency decays over time
- Reinforcement counteracts decay
- Pruning candidates are low-recency, low-reinforcement entries

**Done when:** Hobbs stores memories across sessions, loads them at startup, and personal data lives cleanly outside the repo.

## Milestone 2: Memory Lifecycle Management

Keep the memory system healthy as it grows.

**Goals:**
- Implement reinforcement detection (recognize when a memory is reconfirmed)
- Implement conflict detection (flag when new info contradicts existing memory)
- Build tiered storage (active memory loaded at startup vs archive searched on demand)
- Build the pruning process (review, consolidate, summarize, archive)
- Add audit logging for memory operations

**Pruning strategy:**
- Active memory: loaded into context every session. Must stay small.
- Archive: not loaded automatically, but searchable when the agent recognizes it needs historical context.
- Summarized: groups of granular memories collapsed into summaries to reduce volume.

**Conflict resolution:**
- When new information contradicts an existing memory, the old memory is superseded, not deleted.
- The change history itself is informative ("used to prefer X, now prefers Y").

**Done when:** The memory system self-maintains. Old irrelevant memories fade, important ones persist, contradictions get resolved.

## Milestone 3: Agent Delegation Framework

Build the infrastructure for sub-agents with specialized capabilities.

**Goals:**
- Define the agent specification format (prompt template, allowed tools, memory filter tags)
- Build the agent registry (discover and load agent definitions)
- Build the delegation mechanism (select agent, load config + filtered memories, spawn task)
- Implement the feedback loop (sub-agent writes operational learnings back after task completion)
- Ship starter agent templates to validate the pattern

**Agent definition structure:**
- Prompt template (the agent's core instructions)
- Tool access list (what the agent is allowed to do)
- Memory tags (which memories to load from the shared pool)
- Operational config (learnings that accumulate over time, specific to this agent type)

**Memory model:**
- Foundation (core values, principles, goals) is always included in every delegation, never filtered
- One shared memory system for knowledge about the user, preferences, and context
- Agent-specific operational configs that accumulate learnings about task execution
- At delegation time, the agent receives: its prompt + foundation + filtered shared memories + its own operational config

**Done when:** Hobbs delegates tasks to sub-agents that run with their own prompt and filtered memory, and write learnings back when finished.

## Milestone 4: Secure Data Vault

Handle sensitive data (financial records, personal information, credentials) with appropriate protections.

**Goals:**
- Design the encryption scheme (age or SOPS, must work offline given network constraints)
- Build the vault storage layer (encrypt at rest, decrypt on access)
- Implement access control (which agents can access which vault entries)
- Add audit logging for all vault access
- Enforce boundaries so memory summaries cannot leak sensitive data into unencrypted storage

**Constraints:**
- Encryption must work without external key management services (network-restricted environment)
- The vault lives in instance data, never in the framework repo
- Sensitive data boundaries must be explicit: agents that access vault data must not write summaries of that data into general memory

**Done when:** Sensitive data is encrypted at rest, access is controlled and logged, and there is a clear wall between vault contents and general memory.

## Milestone 5: Task Management System

Structured task tracking for multi-step projects.

**Goals:**
- Define task schema (description, status, priority, dependencies, assigned agent)
- Build task persistence and history
- Implement project/epic grouping for related tasks
- Build the retrospective mechanism (capture what worked and what didn't after each task)
- Connect retrospectives into the memory system as learnings

**Done when:** Hobbs tracks multi-step projects, assigns work to sub-agents, and systematically learns from completed tasks.

## Milestone 6: User Experience and Onboarding

Make the framework usable by others.

**Goals:**
- Documentation for setup, configuration, and daily usage
- Polish the `hobbs init` experience
- Example agent definitions and sample workflows
- Configuration validation and helpful error messages
- Contribution guidelines

**Done when:** Someone can clone the repo, run init, and have a working instance without reading the source code.

## Future Considerations

These are not scheduled but will likely become relevant:

- **External integrations:** Each new API or SaaS tool requires a proxy allowlist entry and potentially a dedicated sub-agent.
- **Semantic search for memory:** Vector-based retrieval when file-based search hits its limits.
- **Multi-user support:** The architecture supports separate instances, but there is no collaboration model yet.
- **Playbook-to-agent pipeline:** Tooling to convert a mature playbook directly into an agent definition.
