//
//  DiceView.swift
//  RZCrapsApp
//
//  Created by Dan Zabinski on 7/2/26.
//
import SwiftUI
import RZCrapsEngine

struct DiceView: View {
    let roll: DiceRoll?

    var body: some View {
        HStack(spacing: 20) {
            Text("🎲 \(roll?.die1 ?? 0)")
                .font(.largeTitle)
            Text("🎲 \(roll?.die2 ?? 0)")
                .font(.largeTitle)
        }
        .padding()
    }
}
