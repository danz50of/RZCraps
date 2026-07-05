# Craps Rules Fix: Betting Gate, Don't Pass, Roll Log, Resolution Popup

## Context

You've started manual testing and found the app doesn't enforce real craps rules: you can roll on come-out with no bet down, Don't Pass isn't wired up at all, and the point cycle doesn't feel tracked correctly. Digging into the code confirmed the point *is* tracked correctly in `GameStateMachine`, but three real bugs explain what you're seeing:

1. `CrapsViewModel.rollDice()` calls `session.roll()` unconditionally — nothing requires an active Pass Line/Don't Pass bet before a come-out roll.
2. `Logger.log` derives "which point cycle a roll belongs to" from the phase *before* the roll is applied, so the come-out roll that actually establishes the point is silently dropped from that cycle's log — this is almost certainly why it looked like the point wasn't being tracked.
3. `CrapsSession.roll()` only clears bets when `total == 7` or `total == point`. That misses a natural come-out **11** (pass line win) and come-out **2/3/12** (craps loss) — in those cases a resolved Pass Line bet silently stays active and can be paid/charged again on the next roll without you re-betting.

There's also no roll-log UI and no Don't Pass betting at all (confirmed: no `BetType` case, no payout logic, no button). This plan fixes all of it in one pass, per your direction to implement Don't Pass now and show the acknowledgment popup only for actual point cycles (point made / seven-out) — not for instant come-out naturals/craps.

## Design

Root-cause the bugs with one new engine-level classifier instead of patching each symptom separately. A single pure function figures out "what kind of roll was this" once per roll in `CrapsSession.roll()`, and logging, bet-clearing, and the popup-trigger all read off that one classification — eliminating the duplicated/inconsistent `total == 7 || ...` checks that caused bugs #2 and #3.

## Engine changes (`RZCrapsEngine/Sources/RZCrapsEngine/`)

**`Bets/BetType.swift`** — add `case dontPass` and make the enum `Equatable` (needed for the line-bet-active check below).

**New file `Session/DecisionOutcome.swift`** — the classifier:
```swift
public enum DecisionOutcome: Equatable {
    case pointEstablished(Int)   // come-out roll sets point (4,5,6,8,9,10)
    case comeOutNatural           // come-out 7 or 11
    case comeOutCraps(Int)       // come-out 2, 3, or 12
    case pointMade(Int)
    case sevenOut(Int)
    case pointCycleContinues

    public var isResolution: Bool { /* true for comeOutNatural/comeOutCraps/pointMade/sevenOut */ }
}

public func classifyDecision(previousPhase: GamePhase, roll: DiceRoll) -> DecisionOutcome
```
This mirrors the existing come-out/point logic already correctly implemented in `GameStateMachine`, just exposed as a reusable classification.

**`OddsEngine/OddsEngine.swift`** — add `resolveDontPass(bet:roll:point:)`, the mirror image of `resolvePassLine`:
- Come-out 7/11 → lose; come-out 2/3 → win; come-out 12 → push (bar-12, delta 0); point phase: seven-out → win, point made → lose.

**`Logging/RollLog.swift`** — add `outcome: DecisionOutcome` field for richer per-row display.

**`Logging/Logger.swift`** — fix the core bug: change `log(roll:phase:winLoss:)` to `log(roll:outcome:winLoss:)`. On `.pointEstablished(point)`, create the new `PointCycle` **and** append this roll to it in the same step (this is the fix — previously the establishing roll was dropped). On `.pointCycleContinues`, append to the existing cycle. On `.pointMade`/`.sevenOut`, append the final roll and move the cycle into `cycles`. On `.comeOutNatural`/`.comeOutCraps`, no cycle involved (matches existing behavior — only point cycles are logged). Add `inProgressCycle: PointCycle?` accessor for the live UI log.

**`Session/CrapsSession.swift`**:
- Add `placeDontPass(units:)`, mirroring `placePassLine` (same table-minimum scaling via existing `unitScaling.amountForPassLine`).
- Add `hasActiveLineBet: Bool` (any active `.passLine`/`.dontPass` bet) and `canRoll: Bool` (come-out requires `hasActiveLineBet`; point phase always rollable) — this is the engine-level fix for bug #1.
- Rewrite `roll()` to compute `classifyDecision(previousPhase:roll:)` once, pass it to `logger.log`, and clear bets via `betManager.clearAll()` when `outcome.isResolution` (fixes bug #3 — now covers all five terminal come-out totals, not just 7).
- Expose `lastResolution: DecisionOutcome?` (set only for `.pointMade`/`.sevenOut`, i.e. the cases that should trigger the popup per your answer) and `currentCycleInProgress: PointCycle?`.
- `resetSession` also clears `lastResolution`.

## App changes (`RZCrapsApp/RZCrapsApp/`)

**`ViewModel/CrapsViewModel.swift`**:
- `rollDice()` no-ops if `!session.canRoll`.
- Add `canRoll`, `hasActiveLineBet` passthroughs, `placeDontPass()`, `@Published currentCycleRolls: [RollLog]` (from `session.currentCycleInProgress`), `@Published pendingResolution: ResolutionSummary?` (set only when `session.lastResolution` is `.pointMade`/`.sevenOut`, using `session.logCycles.last?.rolls` as the roll list).
- `acknowledgeResolution()` clears `pendingResolution` and `currentCycleRolls`, called from the alert's OK button.
- New small `ResolutionSummary` struct (`Identifiable`, title text like "Point Made: 6" / "Seven Out") — lives in the app target since it's a presentation concern, not engine logic.

**`Views/ControlsView.swift`** — disable "Roll Dice" when `!viewModel.canRoll`; disable both "Pass Line" and new "Don't Pass" buttons when `viewModel.hasActiveLineBet` (can't change/duplicate your line bet mid-cycle).

**New file `Views/RollLogView.swift`** — left-side panel listing `viewModel.currentCycleRolls` (roll #, dice total, outcome label like "Point: 6" / "Seven Out"), scrollable, shows "No active point cycle" when empty.

**`Views/CrapsTableView.swift`** — wrap existing content in an `HStack` with `RollLogView` on the left; add `.alert(item: $viewModel.pendingResolution)` showing the title and a joined summary of roll totals, with the OK button calling `viewModel.acknowledgeResolution()`. Using `.alert` (not `.sheet`) since it's a short, blocking, single-action summary — matches "acknowledgement, basically a popup" and needs no rich per-row interaction.

## Verification

- Build and run via Xcode simulator (per your existing test plan doc).
- Manual pass: confirm Roll Dice is disabled until a Pass Line or Don't Pass bet is placed on come-out; confirm you can't place both/change the line bet mid-cycle; roll to a natural 11 win then immediately try betting again (previously the stale bet bug would double-resolve) — confirm bankroll only changes once and the button re-enables cleanly; establish a point and roll several times, confirming every roll (including the point-establishing one) appears in the left-side log; hit the point or seven-out and confirm the popup appears with the full roll list and only clears/resets after tapping OK; verify no popup appears for instant come-out naturals/craps.
- Run existing `RZCrapsEngineTests` to confirm no regressions (currently just a dice-range smoke test, unaffected by these changes).
