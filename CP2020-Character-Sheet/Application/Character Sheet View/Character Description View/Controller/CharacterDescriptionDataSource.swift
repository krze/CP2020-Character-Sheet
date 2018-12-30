//
//  CharacterDescriptionDataSource.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 12/29/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import Foundation

final class CharacterDescriptionDataSource {
    private let model: CharacterDescriptionModel
    
    init(model: CharacterDescriptionModel) {
        self.model = model
        
        NotificationCenter.default.addObserver(self, selector: #selector(nameDidChange(notification:)), name: .nameAndHandleDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(roleDidChange(notification:)), name: .roleDidChange, object: nil)
    }
    
    func change(name: String, handle: String) {
        model.set(name: name, handle: handle)
    }
    
    @objc private func nameDidChange(notification: Notification) {
        
    }
    
    @objc private func roleDidChange(notification: Notification) {
        
    }
    
}
