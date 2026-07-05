//
//  RollLogView.swift
//  RZCrapsApp
//
import SwiftUI
import RZCrapsEngine

struct RollLogView: View {
    let rolls: [RollLog]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Roll Log").font(.headline)

            if rolls.isEmpty {
                Text("No active point cycle").foregroundStyle(.secondary)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(Array(rolls.enumerated()), id: \.offset) { index, log in
                            HStack {
                                Text("#\(index + 1)")
                                    .frame(width: 30, alignment: .leading)
                                    .foregroundStyle(.secondary)
                                Text("\(log.roll.die1) + \(log.roll.die2) = \(log.roll.total)")
                                Spacer()
                                Text(label(for: log.outcome))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .frame(minWidth: 180)
    }

    private func label(for outcome: DecisionOutcome) -> String {
        switch outcome {
        case .pointEstablished(let p): return "Point: \(p)"
        case .pointCycleContinues: return "—"
        case .pointMade: return "Point Made"
        case .sevenOut: return "Seven Out"
        case .comeOutNatural: return "Natural"
        case .comeOutCraps: return "Craps"
        }
    }
}
