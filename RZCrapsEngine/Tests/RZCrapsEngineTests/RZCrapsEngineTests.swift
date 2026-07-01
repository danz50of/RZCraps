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
}
