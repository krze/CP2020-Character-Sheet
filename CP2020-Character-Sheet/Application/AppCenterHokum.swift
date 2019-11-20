//
//  AppCenterHokum.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/19/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import AppCenter
import AppCenterCrashes

struct AppCenterHokum {
    
    static func initiateAppCenter() {
        if let path = Bundle.main.path(forResource: "AppCenterConfig", ofType: "plist"),
            let config = NSDictionary(contentsOfFile: path),
            let storeKey = config.value(forKey: "StoreKey") as? String {
            MSAppCenter.start(storeKey, withServices:[
                MSCrashes.self
            ])
        }
    }
    
}
