//
//  RZCrapsEngineTests.swift
//  RZCrapsEngine
//
//  Created by Dan Zabinski on 6/30/26.
//

import XCTest
@testable import RZCrapsEngine

final class RZCrapsEngineTests: XCTestCase {

    func testDiceRoll() {
        let dice = DiceService()
        let roll = dice.roll()
        XCTAssertTrue((1...6).contains(roll.die1))
        XCTAssertTrue((1...6).contains(roll.die2))
    }

    // MARK: - classifyDecision

    func testComeOutNaturalOn7And11() {
        XCTAssertEqual(classifyDecision(previousPhase: .comeOut, roll: DiceRoll(die1: 4, die2: 3)), .comeOutNatural) // 7
        XCTAssertEqual(classifyDecision(previousPhase: .comeOut, roll: DiceRoll(die1: 5, die2: 6)), .comeOutNatural) // 11
    }

    func testComeOutCrapsOn2_3_12() {
        XCTAssertEqual(classifyDecision(previousPhase: .comeOut, roll: DiceRoll(die1: 1, die2: 1)), .comeOutCraps(2))
        XCTAssertEqual(classifyDecision(previousPhase: .comeOut, roll: DiceRoll(die1: 1, die2: 2)), .comeOutCraps(3))
        XCTAssertEqual(classifyDecision(previousPhase: .comeOut, roll: DiceRoll(die1: 6, die2: 6)), .comeOutCraps(12))
    }

    func testPointEstablishedOn4_5_6_8_9_10() {
        for total in [4, 5, 6, 8, 9, 10] {
            let roll = DiceRoll(die1: 1, die2: total - 1)
            XCTAssertEqual(classifyDecision(previousPhase: .comeOut, roll: roll), .pointEstablished(total))
        }
    }

    func testSevenOutDuringPoint() {
        XCTAssertEqual(classifyDecision(previousPhase: .point(6), roll: DiceRoll(die1: 3, die2: 4)), .sevenOut(6))
    }

    func testPointMadeDuringPoint() {
        XCTAssertEqual(classifyDecision(previousPhase: .point(6), roll: DiceRoll(die1: 2, die2: 4)), .pointMade(6))
    }

    func testPointCycleContinuesOnNonResolvingRoll() {
        XCTAssertEqual(classifyDecision(previousPhase: .point(6), roll: DiceRoll(die1: 1, die2: 1)), .pointCycleContinues) // total 2
    }

    // MARK: - Don't Pass resolution (mirrors Pass Line)

    func testDontPassLosesOnComeOutNatural() {
        let odds = OddsEngine()
        let bet = Bet(type: .dontPass, number: nil, units: 1, amount: 5)
        XCTAssertEqual(odds.resolve(bets: [bet], roll: DiceRoll(die1: 5, die2: 6), point: nil), -5) // 11
        XCTAssertEqual(odds.resolve(bets: [bet], roll: DiceRoll(die1: 4, die2: 3), point: nil), -5) // 7
    }

    func testDontPassWinsOnComeOutCraps2Or3() {
        let odds = OddsEngine()
        let bet = Bet(type: .dontPass, number: nil, units: 1, amount: 5)
        XCTAssertEqual(odds.resolve(bets: [bet], roll: DiceRoll(die1: 1, die2: 1), point: nil), 5) // 2
        XCTAssertEqual(odds.resolve(bets: [bet], roll: DiceRoll(die1: 1, die2: 2), point: nil), 5) // 3
    }

    func testDontPassPushesOnBar12() {
        let odds = OddsEngine()
        let bet = Bet(type: .dontPass, number: nil, units: 1, amount: 5)
        XCTAssertEqual(odds.resolve(bets: [bet], roll: DiceRoll(die1: 6, die2: 6), point: nil), 0) // 12
    }

    func testDontPassWinsOnSevenOutLosesOnPointMade() {
        let odds = OddsEngine()
        let bet = Bet(type: .dontPass, number: nil, units: 1, amount: 5)
        XCTAssertEqual(odds.resolve(bets: [bet], roll: DiceRoll(die1: 4, die2: 3), point: 6), 5)  // seven-out
        XCTAssertEqual(odds.resolve(bets: [bet], roll: DiceRoll(die1: 2, die2: 4), point: 6), -5) // point made
    }

    // MARK: - Logger includes the point-establishing roll (regression test for the dropped-roll bug)

    func testLoggerIncludesPointEstablishingRollInCycle() {
        let logger = Logger()
        let establishingRoll = DiceRoll(die1: 2, die2: 4) // total 6
        logger.log(roll: establishingRoll, outcome: .pointEstablished(6), winLoss: 0)

        XCTAssertNotNil(logger.inProgressCycle)
        XCTAssertEqual(logger.inProgressCycle?.point, 6)
        XCTAssertEqual(logger.inProgressCycle?.rolls.count, 1, "the roll that established the point must appear in its cycle")
        XCTAssertEqual(logger.inProgressCycle?.rolls.first?.roll.total, 6)

        let continuingRoll = DiceRoll(die1: 1, die2: 1) // total 2
        logger.log(roll: continuingRoll, outcome: .pointCycleContinues, winLoss: 0)
        XCTAssertEqual(logger.inProgressCycle?.rolls.count, 2)

        let sevenOutRoll = DiceRoll(die1: 3, die2: 4) // total 7
        logger.log(roll: sevenOutRoll, outcome: .sevenOut(6), winLoss: -5)

        XCTAssertNil(logger.inProgressCycle, "cycle should close out after seven-out")
        XCTAssertEqual(logger.cycles.count, 1)
        XCTAssertEqual(logger.cycles.first?.rolls.count, 3, "all 3 rolls (establish, continue, seven-out) should be in the closed cycle")
    }

    // MARK: - CrapsSession gating and Don't Pass wiring

    func testCanRollRequiresLineBetOnComeOut() {
        let session = CrapsSession(tableConfig: TableConfig(tableMinimum: 5, maxOddsMultiplier: 3), initialUnits: 1000)
        XCTAssertFalse(session.canRoll)
        XCTAssertFalse(session.hasActiveLineBet)

        _ = session.placePassLine(units: 1)
        XCTAssertTrue(session.hasActiveLineBet)
        XCTAssertTrue(session.canRoll)
    }

    func testPlaceDontPassSatisfiesLineBetGate() {
        let session = CrapsSession(tableConfig: TableConfig(tableMinimum: 5, maxOddsMultiplier: 3), initialUnits: 1000)
        XCTAssertFalse(session.canRoll)
        _ = session.placeDontPass(units: 1)
        XCTAssertTrue(session.canRoll)
    }
}
