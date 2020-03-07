//
//  SaveRollViewManager.swift
//  CP2020-Character-Sheet
//
//  Created by Kenneth Krzeminski on 1/13/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import UIKit

final class SaveRollViewManager {
    
    weak var damageModel: DamageModel?
    weak var delegate: SaveRollManagerDelegate?

    private var rolls = [SaveRoll]()
    
    func append(rolls: [SaveRoll]) {
        self.rolls.append(contentsOf: rolls)
    }
    
    @objc func resolveRolls(_ sender: UIButton) {
        var wasSuccessful = true
        var customText: String?
        for roll in rolls {
            // Skip if the resolution comes back as a success
            guard !roll.resolve() else { continue }
            
            wasSuccessful = false
            
            switch roll.type {
            case .Mortal:
                acceptDeath(sender)
                customText = SaveRollStrings.dead
            case .Stun:
                acceptStunned(sender)
                customText = SaveRollStrings.stunned
            }
            
            break
        }
        
        delegate?.saveResolved(with: sender, success: wasSuccessful, text: customText)
        
        damageModel?.clearSaveRolls(completion: { result in
            switch result {
            case .success(let validation):
                switch validation {
                case .valid(let completion):
                    completion()
                }
            case .failure(let violation):
                print(violation.helpText())
            }
        })
        
        rolls = [SaveRoll]()
    }
    
    @objc func dismiss(_ sender: UIButton)  {
        damageModel?.clearSaveRolls(completion: { result in
            switch result {
            case .success(let validation):
                switch validation {
                case .valid(let completion):
                    completion()
                    self.delegate?.saveResolved(with: sender, success: true, text: "Cleared All Rolls")
                }
            case .failure(let violation):
                print(violation.helpText())
            }
        })
    }
    
    @objc func acceptStunned(_ sender: UIButton)  {
        damageModel?.enter(livingState: .stunned, completion: defaultResolution(_:))
        delegate?.saveResolved(with: sender, success: false, text: "Goodnight!")
    }
    
    @objc func acceptDeath(_ sender: UIButton)  {
        damageModel?.enter(livingState: .dead0, completion: defaultResolution(_:))
        delegate?.saveResolved(with: sender, success: false, text: "Sweet Release!")
    }
    
    private func defaultResolution(_ result: ValidatedResult) {
        switch result {
        case .success(let validation):
            switch validation {
            case .valid(let completion):
                completion()
            }
        case .failure(let violation):
            print(violation.helpText())
        }
    }
    
}
