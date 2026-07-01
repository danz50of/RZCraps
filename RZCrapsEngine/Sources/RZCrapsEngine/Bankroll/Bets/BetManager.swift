//
//  BetManager.swift
//  RZCrapsEngine
//
//  Created by Dan Zabinski on 6/30/26.
//

public final class BetManager {
    public private(set) var activeBets: [Bet] = []

    public init() {}

    public func place(_ bet: Bet) {
        activeBets.append(bet)
    }

    public func clearAll() {
        activeBets.removeAll()
    }
}
