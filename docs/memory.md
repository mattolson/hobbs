# Memory System

## Overview

The memory system gives Hobbs persistent context across sessions. Without it, every session starts from zero. With it, the agent accumulates knowledge about you, your projects, your preferences, and how to work effectively on your behalf.

## Context Hierarchy

Context is organized in tiers, from most stable to most volatile:

### Foundation (~/.hobbs/foundation.md)

Core values, principles, and long-term goals. This is the most stable layer, changing on a timescale of years if at all. Foundation is:

- Always loaded into every session, including sub-agent delegations
- Never pruned or decayed automatically
- Changed only through explicit user action
- Small by nature (a single file)
- The lens through which all other context is interpreted

Foundation captures things like: what you are working toward in life, what principles guide your decisions, what you value in your work and relationships. These are not preferences (which are operational and shift with tools and context). They are the invariants that inform decisions across every domain.

During onboarding (`hobbs init`), one of the first interactions should be a conversation that produces the initial `foundation.md`. This is co-created between the user and Hobbs.

### Active Memory (~/.hobbs/memory/active/)

Current preferences, project context, recent learnings. Loaded at session start. Subject to scoring, reinforcement, and pruning.

### Archive (~/.hobbs/memory/archive/)

Historical context. Not loaded automatically. Searched on demand when the agent needs deeper history.

## What Gets Remembered

- **Preferences:** Communication style, technical opinions, tool choices, workflow habits
- **Project context:** Tech stacks, deployment targets, team structures, repo relationships
- **Task patterns:** Approaches that worked, approaches that failed, recurring problems
- **Operational learnings:** Per-agent knowledge about how to execute specific task types effectively

## Storage Format

Each memory is a Markdown file with YAML frontmatter for metadata:

```markdown
---
id: mem_20260214_001
tags: [preference, communication]
created: 2026-02-14T10:30:00Z
last_accessed: 2026-02-14T10:30:00Z
reinforced: 0
source: session/capture
supersedes: null
status: active
---

Prefers direct communication without pleasantries. Wants assumptions questioned
and reasoning challenged rather than affirmed.
```

## Metadata Fields

| Field | Description |
|-------|-------------|
| id | Unique identifier (timestamp-based) |
| tags | Categorization labels for filtering |
| created | When the memory was first captured |
| last_accessed | When the memory was last loaded into a session |
| reinforced | Number of times this memory has been confirmed or referenced |
| source | What produced this memory (session, task, playbook review) |
| supersedes | ID of an older memory this one replaces (for conflict resolution) |
| status | active, archived, or superseded |

## Scoring and Relevance

Memories are ranked by a combination of:

- **Recency:** More recent memories rank higher, with time-based decay
- **Reinforcement:** Each confirmation or reference increments the count, counteracting decay
- **Access frequency:** Memories that are loaded often are likely still relevant

A memory created a year ago with 20 reinforcements outranks a memory created yesterday with none. A memory from a year ago with zero reinforcements and no recent access is a pruning candidate.

The exact scoring formula will be refined through usage. Starting with qualitative LLM-based assessment during pruning is likely more effective than a rigid numeric formula, since the LLM can evaluate whether a memory is "still clearly important" in ways a score might miss.

## Tiered Storage

See the Context Hierarchy section above for foundation, active, and archive tiers.

### Summarized

When a group of related memories in the archive becomes large, they can be consolidated into a single summary. The originals are preserved but the summary replaces them in search results. Example: 15 separate memories about deployment preferences become one summary covering the key points.

## Memory Lifecycle

### Creation

During a session, the agent identifies information worth persisting. It writes a new memory file with appropriate tags and metadata. Memories can be created explicitly (user says "remember this") or implicitly (agent recognizes a pattern or preference).

### Reinforcement

When a future session encounters the same pattern, or the user reaffirms a preference, the agent updates the existing memory: increments the reinforcement count, updates the last_accessed timestamp. No new file is created.

### Conflict Resolution

When new information contradicts an existing memory, the old memory's status changes to "superseded" and the new memory's `supersedes` field references the old one. The history is preserved because the change itself is informative. Knowing that a preference shifted from X to Y is more useful than only knowing the current preference is Y.

### Pruning

A periodic review process (triggered manually or on a schedule) evaluates memories:

- Low-relevance entries (old, unreinforced, unaccessed) are moved to archive or deleted
- Related memories are consolidated into summaries
- Superseded chains are reviewed: if the history is no longer informative, old entries can be removed
- The active tier is kept within size bounds

## Sensitive Data Boundary

Memories must not contain sensitive data from the vault. If a task involves sensitive data, the memory should capture the *process* and *learnings* without reproducing the data itself.

Good: "Monthly expense categorization uses the following rules: ..."
Bad: "Spent $4,200 on AWS in January, categorized as infrastructure."

This boundary is enforced by convention and agent instructions, not by technical controls. The vault access documentation should make this explicit for any agent that touches sensitive data.

## Tags

Tags are free-form strings used to filter memories when loading context for a specific agent or task. Recommended conventions:

- Domain tags: `finance`, `code`, `infrastructure`, `personal`
- Type tags: `preference`, `project-context`, `pattern`, `operational`
- Agent tags: `hobbs`, `researcher`, `code-reviewer` (which agent created or uses this memory)
- Project tags: project-specific identifiers
