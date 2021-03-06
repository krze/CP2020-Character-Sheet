//
//  DamageModifierDataSource.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/26/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Manages the status of the characters' damage modifiers in order to make UI updates to the DamageModifierViewCell
final class DamageModifierDataSource: EditorValueReciever {
    
    weak var model: DamageModel?
    weak var delegate: DamageModifierDataSourceDelegate?
    
    init(model: DamageModel) {
        self.model = model
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .damageDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .statsDidChange, object: nil)
    }
    
    /// Never gets called, the DamageModifierDataSource has no editor for now
    /// - Parameter values: _
    /// - Parameter completion: _
    func valuesFromEditorDidChange(_ values: [Identifier : AnyHashable], validationCompletion completion: @escaping ValidatedCompletion) {}
    
    func autofillSuggestion(for identifier: Identifier, value: AnyHashable) -> [Identifier : AnyHashable]? {
        return nil
    }
    
    @objc func refreshData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let model = self.model else { return }
            
            self.delegate?.bodyTypeDidChange(save: model.save, btm: model.btm)
            self.delegate?.damageDidChange(totalDamage: model.damage)
        }
    }
    
}
