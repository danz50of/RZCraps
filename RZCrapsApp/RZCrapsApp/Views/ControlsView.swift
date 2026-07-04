//
//  ControlsView.swift
//  RZCrapsApp
//
//  Created by Dan Zabinski on 7/2/26.
//
import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var viewModel: CrapsViewModel

    var body: some View {
        VStack(spacing: 16) {

            Button("Roll Dice") {
                viewModel.rollDice()
            }
            .buttonStyle(.borderedProminent)

            Divider().padding(.vertical)

            Button("Pass Line (1 unit)") {
                viewModel.placePassLine()
            }
            .buttonStyle(.bordered)

            HStack {
                Button("Place 6") { viewModel.placePlaceBet(number: 6) }
                Button("Place 8") { viewModel.placePlaceBet(number: 8) }
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
