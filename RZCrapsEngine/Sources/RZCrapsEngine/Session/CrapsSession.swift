//
//  CrapsSession.swift
//  RZCrapsEngine
//
//  Created by Dan Zabinski on 7/1/26.
//

public final class CrapsSession {
    public let tableConfig: TableConfig
    public let bankrollManager: BankrollManager
    public let unitScaling: UnitScalingEngine

    private let diceService = DiceService()
    private let gameState = GameStateMachine()
    private let oddsEngine = OddsEngine()
    private let betManager = BetManager()
    private let logger = Logger()
    private let strategyManager = StrategyManager()

    public init(
        tableConfig: TableConfig = TableConfig(),
        initialUnits: Int = 1000
    ) {
        self.tableConfig = tableConfig
        self.bankrollManager = BankrollManager(initialUnits: initialUnits)
        self.unitScaling = UnitScalingEngine(config: tableConfig)
    }

    // MARK: - Strategy

    public func addStrategyTag(name: String, notes: String?) {
        strategyManager.addTag(name: name, notes: notes)
    }

    // MARK: - Betting API

    public func placePassLine(units: Int) -> Bool {
        let amount = unitScaling.amountForPassLine(units: units)
        guard bankrollManager.canAfford(units: amount) else { return false }

        let bet = Bet(type: .passLine, number: nil, units: units, amount: amount)
        betManager.place(bet)
        bankrollManager.applyWinLoss(unitsDelta: -amount)
        return true
    }

    public func placeOdds(onPoint point: Int, passLineAmount: Int) -> Bool {
        let maxOdds = unitScaling.maxOddsAmount(forPassLineAmount: passLineAmount)
        guard bankrollManager.canAfford(units: maxOdds) else { return false }

        let bet = Bet(type: .odds, number: point, units: 1, amount: maxOdds)
        betManager.place(bet)
        bankrollManager.applyWinLoss(unitsDelta: -maxOdds)
        return true
    }

    public func placePlaceBet(number: Int, units: Int) -> Bool {
        let amount = unitScaling.amountForPlace(number: number, units: units)
        guard bankrollManager.canAfford(units: amount) else { return false }

        let bet = Bet(type: .place, number: number, units: units, amount: amount)
        betManager.place(bet)
        bankrollManager.applyWinLoss(unitsDelta: -amount)
        return true
    }

    public func placeBuyBet(number: Int, units: Int) -> Bool {
        let amount = unitScaling.amountForBuy(number: number, units: units)
        guard bankrollManager.canAfford(units: amount) else { return false }

        let bet = Bet(type: .buy, number: number, units: units, amount: amount)
        betManager.place(bet)
        bankrollManager.applyWinLoss(unitsDelta: -amount)
        return true
    }

    // MARK: - Rolling

    public func roll() -> DiceRoll {
        let roll = diceService.roll()
        let previousPhase = gameState.phase

        gameState.applyRoll(roll)

        let point: Int? = {
            if case .point(let p) = previousPhase { return p }
            return nil
        }()

        let winLossAmount = oddsEngine.resolve(
            bets: betManager.activeBets,
            roll: roll,
            point: point
        )

        bankrollManager.applyWinLoss(unitsDelta: winLossAmount)

        logger.log(
            roll: roll,
            phase: previousPhase,
            winLoss: winLossAmount
        )

        // Clear resolved bets on seven-out or point hit
        if roll.total == 7 || (point != nil && roll.total == point) {
            betManager.clearAll()
        }

        return roll
    }

    // MARK: - Session Control

    public func resetSession(initialUnits: Int = 1000) {
        bankrollManager.reset(to: initialUnits)
        betManager.clearAll()
    }

    // MARK: - Accessors

    public var currentPhase: GamePhase {
        gameState.phase
    }

    public var currentBankrollUnits: Int {
        bankrollManager.bankrollUnits
    }

    public var logCycles: [PointCycle] {
        logger.cycles
    }
}
