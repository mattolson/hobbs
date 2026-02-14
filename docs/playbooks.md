# Playbooks

## Overview

Playbooks document recurring tasks and workflows. They serve two purposes: they are useful reference documents today, and they become specifications for agent automation tomorrow.

## Why Capture Playbooks

Every task you do manually contains implicit knowledge: what triggers it, what steps to follow, where judgment is needed, what the gotchas are. That knowledge exists only in your head until you write it down.

Capturing playbooks provides immediate value even before any automation exists:

- Consistency: follow the same steps each time instead of relying on memory
- Delegation: hand a playbook to someone (human or agent) and they can execute the task
- Improvement: reviewing a documented process makes inefficiencies visible
- Automation scoping: you can see exactly which steps are mechanical and which require judgment

## Playbook Location

Playbooks are instance data. They live in `~/.hobbs/playbooks/`, outside the framework repo. This is because most playbooks describe personal workflows involving specific tools, accounts, and data.

Generalizable patterns extracted from personal playbooks can be contributed to `/workspace/templates/` as reusable templates.

## Creating a Playbook

Use the `/capture-playbook` Claude Code skill. Provide a brief description of the task and the skill will guide you through a conversation to extract the details.

```
/capture-playbook monthly expense review
```

The skill writes the result to `~/.hobbs/playbooks/<task-name>.md`.

You can also create playbooks manually using the template at `/workspace/templates/playbook.md`.

## Playbook Structure

Each playbook covers:

- **Trigger:** What causes this task and how often it happens
- **Inputs:** Data, context, or access needed before starting
- **Steps:** The procedure in order
- **Outputs:** The end result and where it goes
- **Judgment calls:** Decisions that are not purely mechanical
- **Sensitive data:** Whether confidential information is involved
- **Automation potential:** Which steps could be automated and what would need to change
- **Notes:** Gotchas, edge cases, lessons learned

Not every section applies to every playbook. Use what fits.

## Reviewing and Updating

Use the `/review-playbooks` skill to:

- Review a specific playbook for completeness
- Update a playbook based on new experience
- Identify common patterns across playbooks
- Brainstorm automation opportunities
- Merge or split playbooks as workflows evolve

## The Automation Ladder

Playbooks progress through stages of automation:

1. **Manual:** You follow the documented steps yourself
2. **Assisted:** A Claude Code skill walks you through the steps, handling mechanical parts while you make judgment calls
3. **Supervised:** An agent executes the full workflow but pauses for your approval at key decision points
4. **Autonomous:** An agent handles the task end-to-end, reporting results when done

Not every playbook needs to reach stage 4. Some tasks benefit from human judgment at specific steps, and the goal is to automate the parts that don't need it while keeping you in the loop where it matters.

## From Playbook to Agent

When a playbook is mature and its automation potential is well understood, it can inform the creation of a sub-agent:

1. The playbook's steps become the agent's prompt template
2. The judgment calls section identifies where the agent needs decision-making heuristics or human checkpoints
3. The sensitive data section determines vault access requirements
4. The inputs and outputs sections define the agent's interface

This conversion is not automatic. It requires deliberate design work to translate a human-readable playbook into an effective agent specification.
