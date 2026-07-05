//
//  Logger.swift
//  RZCrapsEngine
//
//  Created by Dan Zabinski on 6/30/26.
//
import Foundation

public final class Logger {
    public private(set) var cycles: [PointCycle] = []
    private var currentCycle: PointCycle?

    public init() {}

    public func log(roll: DiceRoll, phase: GamePhase, winLoss: Int) {
        let point: Int? = {
            if case .point(let p) = phase { return p }
            return nil
        }()

        let entry = RollLog(
            roll: roll,
            phase: phase,
            point: point,
            winLoss: winLoss,
            timestamp: Date()
        )

        if let p = point {
            if currentCycle == nil || currentCycle?.point != p {
                currentCycle = PointCycle(point: p)
            }
            currentCycle?.rolls.append(entry)
        }

        if roll.total == 7 || (point != nil && roll.total == point) {
            if let cycle = currentCycle {
                cycles.append(cycle)
            }
            currentCycle = nil
        }
    }
}
