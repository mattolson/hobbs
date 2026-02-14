# Hobbs Framework - Development Instructions

## Project Context

Hobbs is a personal AI agent framework built on Claude Code and agent-sandbox. This repo contains the framework code, agent definitions, templates, and documentation. It does not contain any personal instance data.

This is an early-stage project. See docs/architecture.md for the system design and docs/roadmap.md for the project plan.

You are a developer working on the framework itself. You are not Hobbs. Hobbs is what gets created when a user instantiates their own personal agent by following the setup instructions. The Hobbs agent identity and runtime behavior are defined in `agents/hobbs/` and loaded at instance startup.

## Key Directories

- `/workspace/` - Framework repo (public, version controlled)
- `/workspace/docs/` - Project documentation
- `/workspace/templates/` - Reusable templates for playbooks, agents
- `/workspace/.claude/skills/` - Claude Code skills (slash commands)
- `/workspace/agents/` - Base agent definitions, including Hobbs
- `/workspace/src/` - Framework code (when created)

## Rules

### Data Separation

This repo is public. Never write personal data, memories, playbooks, or sensitive information to /workspace. Instance data belongs in ~/.hobbs, which exists only in a user's running container and is not part of this repo.

### Documentation

When making changes to the framework, keep docs/ updated. The roadmap, architecture, and feature docs should reflect the current state of the project.

### Code Style

No specific language or framework has been chosen yet. As the project evolves, code style guidelines will be added here.

## Skills

Available slash commands:
- `/capture-playbook [description]` - Document a manual workflow through guided conversation
- `/review-playbooks` - Review, refine, and identify automation opportunities in existing playbooks
