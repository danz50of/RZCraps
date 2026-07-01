public struct DiceRoll {
    public let die1: Int
    public let die2: Int
    public var total: Int { die1 + die2 }

    public init(die1: Int, die2: Int) {
        self.die1 = die1
        self.die2 = die2
    }
}

