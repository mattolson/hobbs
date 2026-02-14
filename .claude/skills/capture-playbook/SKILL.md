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

When you have enough detail, write the playbook to ~/.hobbs/playbooks/ using a descriptive filename (kebab-case, .md extension). Use the template structure from /workspace/templates/playbook.md but adapt it to fit the task naturally. Not every section needs to be filled if it does not apply.

After writing the file, summarize what was captured and suggest areas that could be expanded in a future session.

$ARGUMENTS
