//
//  InstalledCyberWare.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 6/19/20.
//  Copyright © 2020 Ken Krzeminski. All rights reserved.
//

import Foundation

/// Maintains the installed cyberware on the Edgerunner
final class InstalledCyberWare: Codable {
    
    private(set) var cyberBodyParts = [CyberBodyPart]()
    private(set) var cyberware = [Cyberware]()
    
    /// The total humanity loss of all parts
    func humanityLoss() -> Int {
        cyberware.reduce(0) { $0 + $1.humanityCost } + cyberBodyParts.reduce(0) { $0 + $1.humanityCost }
    }
    
    /// Add a new CyberBodyPart
    /// - Parameter newPart: The new part to add
    func add(_ newPart: CyberBodyPart) {
        if let index = cyberBodyParts.firstIndex(where: { $0.location == newPart.location }) {
            let removedPart = cyberBodyParts.remove(at: index)
            removedPart.equipped = .stored
        }
        
        cyberBodyParts.append(newPart)
        NotificationCenter.default.post(name: .humanityDidChange, object: nil)
    }
    
    /// Remove a specific CyberBodyPart
    /// - Parameter part: The part to remove
    func remove(_ part: CyberBodyPart) {
        guard cyberBodyParts.contains(where: { $0.uniqueID == part.uniqueID }) else {
            return
        }
        
        if let index = cyberBodyParts.firstIndex(where: { $0.uniqueID == part.uniqueID }) {
            let removedPart = cyberBodyParts.remove(at: index)
            removedPart.equipped = .stored
        }
        
        NotificationCenter.default.post(name: .humanityDidChange, object: nil)
    }
    
    /// Add Cyberware to the Edgerunner
    /// - Parameters:
    ///   - cyberware: The Cyberware to install
    ///   - location: The location, if associated with one
    func add(_ cyberware: Cyberware, toLocation location: CyberPartLocation?) {
        if let location = location {
            guard let part = cyberBodyParts.first(where: { $0.location == location }) else {
                return // This should result in a rule violation
            }
            
            part.install(cyberware)
        }
        else {
            self.cyberware.append(cyberware)
        }
        
        NotificationCenter.default.post(name: .humanityDidChange, object: nil)
    }
    
    /// Removes the cyberware
    /// - Parameter cyberware: The cyberware to remove
    func remove(_ cyberware: Cyberware) {
        
        if let index = self.cyberware.firstIndex(where: { $0.uniqueID == cyberware.uniqueID }) {
            self.cyberware.remove(at: index)
        }
        else if let part = cyberBodyParts.first(where: { $0.slottedEquipment.contains(where: { $0 == cyberware.uniqueID })}) {
            part.uninstall(cyberware)
        }
        
        cyberware.equipped = .stored
        
        NotificationCenter.default.post(name: .humanityDidChange, object: nil)
    }
}
