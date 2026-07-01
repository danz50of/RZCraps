//
//  TableConfig.swift
//  RZCrapsEngine
//
//  Created by Dan Zabinski on 7/1/26.
//
public struct TableConfig {
    public let tableMinimum: Int      // e.g. 5, 10, 15
    public let maxOddsMultiplier: Int // e.g. 2, 3, 4

    public init(tableMinimum: Int = 5, maxOddsMultiplier: Int = 3) {
        self.tableMinimum = tableMinimum
        self.maxOddsMultiplier = maxOddsMultiplier
    }
}
