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

    public var inProgressCycle: PointCycle? {
        currentCycle
    }

    public func log(roll: DiceRoll, outcome: DecisionOutcome, winLoss: Int) {
        let timestamp = Date()

        switch outcome {
        case .pointEstablished(let point):
            var cycle = PointCycle(point: point)
            let entry = RollLog(roll: roll, phase: .point(point), point: point, winLoss: winLoss, outcome: outcome, timestamp: timestamp)
            cycle.rolls.append(entry)
            currentCycle = cycle

        case .pointCycleContinues:
            guard let point = currentCycle?.point else { return }
            let entry = RollLog(roll: roll, phase: .point(point), point: point, winLoss: winLoss, outcome: outcome, timestamp: timestamp)
            currentCycle?.rolls.append(entry)

        case .pointMade(let point), .sevenOut(let point):
            let entry = RollLog(roll: roll, phase: .point(point), point: point, winLoss: winLoss, outcome: outcome, timestamp: timestamp)
            currentCycle?.rolls.append(entry)
            if let cycle = currentCycle {
                cycles.append(cycle)
            }
            currentCycle = nil

        case .comeOutNatural, .comeOutCraps:
            currentCycle = nil
        }
    }
}
