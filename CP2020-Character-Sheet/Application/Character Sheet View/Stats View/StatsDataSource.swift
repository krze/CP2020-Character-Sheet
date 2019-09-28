//
//  StatsDataSource.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 1/1/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import UIKit

final class StatsDataSource: NSObject, EditorValueReciever {

    private let statsModel: StatsModel
    weak var delegate: StatsDataSourceDelegate?

    // TODO: Remove this when humanity loss is calculated by cyberwear
    var humanityLoss: Int {
        return statsModel.humanityLoss
    }
    
    init(statsModel: StatsModel) {
        self.statsModel = statsModel
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateStatsView), name: .statsDidChange, object: nil)
    }
    
    func valuesFromEditorDidChange(_ values: [Identifier : String], validationCompletion completion: @escaping (ValidatedEditorResult) -> Void) {
        let stats = Stats(int: values.statPoint(for: Stat.Intelligence.identifier()) ?? statsModel.value(for: Stat.Intelligence).baseValue,
                          ref: values.statPoint(for: Stat.Reflex.identifier()) ?? statsModel.value(for: Stat.Reflex).baseValue,
                          tech: values.statPoint(for: Stat.Tech.identifier()) ?? statsModel.value(for: Stat.Tech).baseValue,
                          cool: values.statPoint(for: Stat.Cool.identifier()) ?? statsModel.value(for: Stat.Cool).baseValue,
                          attr: values.statPoint(for: Stat.Attractiveness.identifier()) ?? statsModel.value(for: Stat.Attractiveness).baseValue,
                          luck: values.statPoint(for: Stat.Luck.identifier()) ?? statsModel.value(for: Stat.Luck).baseValue,
                          ma: values.statPoint(for: Stat.MovementAllowance.identifier()) ?? statsModel.value(for: Stat.MovementAllowance).baseValue,
                          body: values.statPoint(for: Stat.Body.identifier()) ?? statsModel.value(for: Stat.Body).baseValue,
                          emp: values.statPoint(for: Stat.Empathy.identifier()) ?? statsModel.value(for: Stat.Empathy).baseValue,
                          rep: values.statPoint(for: Stat.Reputation.identifier()) ?? statsModel.value(for: Stat.Reputation).baseValue)
        
        statsModel.set(baseStats: stats, humanityLoss: values.statPoint(for: "HU. LOSS") ?? statsModel.humanityLoss, validationCompletion: completion)
    }
    
    func refreshData() {
        updateStatsView()
    }
    
    @objc private func updateStatsView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let statsToDisplay = Stat.allCases
            var newValues = [Stat : (baseValue: Int, displayValue: Int)]()
            
            statsToDisplay.forEach { stat in
                newValues[stat] = self.statsModel.value(for: stat)
            }
            
            self.delegate?.statsDidUpdate(stats: newValues)
        }
        
    }
    
}

private extension Dictionary where Key == Identifier, Value == String {
    
    func statPoint(for identifier: Identifier) -> Int? {
        if let value = self[identifier] {
            return Int(value)
        }
        
        return nil
    }
}
