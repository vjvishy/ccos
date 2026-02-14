---
name: rules-engine
description: Audit, generate, optimize, and team-ready your CLAUDE.md rules files. Use when user says "/rules", "audit my rules", "optimize claude.md", "bootstrap rules", or wants to improve their Claude Code configuration. Provides audit → generate → optimize → ship phases for CLAUDE.md lifecycle management.
---

# Rules Engine

A skill for managing CLAUDE.md files across the full lifecycle: from blank project to team-shared, battle-tested rules.

## Why This Exists

Your CLAUDE.md is the single highest-leverage file in your Claude Code workflow. A good one means Claude nails tasks on the first try. A bad one means bloated context, wrong assumptions, and wasted tokens. Most developers either skip it entirely or let it grow into an unmanageable mess.

This skill fixes that.

## Core Workflow

```
/rules:audit → /rules:generate → /rules:optimize → /rules:ship
```

### Phase 1: Audit (`/rules:audit`)

**Purpose:** Analyze an existing CLAUDE.md and score it.

1. Read the current CLAUDE.md (root `.claude/` directory or project-level)
2. Check against the quality rubric (see below)
3. Score each dimension (0-10)
4. Identify the top 3 highest-impact improvements
5. Report total line count and estimated token cost

**Quality Rubric:**

| Dimension | What Good Looks Like | Weight |
|-----------|---------------------|--------|
| **Structure** | Top-to-bottom priority ordering; clear sections | 20% |
| **Conciseness** | Under 300 lines; no filler or boilerplate | 15% |
| **Architecture** | High-level tech stack, file structure, design patterns | 15% |
| **Validation** | Build commands, test commands, lint commands documented | 20% |
| **Domain Context** | Project-specific patterns, DSLs, conventions | 15% |
| **Anti-patterns** | "Never do X" rules for known failure modes | 10% |
| **Examples** | Code snippets showing correct patterns | 5% |

**Output:** Score card with actionable recommendations.

**Example output:**
```
## CLAUDE.md Audit Report

Overall Score: 6.2/10
Lines: 487 (⚠️ over 300 target)
Est. Token Cost: ~2,400 tokens per session

| Dimension        | Score | Issue                                    |
|------------------|-------|------------------------------------------|
| Structure        | 4/10  | No priority ordering; sections scattered |
| Conciseness      | 3/10  | 487 lines; 40% is generic boilerplate    |
| Architecture     | 8/10  | Good tech stack docs                     |
| Validation       | 2/10  | No build/test commands                   |
| Domain Context   | 7/10  | Custom DSL documented                    |
| Anti-patterns    | 6/10  | Some "never" rules, needs more           |
| Examples         | 5/10  | Only 1 code snippet                      |

Top 3 Fixes:
1. Add validation commands (build, test, lint) — biggest ROI
2. Cut 200 lines of boilerplate — reduces token waste
3. Reorder sections by priority — top = most important
```

### Phase 2: Generate (`/rules:generate`)

**Purpose:** Create a CLAUDE.md from scratch for a new or undocumented project.

1. Scan the codebase: package.json, Cargo.toml, Podfile, etc.
2. Identify tech stack, framework, language, build tools
3. Map directory structure (top 2 levels)
4. Detect existing lint/test/build configs
5. Generate CLAUDE.md following the template structure

**Template Structure (in priority order):**

```markdown
# Project Overview
[1-2 sentences: what this project is]

# Tech Stack
[Language, framework, key dependencies]

# Architecture
[High-level file structure, design patterns]

# Build & Validation
[Build commands, test commands, lint commands]
[This is the validation loop — critical for self-correcting AI]

# Code Conventions
[Naming, file organization, import patterns]

# Domain Rules
[Project-specific patterns, custom DSLs]

# Anti-Patterns
[Never do X — learned failure modes]

# Examples
[Code snippets showing correct patterns]
```

**Rules for generation:**
- Target 150-250 lines (leave room to grow)
- Top-to-bottom = most important to least important
- Every "always do X" should have a concrete example
- Every "never do X" should explain WHY
- Build/validation section is mandatory — never skip it
- Use trigger keywords for skills: "build the app", "run tests", "lint the code"

**Output:** A draft CLAUDE.md ready for user review.

### Phase 3: Optimize (`/rules:optimize`)

**Purpose:** Trim, reorganize, and sharpen an existing CLAUDE.md.

1. Run audit first (get baseline score)
2. Remove generic/boilerplate content the model already knows
3. Deduplicate rules that say the same thing differently
4. Reorder by priority (most-referenced rules go to top)
5. Add missing validation commands
6. Convert vague rules to concrete examples
7. Re-audit and show before/after scores

**Optimization Checklist:**
- [ ] Remove anything that's standard for the framework (Claude already knows React conventions)
- [ ] Remove file paths that are framework-default (`src/`, `public/`, etc.)
- [ ] Merge overlapping rules
- [ ] Add "never" rules for any recurring AI mistakes the user reports
- [ ] Ensure every section has at least one concrete code example
- [ ] Verify total is under 300 lines
- [ ] Check that trigger keywords exist for build/test/lint

**Output:** Optimized CLAUDE.md with before/after comparison.

### Phase 4: Ship (`/rules:ship`)

**Purpose:** Prepare the CLAUDE.md for team use (compound engineering).

1. Strip personal file paths (replace with relative paths)
2. Strip local-only configurations (personal MCPs, local directories)
3. Strip secrets or personal identifiers
4. Add team onboarding section at the bottom
5. Validate that rules are project-specific, not person-specific
6. Generate a brief changelog entry

**Team-readiness checklist:**
- [ ] No absolute paths (`/Users/vijay/...` → relative)
- [ ] No personal MCP references
- [ ] No machine-specific environment variables
- [ ] All examples use project-relative paths
- [ ] Onboarding section explains how to extend (not replace) rules
- [ ] File is under 300 lines

**Output:** Team-ready CLAUDE.md + changelog entry for PR description.

## Quick Commands

| Command | Use |
|---------|-----|
| `/rules:audit` | Score and analyze current CLAUDE.md |
| `/rules:generate` | Create CLAUDE.md from scratch for current project |
| `/rules:optimize` | Trim, reorder, and sharpen existing CLAUDE.md |
| `/rules:ship` | Strip personal info, prep for team commit |
| `/rules:quick` | Auto-detect: generate if missing, optimize if exists |
| `/rules:score` | Just show the score, no recommendations |

## Quick Mode (`/rules:quick`)

For when you just want it handled:

1. Check if CLAUDE.md exists
2. If missing → run generate
3. If exists → run audit, then optimize if score < 7
4. Show summary of what changed

## Integration with GSD

Rules Engine composes with GSD naturally:

- Before starting a GSD cycle, run `/rules:audit` to ensure Claude has good context
- After a GSD cycle where Claude made repeated mistakes, run `/rules:optimize` and add anti-pattern rules
- When shipping a feature to the team, run `/rules:ship` alongside your PR

## Integration with Second Brain (Future Layer 3)

When the Second Brain skill is available:
- `/rules:audit` can pull historical mistake patterns from the brain
- `/rules:generate` can use architecture decisions stored in the brain
- `/rules:optimize` can reference the brain for which rules are most-triggered

## Best Practices

### What Belongs in CLAUDE.md
- Project-specific conventions Claude wouldn't know
- Validation/build commands unique to your setup
- Anti-patterns learned from painful debugging sessions
- Domain-specific terminology and patterns
- Trigger keywords for custom workflows

### What Does NOT Belong in CLAUDE.md
- Standard framework conventions (Claude already knows these)
- Default file paths that every project has
- Generic coding best practices
- Personal preferences that don't affect code quality
- Long prose explanations (use examples instead)

### The Golden Rule
> If Claude would make the same mistake even WITH this rule, the rule is too vague.
> If Claude would never make this mistake WITHOUT this rule, the rule is wasted tokens.

### Maintenance Cadence
- **After every painful debugging session:** Add an anti-pattern rule
- **Weekly:** Run `/rules:audit` and check the score
- **Before PRs that touch CLAUDE.md:** Run `/rules:ship`
- **Never:** Manually edit CLAUDE.md — always ask Claude to update it
