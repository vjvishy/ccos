---
name: second-brain
description: Persistent context memory for Claude Code sessions. Extends GSD's PROJECT.md with memory sections that survive between sessions. Use when user says "/brain", "save context", "load context", "what did we learn", or wants to persist decisions, learnings, and todos across Claude Code sessions. Provides save → load → prune → reflect phases.
---

# Second Brain

A skill for persisting context across Claude Code sessions. Builds on GSD's PROJECT.md so you don't maintain two systems.

## The Problem

Every time you start a new Claude Code session, you lose:
- What you and Claude discussed and decided
- Debugging breakthroughs that took 30 minutes to figure out
- Todos you identified but didn't finish
- Architecture decisions and the reasoning behind them
- Patterns Claude kept getting wrong (and how you fixed them)

You end up re-explaining the same context over and over. The Second Brain fixes this by giving Claude a structured way to save and reload what matters.

## Core Principle: Save What You'd Repeat

If you'd have to re-explain it to Claude in the next session, it belongs in the brain. If Claude can figure it out from the codebase alone, it doesn't.

## Architecture

The Second Brain extends your existing `.planning/PROJECT.md` with new sections and adds a `.planning/brain/` directory for session-specific memory.

```
.planning/
├── PROJECT.md              # GSD's existing file (untouched sections)
│   ├── ... existing GSD sections ...
│   ├── ## Learnings         # NEW — gotchas, debugging wins, patterns
│   ├── ## Active Todos      # NEW — carried across sessions
│   └── ## Open Questions    # NEW — unresolved decisions
│
└── brain/
    ├── sessions/
    │   ├── 2026-02-14.md    # Today's session summary (auto-dated)
    │   ├── 2026-02-13.md    # Yesterday's session
    │   └── ...
    └── scratchpad.md        # Quick capture for mid-session notes
```

### What Lives Where

| Content | Location | Why |
|---------|----------|-----|
| Architecture decisions | PROJECT.md `Key Decisions` (existing GSD section) | Permanent, high-value |
| Learnings & gotchas | PROJECT.md `Learnings` (new section) | Permanent, prevents repeat mistakes |
| Active todos | PROJECT.md `Active Todos` (new section) | Persistent until completed |
| Open questions | PROJECT.md `Open Questions` (new section) | Persistent until resolved |
| Session summaries | `brain/sessions/YYYY-MM-DD.md` | Archival, lazy-loaded on demand |
| Quick mid-session notes | `brain/scratchpad.md` | Temporary, cleared on save |

## Core Workflow

```
/brain:save → /brain:load → /brain:prune → /brain:reflect
```

### Phase 1: Save (`/brain:save`)

**Purpose:** Capture what matters from the current session before you close it.

1. Scan the current conversation for:
   - Decisions made (add to PROJECT.md `Key Decisions` if not already there)
   - Bugs debugged and root causes found (add to `Learnings`)
   - Todos identified but not completed (add to `Active Todos`)
   - Questions raised but not answered (add to `Open Questions`)
   - Rules that should be in CLAUDE.md (flag for `/rules:optimize`)
2. Write a session summary to `brain/sessions/YYYY-MM-DD.md`
3. Update PROJECT.md sections
4. Clear `brain/scratchpad.md`

**Session summary format:**
```markdown
# Session: YYYY-MM-DD

## What We Did
- [1-2 sentence summary of each task/feature worked on]

## Decisions Made
- [Decision]: [Reasoning] → added to PROJECT.md

## Learnings
- [Gotcha/pattern discovered]: [How to avoid/use it]

## Unfinished
- [Todo carried to Active Todos in PROJECT.md]

## Next Session Should
- [Suggested starting point for next session]
```

**Rules for saving:**
- Keep each item to 1-2 lines max — this is a reference, not a journal
- Only save what Claude can't rediscover from the codebase alone
- Decisions without reasoning are useless — always include the WHY
- Todos must be actionable — "fix the thing" is not a todo
- If a learning belongs in CLAUDE.md as a rule, flag it with `→ RULE CANDIDATE`

**Output:** Updated PROJECT.md + session summary file.

### Phase 2: Load (`/brain:load`)

**Purpose:** Bring relevant context into a fresh Claude Code session.

1. Read PROJECT.md sections: `Active Todos`, `Learnings`, `Open Questions`
2. Summarize what's active and relevant
3. Do NOT load session history files by default (lazy-load only)
4. Present a brief status to the user

**Load output format:**
```
## Brain Loaded

**Active Todos (3):**
- [ ] Add error boundary to order form
- [ ] Fix decimal rounding in price calculations
- [ ] Write E2E test for checkout flow

**Recent Learnings (2 new):**
- Supabase RLS policies don't apply to service role key — always use anon key in client
- date-fns formatInTimeZone requires explicit timezone, defaults cause silent bugs

**Open Questions (1):**
- Should we support multiple payment methods or stay Zelle-only?

**Last session:** 2026-02-14 — worked on menu item CRUD, hit a Drizzle migration issue

Ready to continue. What are we working on?
```

**Rules for loading:**
- Never load full session history files automatically — they bloat context
- Only load the structured sections from PROJECT.md
- If the user asks "what did we do yesterday", THEN lazy-load that session file
- Keep the load output under 30 lines — it's a briefing, not a novel

### Phase 3: Prune (`/brain:prune`)

**Purpose:** Clean up stale context so the brain stays lean.

1. Review `Active Todos` — mark completed ones, archive or remove
2. Review `Learnings` — move any that are now in CLAUDE.md rules to an archive
3. Review `Open Questions` — resolve or escalate
4. Check session files older than 30 days — summarize and archive
5. Report what was pruned

**Pruning rules:**
- Completed todos → remove entirely (git history preserves them)
- Learnings that became CLAUDE.md rules → remove with note "→ now in CLAUDE.md"
- Resolved questions → move decision to `Key Decisions`, remove from `Open Questions`
- Session files > 30 days → keep only if referenced by active todos or learnings
- Target: PROJECT.md brain sections should stay under 50 lines total

**Output:** Summary of what was pruned + updated line counts.

### Phase 4: Reflect (`/brain:reflect`)

**Purpose:** Identify patterns across sessions to surface insights.

1. Read the last 5-10 session summaries
2. Identify recurring themes:
   - Same types of bugs appearing repeatedly → suggest a CLAUDE.md rule
   - Same todos carrying over for 3+ sessions → flag as blocked or deprioritized
   - Same questions staying open → suggest forcing a decision
3. Generate a brief reflection report

**Output:** Patterns found + recommended actions.

## Quick Commands

| Command | Use |
|---------|-----|
| `/brain:save` | Save current session context before closing |
| `/brain:load` | Load brain context at start of new session |
| `/brain:prune` | Clean up stale todos, learnings, questions |
| `/brain:reflect` | Analyze patterns across recent sessions |
| `/brain:note [text]` | Quick-capture a note to scratchpad mid-session |
| `/brain:todos` | Show only active todos |
| `/brain:status` | Show brain stats (items count, last save, staleness) |

## Quick Note (`/brain:note`)

For capturing something mid-session without interrupting flow:

```
/brain:note The Drizzle push command silently succeeds even when schema has errors — need to check DB state after
```

This appends to `brain/scratchpad.md` immediately. On next `/brain:save`, scratchpad items get sorted into the right sections.

## Integration with GSD

The Second Brain extends GSD, not replaces it:

- **GSD owns:** Requirements, milestones, validated specs, key decisions
- **Brain owns:** Session memory, learnings, active todos, open questions, scratchpad
- Both live in `.planning/` and share `PROJECT.md`

**Workflow integration:**
- Start of day: `/brain:load` → see where you left off
- Start a feature: `/gsd:discuss` → plan with full context
- Mid-session gotcha: `/brain:note` → capture it without losing flow
- End of feature: `/gsd:verify` → confirm it works
- End of session: `/brain:save` → persist what matters
- Weekly: `/brain:prune` → keep it lean

## Integration with Rules Engine

The brain feeds the rules engine:

- Learnings tagged `→ RULE CANDIDATE` can be batch-added via `/rules:optimize`
- `/brain:reflect` surfaces recurring issues that should become CLAUDE.md rules
- After `/rules:optimize` absorbs a learning, `/brain:prune` removes it from the brain

## Best Practices

### What Belongs in the Brain
- "We tried X and it didn't work because Y" — debugging context
- "We decided to use approach A over B because Z" — decision rationale
- "Still need to handle edge case where..." — unfinished work
- "Claude kept doing X, had to correct to Y" — AI correction patterns

### What Does NOT Belong in the Brain
- Code snippets (they live in the codebase)
- Full conversation transcripts (too bloated)
- Things the codebase itself documents (tests, comments, types)
- Generic knowledge Claude already has

### The Golden Rule
> If you'd spend more than 30 seconds re-explaining it to Claude, save it.
> If it takes less than 30 seconds, let Claude rediscover it.

### Maintenance Cadence
- **Every session end:** `/brain:save` (make it a habit)
- **Every session start:** `/brain:load` (automatic context)
- **Weekly:** `/brain:prune` to prevent bloat
- **Monthly:** `/brain:reflect` to catch patterns
