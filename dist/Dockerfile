FROM ghcr.io/mattolson/agent-sandbox-claude:latest

USER root
RUN apt-get update && apt-get install -y --no-install-recommends sqlite3 && rm -rf /var/lib/apt/lists/*
USER dev

# Hobbs agent identity and skills
# Build context is the repo root: docker build -f dist/Dockerfile .
COPY --chown=dev:dev src/agents/hobbs/CLAUDE.md /home/dev/hobbs/.claude/CLAUDE.md
COPY --chown=dev:dev src/skills/ /home/dev/hobbs/.claude/skills/

# Templates available for reference inside the container
COPY --chown=dev:dev src/templates/ /home/dev/hobbs/templates/

# Startup script: links instance skills into a discoverable location
COPY --chown=dev:dev src/shell.d/ /home/dev/.config/agent-sandbox/shell.d/

# Create the workspace directory (mount point for user's shared directory)
RUN mkdir -p /home/dev/hobbs/workspace

WORKDIR /home/dev/hobbs/workspace
