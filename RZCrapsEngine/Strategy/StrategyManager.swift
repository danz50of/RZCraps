//
//  StrategyManager.swift
//  RZCrapsEngine
//
//  Created by Dan Zabinski on 6/30/26.
//

public final class StrategyManager {
    public private(set) var tags: [StrategyTag] = []

    public func addTag(name: String, notes: String?) {
        tags.append(StrategyTag(name: name, notes: notes))
    }
}
