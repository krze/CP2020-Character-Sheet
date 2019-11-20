//
//  AppCenterHokum.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/19/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import AppCenter
import AppCenterCrashes
import AppCenterDistribute

final class AppCenterHokum {
    
    func initiateAppCenter() {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let config = NSDictionary(contentsOfFile: path),
            let storeKey = config.value(forKey: "AppCenterKey") as? String {
            MSAppCenter.start(storeKey, withServices:[
                MSCrashes.self,
                MSDistribute.self
            ])
            
            MSDistribute.setEnabled(true)
        }
    }
    
}
