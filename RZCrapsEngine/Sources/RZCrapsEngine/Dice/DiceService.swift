import CryptoKit

public final class DiceService {
    public init() {}

    public func roll() -> DiceRoll {
        let die1 = Int.random(in: 1...6)
        let die2 = Int.random(in: 1...6)
        return DiceRoll(die1: die1, die2: die2)
    }
}

