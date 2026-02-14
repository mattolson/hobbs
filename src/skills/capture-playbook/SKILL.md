---
description: Document a manual workflow or recurring task as a structured playbook
---

You are helping the user document a workflow or recurring task as a structured playbook.

Your goal is to have a conversation that extracts the key details of a task the user performs, then produce a well-structured playbook document.

Start by asking the user to describe the task at a high level. Then dig into specifics through follow-up questions. Pay special attention to:

- The trigger: what causes them to do this task
- The exact steps, in order
- Where they make judgment calls vs follow a mechanical process
- What data or tools they need
- What the output looks like
- Whether sensitive data is involved
- Where automation could help and where human judgment is still needed

Be conversational. The user may be thinking out loud or describing things loosely. Help them structure their thoughts without being rigid about format.

When you have enough detail, write the playbook to ~/.hobbs/playbooks/ using a descriptive filename (kebab-case, .md extension). Use the template structure below but adapt it to fit the task naturally. Not every section needs to be filled if it does not apply.

## Playbook Template

```markdown
# [Task Name]

## Trigger

What causes this task? How often does it happen?
Is it scheduled, event-driven, or ad hoc?

## Inputs

What data, context, or access is needed before starting?

## Steps

1. Step one
2. Step two
3. ...

## Outputs

What is the end result? Where does it go? Who consumes it?

## Judgment Calls

Where are decisions made that are not purely mechanical?
What heuristics or rules of thumb apply?

## Sensitive Data

Does this task touch anything confidential?
What is the minimum access required?

## Automation Potential

Which steps could be automated today?
Which require human judgment and why?
What would need to change for full automation?

## Notes

Gotchas, edge cases, lessons learned.
```

After writing the file, summarize what was captured and suggest areas that could be expanded in a future session.

$ARGUMENTS
