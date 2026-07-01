//
//  GameStateMachine.swift
//  RZCrapsEngine
//
//  Created by Dan Zabinski on 6/30/26.
//
public final class GameStateMachine {
    public private(set) var phase: GamePhase = .comeOut

    public init() {}

    public func applyRoll(_ roll: DiceRoll) {
        switch phase {
        case .comeOut:
            if [4,5,6,8,9,10].contains(roll.total) {
                phase = .point(roll.total)
            }
        case .point(let point):
            if roll.total == 7 {
                phase = .comeOut
            } else if roll.total == point {
                phase = .comeOut
            }
        }
    }
}

