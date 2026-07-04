//
//  CrapsViewModel.swift
//  RZCrapsApp
//
//  Created by Dan Zabinski on 7/2/26.
//
import Foundation
import RZCrapsEngine

final class CrapsViewModel: ObservableObject {
    @Published var lastRoll: DiceRoll?
    @Published var bankroll: Int = 1000
    @Published var phase: GamePhase = .comeOut

    private let session: CrapsSession

    init() {
        self.session = CrapsSession(
            tableConfig: TableConfig(tableMinimum: 5, maxOddsMultiplier: 3),
            initialUnits: 1000
        )
        self.bankroll = session.currentBankrollUnits
        self.phase = session.currentPhase
    }

    func rollDice() {
        let roll = session.roll()
        lastRoll = roll
        bankroll = session.currentBankrollUnits
        phase = session.currentPhase
    }

    func placePassLine() {
        _ = session.placePassLine(units: 1)
        bankroll = session.currentBankrollUnits
    }

    func placePlaceBet(number: Int) {
        _ = session.placePlaceBet(number: number, units: 1)
        bankroll = session.currentBankrollUnits
    }
}
