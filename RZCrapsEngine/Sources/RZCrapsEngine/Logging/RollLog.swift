//
//  RollLog.swift
//  RZCrapsEngine
//
//  Created by Dan Zabinski on 6/30/26.
//
import Foundation

public struct RollLog {
    public let roll: DiceRoll
    public let phase: GamePhase
    public let point: Int?
    public let winLoss: Int
    public let outcome: DecisionOutcome
    public let timestamp: Date
}
