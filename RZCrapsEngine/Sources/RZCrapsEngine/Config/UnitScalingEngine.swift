//
//  UnitScalingengine.swift
//  RZCrapsEngine
//
//  Created by Dan Zabinski on 7/1/26.
//

public final class UnitScalingEngine {
    private let config: TableConfig

    public init(config: TableConfig) {
        self.config = config
    }

    // 1 unit = table minimum for most bets
    // 6/8 place bets auto-round to multiples of 6 for clean payouts
    public func amountForPlace(number: Int, units: Int) -> Int {
        switch number {
        case 6, 8:
            let base = max(config.tableMinimum, 6)
            let rounded = ((base + 5) / 6) * 6 // round up to nearest multiple of 6
            return rounded * units
        case 5, 9, 4, 10:
            return config.tableMinimum * units
        default:
            return config.tableMinimum * units
        }
    }

    public func amountForBuy(number: Int, units: Int) -> Int {
        // For now: simple mapping, later add vig
        return config.tableMinimum * units
    }

    public func amountForPassLine(units: Int) -> Int {
        return config.tableMinimum * units
    }

    public func maxOddsAmount(forPassLineAmount passAmount: Int) -> Int {
        return passAmount * config.maxOddsMultiplier
    }
}
