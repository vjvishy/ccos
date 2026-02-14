# CCOS — Claude Code OS

A composable skill suite for AI-native engineering teams. Each layer is independent but designed to work together.

```
Layer 4: Orchestration    → Multi-instance workflows (coming soon)
Layer 3: Memory           → Second Brain — context persistence across sessions
Layer 2: Rules            → Rules Engine — CLAUDE.md lifecycle management
Layer 1: Execution        → GSD — structured plan → execute → verify
```

## Why CCOS?

Claude Code is powerful, but most developers use it like a chat window — one session at a time, no persistent memory, no rules optimization, no structured workflow. CCOS changes that by giving you composable skills that stack on top of each other.

**Without CCOS:** Every session starts from scratch. Claude guesses your conventions. You re-explain the same context. You lose debugging breakthroughs overnight.

**With CCOS:** Claude knows your rules, remembers what you learned last session, follows a structured execution workflow, and gets it right on the first try.

## The Layers

### Layer 1: Execution — [GSD](https://github.com/gsd-build/get-shit-done)

Structured development workflow: `discuss → plan → execute → verify`. Atomic commits, scope control, clean git history.

*Maintained separately at [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done).*

### Layer 2: Rules — Rules Engine

Audit, generate, optimize, and ship your CLAUDE.md files.

```
/rules:audit     → Score your CLAUDE.md against a 10-dimension rubric
/rules:generate  → Create one from scratch for any project
/rules:optimize  → Trim, reorder, sharpen existing rules
/rules:ship      → Strip personal info, prep for team commit
```

Your CLAUDE.md is the highest-leverage file in your Claude Code workflow. A good one means Claude nails tasks on the first try. The Rules Engine ensures it stays lean, well-structured, and under 300 lines.

[Full documentation →](skills/rules-engine.md)

### Layer 3: Memory — Second Brain

Persist context across Claude Code sessions by extending GSD's PROJECT.md.

```
/brain:save      → Capture decisions, learnings, todos before closing
/brain:load      → Reload context at the start of a new session
/brain:prune     → Clean up stale items weekly
/brain:reflect   → Surface patterns across sessions monthly
/brain:note      → Quick mid-session capture to scratchpad
```

No more re-explaining. Every session starts smart.

[Full documentation →](skills/second-brain.md)

### Layer 4: Orchestration (Coming Soon)

Multi-instance workflows, session management, git worktrees, parallel development.

## Quick Start

### Install All Skills

```bash
# One-liner: install all CCOS skills globally
./install.sh
```

Or manually:

```bash
mkdir -p ~/.claude/skills
cp skills/rules-engine.md ~/.claude/skills/
cp skills/second-brain.md ~/.claude/skills/
```

### Install for a Specific Project

```bash
mkdir -p /path/to/project/.claude/skills
cp skills/rules-engine.md /path/to/project/.claude/skills/
cp skills/second-brain.md /path/to/project/.claude/skills/
```

### Daily Workflow

```
# Start of day
/brain:load                    → See where you left off

# Start a feature
/rules:audit                   → Make sure CLAUDE.md is solid
/gsd:discuss                   → Plan the feature with full context

# During development
/gsd:execute                   → Build it with atomic commits
/brain:note [quick thought]    → Capture without breaking flow

# End of feature
/gsd:verify                    → Confirm it works

# End of day
/brain:save                    → Persist what matters

# Weekly
/brain:prune                   → Keep memory lean
/rules:optimize                → Sharpen rules based on learnings
```

## How the Layers Compose

```
┌─────────────────────────────────────────────────────────┐
│                   Your Claude Code Session               │
│                                                          │
│  /brain:load ──→ context loaded                          │
│       │                                                  │
│  /rules:audit ──→ CLAUDE.md validated                    │
│       │                                                  │
│  /gsd:discuss ──→ plan with full context                 │
│       │                                                  │
│  /gsd:execute ──→ build with atomic commits              │
│       │                                                  │
│  /brain:note ──→ capture learnings mid-session           │
│       │                                                  │
│  /gsd:verify ──→ confirm it works                        │
│       │                                                  │
│  /brain:save ──→ persist decisions, todos, learnings     │
│       │                                                  │
│  Learnings tagged → RULE CANDIDATE                       │
│       │                                                  │
│  /rules:optimize ──→ absorb learnings into CLAUDE.md     │
└─────────────────────────────────────────────────────────┘
```

## Project Structure

```
ccos/
├── README.md                  # This file
├── LICENSE
├── install.sh                 # Install all skills globally
└── skills/
    ├── rules-engine.md        # Layer 2 — CLAUDE.md management
    └── second-brain.md        # Layer 3 — context persistence
```

## Contributing

Early-stage project. Key areas for contribution:

- **Layer 4 design** — multi-instance orchestration patterns
- **Framework-specific rule templates** — Next.js, Swift, Rust, Python
- **Integration patterns** — Notion, Linear, Jira via MCP
- **Session summary templates** — different project types

## License

MIT

## Credits

Inspired by the workflows described in [50 Claude Code Tips](https://youtu.be/mZzhfPle9QU) and built on top of the [GSD workflow](https://github.com/gsd-build/get-shit-done).
