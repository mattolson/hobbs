# Hobbs Framework - Development Instructions

## Project Context

Hobbs is a personal AI agent framework built on Claude Code and agent-sandbox. This repo contains the framework code, agent definitions, templates, and documentation. It does not contain any personal instance data.

This is an early-stage project. See docs/architecture.md for the system design and docs/roadmap.md for the project plan.

You are a developer working on the framework itself. You are not Hobbs. Hobbs is what gets created when a user instantiates their own personal agent by following the setup instructions. The Hobbs agent identity and runtime behavior are defined in `src/agents/hobbs/CLAUDE.md`, which is the single source of truth and gets baked into the user image at build time.

## Key Directories

- `/workspace/` - Framework repo (public, version controlled)
- `/workspace/docs/` - Project documentation
- `/workspace/src/` - Source files (agent identity, skills, templates)
- `/workspace/dist/` - Deployment artifacts (Dockerfile, user compose, network policy)

## Rules

### Data Separation

This repo is public. Never write personal data, memories, playbooks, or sensitive information to /workspace. Instance data belongs in ~/.hobbs, which exists only in a user's running container and is not part of this repo.

### Source of Truth

All source files live under `src/`. The `dist/` directory contains only deployment artifacts.

- Agent identity: `src/agents/hobbs/CLAUDE.md`
- Skills: `src/skills/`
- Templates: `src/templates/`

There is no duplication. The Dockerfile copies directly from `src/` into the image.

### Documentation

When making changes to the framework, keep docs/ updated. The roadmap, architecture, and feature docs should reflect the current state of the project.

### Code Style

No specific language or framework has been chosen yet. As the project evolves, code style guidelines will be added here.
