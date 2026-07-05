//
//  DecisionOutcome.swift
//  RZCrapsEngine
//

/// Classifies what a single roll means for the shooter's current decision,
/// replacing scattered `total == 7` checks with one source of truth used by
/// logging, bet-clearing, and popup triggers.
public enum DecisionOutcome: Equatable {
    case pointEstablished(Int)
    case comeOutNatural
    case comeOutCraps(Int)
    case pointMade(Int)
    case sevenOut(Int)
    case pointCycleContinues

    public var isResolution: Bool {
        switch self {
        case .comeOutNatural, .comeOutCraps, .pointMade, .sevenOut:
            return true
        case .pointEstablished, .pointCycleContinues:
            return false
        }
    }
}

public func classifyDecision(previousPhase: GamePhase, roll: DiceRoll) -> DecisionOutcome {
    switch previousPhase {
    case .comeOut:
        switch roll.total {
        case 7, 11: return .comeOutNatural
        case 2, 3, 12: return .comeOutCraps(roll.total)
        default: return .pointEstablished(roll.total)
        }
    case .point(let point):
        if roll.total == 7 { return .sevenOut(point) }
        if roll.total == point { return .pointMade(point) }
        return .pointCycleContinues
    }
}
