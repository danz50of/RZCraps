//
//  BankrollManager.swift
//  RZCrapsEngine
//
//  Created by Dan Zabinski on 7/1/26.
//

public final class BankrollManager {
    public private(set) var bankrollUnits: Int

    public init(initialUnits: Int = 1000) {
        self.bankrollUnits = initialUnits
    }

    public func canAfford(units: Int) -> Bool {
        return units <= bankrollUnits
    }

    public func applyWinLoss(unitsDelta: Int) {
        bankrollUnits += unitsDelta
    }

    public func reset(to units: Int = 1000) {
        bankrollUnits = units
    }
}
