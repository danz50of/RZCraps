//
//  Bet.swift
//  RZCrapsEngine
//
//  Created by Dan Zabinski on 6/30/26.
//

public struct Bet {
    public let type: BetType
    public let number: Int?
    public let units: Int
    public let amount: Int

    public init(type: BetType, number: Int?, units: Int, amount: Int) {
        self.type = type
        self.number = number
        self.units = units
        self.amount = amount
    }
}
