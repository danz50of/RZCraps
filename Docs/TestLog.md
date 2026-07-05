# RZ Craps — Test Log

Running log of manual test findings, used to drive the next engineering iteration. This is separate from `TestOutline7-4-2026.md` (the scripted test plan) — this file is where actual results, bugs, and observations get recorded as you play-test.

## How to use this log

- Add one new `## Session: YYYY-MM-DD` section per testing sitting. Don't overwrite previous sessions — append below them, most recent last (or flip the order if you prefer newest-first, just stay consistent).
- One row per finding in that session's table.
- **Test ID** references the matching section in `TestOutline7-4-2026.md` (e.g. `2.2`) when the finding came from a scripted test. Use `Exploratory` if you found it just playing around.
- **Severity**: `Blocker` (breaks the rules / can't continue) · `Major` (wrong behavior, workaround exists) · `Minor` (edge case, cosmetic-adjacent) · `Cosmetic` (visual only)
- **Status**: `Open` · `Fixed` · `Won't Fix` · `Needs Repro`
- Carry any still-`Open` items into the **Backlog** section at the bottom so nothing gets lost between sessions.

---

## Session: 2026-07-05

**Build:** local working tree, post pass-line-gate / Don't Pass / roll-log / popup fix
**Tester:** Dan (initial verification pass, run jointly with Claude in the DZ Phone simulator)

| # | Area | Test ID | Steps to Reproduce | Expected | Actual | Severity | Status | Notes |
|---|------|---------|---------------------|----------|--------|----------|--------|-------|
| 1 | Betting gate | Exploratory | Launch app, tap Roll Dice on come-out with no bet placed | Roll Dice disabled until a line bet is placed | Was previously always enabled; now correctly disabled | Blocker | Fixed | Verified in simulator |
| 2 | Bet clearing | Exploratory | Place Pass Line, roll to a come-out craps (2, 3, or 12) | Bet resolves, clears, Roll Dice re-disables until re-bet | Previously bet stayed active and could resolve again on the next roll; now clears correctly | Blocker | Fixed | Verified with a come-out 2 |
| 3 | Point tracking / roll log | Exploratory | Place Pass Line, roll to establish a point, roll several more times | Every roll from point-establishment through resolution appears in the left-side log | Previously the point-establishing roll was silently dropped from the log; now appears as roll #1 | Major | Fixed | Verified: log showed "6+2=8, Point:8" as entry #1 |
| 4 | Resolution popup | Exploratory | Roll a point cycle through to seven-out | Popup appears summarizing all rolls, resets on OK | Popup showed "Seven Out — 8 → 10 → 9 → 7"; tapping OK cleared the log and returned to Come Out | — | Fixed | Matches requested UX |
| 5 | Don't Pass | Exploratory | Not yet play-tested | Don't Pass should win/lose as the mirror of Pass Line, push on come-out 12 | Button present and wired, logic unit-tested, not yet manually played through | — | Needs Repro | Play through a Don't Pass round next session |

### Fixed This Iteration (recap)
- Roll Dice now requires an active Pass Line or Don't Pass bet on come-out.
- `Don't Pass` betting added (win/lose mirrors Pass Line; pushes on bar-12).
- Bets now clear on **every** resolved decision (was previously only clearing on total 7, missing natural 11 wins and 2/3/12 craps losses).
- Roll log now includes the point-establishing roll instead of dropping it.
- Point-made / seven-out now shows an acknowledgment popup with the full roll sequence; instant come-out resolutions do not show a popup (by design).

---

## Session: 2026-07-05 - Manual 1

**Build:**  0.3.10.20260705
**Tester:**  DZ - Reviewing initial state after claude completion

| # | Area | Test ID | Steps to Reproduce | Expected | Actual | Severity | Status | Notes |
|---|------|---------|---------------------|----------|--------|----------|--------|-------|
| 01  | Betting     |  0001       |  place 1 unit betting.  Point established.  Point won.   | Should win 1 unit, plus receive additional unit back.  started at 980, bet 1 unit went to 975, won point, only receved 1 unit back, ending balance 980    expected 985     |  ending unit was 980      |  High   | Open | Confirmed this bug exists on the don't pass winning also.  It appears there is no payout logic, only receiving your bet back.  This might be best to look at in rev 5      |
| 02  | Betting     |  0002       | Can only place a 1 unit bet. place a pass or don't pass bet, only 1 unit allowed         | Should be able to add additional units until the dice are rolled for pass or don't pass        | button greys out after selection       |  High       |  Open      |      |
| 03  |      |   |   |   |   |    |      |   | 
| 04  |      |   |   |   |   |    |      |   | 
| 05  |      |   |   |   |   |    |      |   | 
| 06  |      |   |   |   |   |    |      |   | 
| 07  |      |   |   |   |   |    |      |   | 
| 08  |      |   |   |   |   |    |      |   | 
| 09  |      |   |   |   |   |    |      |   | 
| 10  |      |   |   |   |   |    |      |   | 
---

## Session: _(next testing date)_

**Build:**
**Tester:**

| # | Area | Test ID | Steps to Reproduce | Expected | Actual | Severity | Status | Notes |
|---|------|---------|---------------------|----------|--------|----------|--------|-------|
|   |      |         |                     |          |        |          |        |       |


---

## Backlog / Carried-Over Issues

_(Open items pulled forward from prior sessions. Update as items get fixed.)_

| # | Area | First Seen | Severity | Status | Notes |
|---|------|-----------|----------|--------|-------|
| 1 | Don't Pass | 2026-07-05 | — | Needs Repro | Play through win/lose/push scenarios manually |
