//
//  String+CamelCase.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 10/5/19.
//  Copyright © 2019 Ken Krzeminski. All rights reserved.
//

import Foundation

extension String {

    func camelCaseToWords() -> String {
        return unicodeScalars.reduce("") {
            if CharacterSet.uppercaseLetters.contains($1) {
                if $0.count > 0 {
                    return ($0 + " " + String($1))
                }
            }
            return $0 + String($1)
        }
    }
}
