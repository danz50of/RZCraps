//
//  CrapsTableView.swift
//  RZCrapsApp
//
//  Created by Dan Zabinski on 7/2/26.
//
import SwiftUI
import RZCrapsEngine

struct CrapsTableView: View {
    @EnvironmentObject var viewModel: CrapsViewModel

    var body: some View {
        VStack(spacing: 30) {

            Text("Phase: \(phaseText(viewModel.phase))")
                .font(.title2)
                .padding(.top)

            DiceView(roll: viewModel.lastRoll)

            BankrollView(bankroll: viewModel.bankroll)

            ControlsView()
        }
        .padding()
    }

    private func phaseText(_ phase: GamePhase) -> String {
        switch phase {
        case .comeOut: return "Come Out"
        case .point(let p): return "Point: \(p)"
        }
    }
}
