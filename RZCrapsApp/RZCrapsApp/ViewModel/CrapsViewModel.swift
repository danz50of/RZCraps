//
//  CrapsViewModel.swift
//  RZCrapsApp
//
//  Created by Dan Zabinski on 7/2/26.
//
import Foundation
import Combine
import RZCrapsEngine

struct ResolutionSummary: Identifiable {
    let id = UUID()
    let outcome: DecisionOutcome
    let rolls: [RollLog]

    var title: String {
        switch outcome {
        case .pointMade(let p): return "Point Made: \(p)"
        case .sevenOut: return "Seven Out"
        default: return ""
        }
    }
}

final class CrapsViewModel: ObservableObject {
    @Published var lastRoll: DiceRoll?
    @Published var bankroll: Int = 1000
    @Published var phase: GamePhase = .comeOut
    @Published var currentCycleRolls: [RollLog] = []
    @Published var pendingResolution: ResolutionSummary?

    private let session: CrapsSession

    init() {
        self.session = CrapsSession(
            tableConfig: TableConfig(tableMinimum: 5, maxOddsMultiplier: 3),
            initialUnits: 1000
        )
        self.bankroll = session.currentBankrollUnits
        self.phase = session.currentPhase
    }

    var canRoll: Bool {
        session.canRoll
    }

    var hasActiveLineBet: Bool {
        session.hasActiveLineBet
    }

    func rollDice() {
        guard session.canRoll else { return }

        let roll = session.roll()
        lastRoll = roll
        bankroll = session.currentBankrollUnits
        phase = session.currentPhase
        currentCycleRolls = session.currentCycleInProgress?.rolls ?? []

        if let outcome = session.lastResolution {
            pendingResolution = ResolutionSummary(outcome: outcome, rolls: session.logCycles.last?.rolls ?? [])
        }
    }

    func placePassLine() {
        _ = session.placePassLine(units: 1)
        bankroll = session.currentBankrollUnits
    }

    func placeDontPass() {
        _ = session.placeDontPass(units: 1)
        bankroll = session.currentBankrollUnits
    }

    func placePlaceBet(number: Int) {
        _ = session.placePlaceBet(number: number, units: 1)
        bankroll = session.currentBankrollUnits
    }

    func acknowledgeResolution() {
        pendingResolution = nil
        currentCycleRolls = []
    }
}
