//
//  OddsEngine.swift
//  RZCrapsEngine
//
//  Created by Dan Zabinski on 6/30/26.
//

public final class OddsEngine {

    public init() {}

    public func resolve(bets: [Bet], roll: DiceRoll, point: Int?) -> Int {
        var totalWin = 0

        for bet in bets {
            switch bet.type {
            case .passLine:
                totalWin += resolvePassLine(bet: bet, roll: roll, point: point)
            case .dontPass:
                totalWin += resolveDontPass(bet: bet, roll: roll, point: point)
            case .odds:
                totalWin += resolveOdds(bet: bet, roll: roll, point: point)
            case .place:
                totalWin += resolvePlace(bet: bet, roll: roll)
            case .buy:
                totalWin += resolveBuy(bet: bet, roll: roll)
            }
        }

        return totalWin
    }

    private func resolvePassLine(bet: Bet, roll: DiceRoll, point: Int?) -> Int {
        if point == nil {
            if roll.total == 7 || roll.total == 11 { return bet.amount }
            if [2,3,12].contains(roll.total) { return -bet.amount }
        } else {
            if roll.total == point { return bet.amount }
            if roll.total == 7 { return -bet.amount }
        }
        return 0
    }

    private func resolveDontPass(bet: Bet, roll: DiceRoll, point: Int?) -> Int {
        if point == nil {
            if roll.total == 7 || roll.total == 11 { return -bet.amount }
            if roll.total == 2 || roll.total == 3 { return bet.amount }
            return 0 // 12 is bar-12: push; 4,5,6,8,9,10 establish the point, no resolution yet
        } else {
            if roll.total == 7 { return bet.amount }
            if roll.total == point { return -bet.amount }
            return 0
        }
    }

    private func resolveOdds(bet: Bet, roll: DiceRoll, point: Int?) -> Int {
        guard let point = point else { return 0 }

        if roll.total == point {
            switch point {
            case 4,10: return bet.amount * 2
            case 5,9: return bet.amount * 3 / 2
            case 6,8: return bet.amount * 6 / 5
            default: return 0
            }
        }

        if roll.total == 7 { return -bet.amount }
        return 0
    }

    private func resolvePlace(bet: Bet, roll: DiceRoll) -> Int {
        guard let number = bet.number else { return 0 }

        if roll.total == number {
            switch number {
            case 4,10: return bet.amount * 9 / 5
            case 5,9: return bet.amount * 7 / 5
            case 6,8: return bet.amount * 7 / 6
            default: return 0
            }
        }

        if roll.total == 7 { return -bet.amount }
        return 0
    }

    private func resolveBuy(bet: Bet, roll: DiceRoll) -> Int {
        guard let number = bet.number else { return 0 }

        if roll.total == number {
            return bet.amount * 2
        }

        if roll.total == 7 { return -bet.amount }
        return 0
    }
}
