---
name: orchestration
description: Multi-instance Claude Code session management, parallel development, and git worktree workflows. Use when user says "/orch", "parallel sessions", "worktree", "multi-instance", or wants to run multiple Claude Code sessions simultaneously. Provides spawn → monitor → merge → cleanup phases.
---

# Orchestration

A skill for managing multiple Claude Code sessions in parallel. This is the productivity multiplier — instead of waiting for one task to finish, you juggle multiple sessions like a Starcraft player.

## When You Need This

- You're blocked waiting for a long-running Claude Code task
- You want to work on two features simultaneously
- You need to test something in isolation without polluting your main session's context
- You're doing a large refactor that can be split into independent chunks

## Prerequisite: Git Worktrees

Running multiple Claude Code sessions on the **same project** requires git worktrees. Without them, two sessions editing the same files will create conflicts.

**What's a worktree?** Think of it as a lightweight clone. Same repo, same git history, but a separate working directory with its own branch. Like having two monitors showing different branches of the same codebase.

```
my-project/              # Main worktree (your normal directory)
my-project-wt-feature-a/ # Worktree for feature A
my-project-wt-feature-b/ # Worktree for feature B
```

Each worktree gets its own Claude Code session with its own context.

## Core Workflow

```
/orch:spawn → /orch:monitor → /orch:merge → /orch:cleanup
```

### Phase 1: Spawn (`/orch:spawn`)

**Purpose:** Set up a parallel session with its own worktree and branch.

1. Create a git worktree with a feature branch
2. Copy necessary config files (`.claude/`, `.env.local`, etc.)
3. Provide the terminal command to start Claude Code in the new worktree
4. Optionally pre-load context with `/brain:load`

**Spawn command:**
```bash
# What the skill generates for you:
git worktree add ../my-project-wt-feature-a -b feature/feature-a
cp .env.local ../my-project-wt-feature-a/
cp -r .claude ../my-project-wt-feature-a/
```

**After spawning, in a new terminal tab:**
```bash
cd ../my-project-wt-feature-a
claude
# Then: brain:load → gsd:discuss → work normally
```

**Rules for spawning:**
- Name worktrees with a `-wt-` prefix so they're easy to identify
- Always branch from `main` unless the work depends on another branch
- Copy `.env.local` and `.claude/` — don't symlink (avoids cross-session interference)
- Max 3-4 worktrees at a time — beyond that, context switching overhead exceeds the gains
- Each worktree should have ONE clear task — don't scope-creep parallel sessions

### Phase 2: Monitor (`/orch:monitor`)

**Purpose:** Track what's running across sessions.

1. List all active worktrees and their status
2. Show which branches have uncommitted work
3. Flag any that have been idle (no commits in 2+ hours)
4. Show session notes from each worktree's brain

**Monitor command runs:**
```bash
git worktree list
# Plus checks each worktree for recent git activity
```

**Monitor output format:**
```
## Active Sessions

| # | Worktree               | Branch              | Last Commit | Status      |
|---|------------------------|---------------------|-------------|-------------|
| 1 | my-project (main)      | main                | 10 min ago  | Active      |
| 2 | my-project-wt-feat-a   | feature/feature-a   | 5 min ago   | Active      |
| 3 | my-project-wt-feat-b   | feature/feature-b   | 3 hours ago | ⚠️ Idle     |

Suggestion: Session 3 has been idle for 3 hours. Consider running
/orch:cleanup on it or resuming work.
```

**Rules for monitoring:**
- Check in on parallel sessions every 30-60 minutes
- If a session is idle for 2+ hours, either resume or clean it up
- Don't let worktrees pile up — merge or discard promptly

### Phase 3: Merge (`/orch:merge`)

**Purpose:** Bring completed work from a worktree back into main.

1. Verify the worktree's branch is clean (all committed)
2. Run any validation (build, test, lint) in the worktree
3. Provide the merge commands
4. Flag potential conflicts with other active worktrees

**Merge workflow:**
```bash
# From your main worktree
git checkout main
git pull
git merge feature/feature-a
# Or create a PR if you prefer
git push origin feature/feature-a
# Then create PR on GitHub
```

**Rules for merging:**
- Always validate (build + test) in the worktree before merging
- If two worktrees touched the same files, merge one first, then rebase the other
- Use `/brain:save` in the worktree before merging so learnings are captured
- After merge, immediately clean up the worktree

### Phase 4: Cleanup (`/orch:cleanup`)

**Purpose:** Remove worktrees and branches that are done.

1. Save any brain context from the worktree (`/brain:save`)
2. Remove the worktree
3. Delete the local and remote branch if merged
4. Update monitor

**Cleanup commands:**
```bash
# Save context first (run inside the worktree's Claude Code session)
# brain:save

# Then from any terminal:
git worktree remove ../my-project-wt-feature-a
git branch -d feature/feature-a
git push origin --delete feature/feature-a
```

**Rules for cleanup:**
- Always `/brain:save` before cleaning up — don't lose learnings
- Verify the branch was merged before deleting
- If work was abandoned, still save a brain note explaining why

## Quick Commands

| Command | Use |
|---------|-----|
| `/orch:spawn` | Create a new worktree + branch for parallel work |
| `/orch:monitor` | Show status of all active sessions/worktrees |
| `/orch:merge` | Bring worktree work back into main |
| `/orch:cleanup` | Remove a finished worktree and branch |
| `/orch:quick` | Spawn a worktree for a quick isolated task |
| `/orch:status` | One-line summary of active worktrees |

## Quick Mode (`/orch:quick`)

For spawning a quick isolated session without full planning:

1. Auto-create worktree with timestamped branch name
2. Copy configs
3. Print the `cd` and `claude` commands to run
4. Auto-cleanup after merge

Good for: hotfixes, experiments, testing a risky approach without polluting main context.

## Session Management Patterns

### The Juggler (2-3 sessions)

Best for most developers. Run 2-3 sessions max:

```
Tab 1: Main feature work (your primary focus)
Tab 2: Secondary task (tests, docs, or small fix)
Tab 3: Experiment (try a risky approach, discard if bad)
```

**Terminal setup (iTerm2 / tmux):**
- Use named tabs: `Cmd+I` in iTerm2 to rename
- Switch with `Cmd+[number]` for tabs
- Name each tab with the task: "feat-a", "tests", "experiment"

### The Reviewer (2 sessions)

One session writes code, the other reviews:

```
Tab 1: Feature development (Claude writes code)
Tab 2: Code review (you read, Claude explains/audits)
```

### The Splitter (3+ sessions)

For large refactors that can be parallelized:

```
Tab 1: Refactor module A
Tab 2: Refactor module B
Tab 3: Update tests for both
```

Only works when modules are truly independent. If they share interfaces, do them sequentially.

## Notification Setup

So you know when a session finishes without watching it:

**macOS (iTerm2):**
```bash
# Add to your shell profile (~/.zshrc)
# Plays a sound when a long command finishes
claude && osascript -e 'display notification "Claude Code session done" with title "CCOS"'
```

**Or ask Claude Code directly:**
```
When you finish this task, output "🔔 DONE" so I notice
```

## Integration with Other Layers

### With GSD (Layer 1)
- Each worktree runs its own GSD cycle independently
- Use `/gsd:quick` for small parallel tasks
- Use `/gsd:discuss` → `/gsd:plan` for larger parallel features

### With Rules Engine (Layer 2)
- CLAUDE.md is copied to each worktree (not symlinked)
- If you improve rules in one worktree, manually copy to others
- Run `/rules:ship` before merging so rule improvements land in main

### With Second Brain (Layer 3)
- Each worktree has its own `.planning/brain/` directory
- Run `/brain:save` before `/orch:cleanup` — critical, don't lose learnings
- After merge, learnings from the worktree's brain should be consolidated into main's brain
- `/brain:load` in each worktree loads that worktree's context, not main's

## Best Practices

### Do
- Start with 2 sessions before trying 3+
- Give each session a single, clear task
- Name your terminal tabs so you know which is which
- Save brain context before cleaning up worktrees
- Merge and clean up promptly — stale worktrees create confusion

### Don't
- Don't run 5+ sessions — context switching overhead exceeds the gains
- Don't have two worktrees edit the same files simultaneously
- Don't forget to copy `.env.local` and `.claude/` when spawning
- Don't let worktrees pile up for days — merge or discard within 24 hours
- Don't symlink configs between worktrees — changes in one affect the other

### The Golden Rule
> Each parallel session should be something you'd happily wait 30 minutes for.
> If it takes less than 5 minutes, just do it in your current session.

### Adoption Path
1. **Week 1:** Try `/orch:spawn` once for a small isolated task
2. **Week 2:** Run 2 sessions simultaneously for a full day
3. **Week 3:** Experiment with 3 sessions and the Juggler pattern
4. **Beyond:** Find your natural limit (most people plateau at 3-4)
