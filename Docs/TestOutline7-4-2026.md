Absolutely, Dan — this is the perfect moment to pause and validate what you’ve built.  
Below is **a complete, ready‑to‑paste Test Plan**, including:

- Today’s date (July 4, 2026)  
- Clear instructions for someone *new to Xcode*  
- A structured test plan with outcomes sections  
- Only 2–3 iterations per test (as requested)  
- No regression focus — strictly functionality confirmation  

You can drop this directly into your `/docs` folder or paste into Word.

---

# 📄 **RZ Craps Test Plan — Functional Validation (July 4, 2026)**

```markdown
# RZ Craps — Functional Test Plan
Date: July 4, 2026  
Purpose: Confirm basic functionality of the RZCrapsEngine and RZCrapsApp before beginning Step 4 development.  
Scope: Light functional testing only — 2–3 iterations per test. No regression testing.

---

# 0. How to Run Tests (Beginner-Friendly Xcode Instructions)

## 0.1 Launch the App
1. Open **Xcode**.
2. In the left sidebar, select the project **RZCrapsApp**.
3. At the top, ensure the device selector says:
   - “iPhone 15 Pro (Simulator)” or any simulator device.
4. Press **Run** (the ▶️ button).

The simulator will launch and show your basic craps UI.

---

## 0.2 How to Trigger Rolls and Bets
Inside the simulator:
- Tap **Roll Dice** to roll.
- Tap **Pass Line (1 unit)** to place a Pass Line bet.
- Tap **Place 6** or **Place 8** to place place bets.

Bankroll and phase should update automatically.

---

## 0.3 How to View Logs (Optional)
Since logs aren’t in the UI yet, you can print them:

1. Open `CrapsViewModel.swift`
2. Add this inside `rollDice()` temporarily:

```swift
print(session.logCycles)
```

3. Run the app again — logs will appear in Xcode’s console.

---

# 1. Dice System Tests

## 1.1 Dice Value Range
**Goal:** Ensure dice values are always 1–6.

**Steps:**
1. Tap **Roll Dice** 3 times.
2. Record die1 and die2 values.

**Expected:**  
- die1 ∈ [1,6]  
- die2 ∈ [1,6]  
- total = die1 + die2  

**Outcome:**  
- Iteration 1:  
- Iteration 2:  
- Iteration 3:  

---

## 1.2 Randomness Smoke Test
**Goal:** Ensure rolls appear random.

**Steps:**
1. Roll 10 times.
2. Confirm no repeating pattern.

**Outcome:**  
- Notes:  

---

# 2. Game State Machine Tests

## 2.1 Come-Out Roll Behavior
**Goal:** Confirm correct come-out behavior.

**Steps (repeat 3 times):**
1. Place Pass Line bet.
2. Roll until:
   - 7/11 → win  
   - 2/3/12 → loss  
   - 4/5/6/8/9/10 → point established  

**Outcome:**  
- Iteration 1:  
- Iteration 2:  
- Iteration 3:  

---

## 2.2 Point Cycle Behavior
**Goal:** Confirm point cycle transitions.

**Steps:**
1. Establish a point.
2. Roll until:
   - Point hit → return to Come Out  
   - 7 → Seven-out → return to Come Out  

**Outcome:**  
- Iteration 1:  
- Iteration 2:  
- Iteration 3:  

---

# 3. Bankroll Tests

## 3.1 Bet Deduction
**Goal:** Confirm bankroll decreases when bets are placed.

**Steps:**
1. Note bankroll.
2. Place Pass Line.
3. Confirm bankroll decreases by table minimum.

**Outcome:**  
- Iteration 1:  
- Iteration 2:  

---

## 3.2 Win/Loss Resolution
**Goal:** Confirm bankroll updates correctly.

**Steps:**
1. Place Pass Line.
2. Roll until win or loss.
3. Confirm bankroll increases or decreases correctly.

**Outcome:**  
- Iteration 1:  
- Iteration 2:  
- Iteration 3:  

---

# 4. Odds Engine Tests

## 4.1 Pass Line Odds
**Goal:** Confirm correct payouts.

**Steps:**
1. Establish point.
2. Roll until point hit or seven-out.
3. Confirm payout matches rules.

**Outcome:**  
- Iteration 1:  
- Iteration 2:  

---

## 4.2 Place Bet Odds
**Goal:** Confirm correct place bet payouts.

**Steps:**
1. Place 6 or 8.
2. Roll until hit or seven-out.

**Outcome:**  
- Iteration 1:  
- Iteration 2:  

---

## 4.3 Unit Scaling
**Goal:** Confirm 6/8 rounding logic.

**Steps:**
1. Place 6 or 8.
2. Confirm bet amount = 6 units on a $5 table.

**Outcome:**  
- Iteration 1:  
- Iteration 2:  

---

# 5. Logging Tests

## 5.1 Point Cycle Logging
**Goal:** Confirm cycles are created and closed correctly.

**Steps:**
1. Establish point.
2. Roll several times.
3. Hit point or roll 7.
4. Check logs in console.

**Outcome:**  
- Iteration 1:  
- Iteration 2:  

---

## 5.2 Roll Log Integrity
**Goal:** Confirm each roll is logged correctly.

**Expected fields:**
- roll  
- phase  
- point  
- winLoss  
- timestamp  

**Outcome:**  
- Iteration 1:  
- Iteration 2:  

---

# 6. Strategy Tagging Tests

## 6.1 Tag Creation
**Goal:** Confirm strategy tags are stored.

**Steps:**
1. Add tag via ViewModel or direct engine call.
2. Print tags.

**Outcome:**  
- Iteration 1:  
- Iteration 2:  

---

# 7. SwiftUI Integration Tests

## 7.1 DiceView
**Goal:** Confirm dice update visually.

**Outcome:**  
- Iteration 1:  
- Iteration 2:  

---

## 7.2 BankrollView
**Goal:** Confirm bankroll updates visually.

**Outcome:**  
- Iteration 1:  
- Iteration 2:  

---

## 7.3 ControlsView
**Goal:** Confirm buttons trigger correct actions.

**Outcome:**  
- Iteration 1:  
- Iteration 2:  

---

# Summary
This test plan validates the core functionality of the RZ Craps Engine and SwiftUI app scaffold before beginning Step 4 (Advanced Feature Expansion).

```

---

If you want, I can also generate:

- A **QA checklist**  
- A **test results summary template**  
- A **Step 4 readiness report**  

Just tell me what you want next.