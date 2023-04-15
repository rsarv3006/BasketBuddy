//
//  plistHelpers.swift
//  BasketBuddy
//
//  Created by Robert J. Sarvis Jr on 4/7/23.
//

import Foundation

func getKeyValueFromPlist(plistFileName: String, key: String) -> String? {
    if let path = Bundle.main.path(forResource: plistFileName, ofType: "plist"),
       let dict = NSDictionary(contentsOfFile: path),
       let value = dict[key] as? String
    {
        return value
    }
    return nil
}

