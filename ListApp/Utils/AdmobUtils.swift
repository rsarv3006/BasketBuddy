//
//  AdmobUtils.swift
//  BasketBuddy
//
//  Created by Robert J. Sarvis Jr on 3/5/23.
//

import Foundation

struct AdmobAdUnitIds: Decodable {
    enum CodingKeys: String, CodingKey {
        case Banner_Home_Screen, Banner_Add_Item, Banner_Settings, Banner_Categories, Banner_Basket_History, Banner_Edit_Pantry
    }
    
    let Banner_Home_Screen: String
    let Banner_Add_Item: String
    let Banner_Settings: String
    let Banner_Categories: String
    let Banner_Basket_History: String
    let Banner_Edit_Pantry: String
}

private func getAdmobAdUnitIdFromPlist() -> AdmobAdUnitIds? {
    let url = Bundle.main.url(forResource: "AdMob", withExtension: "plist")!
    let data = try! Data(contentsOf: url)
    let decoder = PropertyListDecoder()
    return try? decoder.decode(AdmobAdUnitIds.self, from: data)
}

private let admobUnitIds = getAdmobAdUnitIdFromPlist()

func getAdmobUnitId(variant: AdmobAdUnitIds.CodingKeys) -> String {
    if let admobUnitIds = admobUnitIds {
        switch (variant) {
        case .Banner_Home_Screen:
            return admobUnitIds.Banner_Home_Screen
        case .Banner_Add_Item:
            return admobUnitIds.Banner_Add_Item
        case .Banner_Settings:
            return admobUnitIds.Banner_Settings
        case .Banner_Categories:
            return admobUnitIds.Banner_Categories
        case .Banner_Basket_History:
            return admobUnitIds.Banner_Basket_History
        case .Banner_Edit_Pantry:
            return admobUnitIds.Banner_Edit_Pantry
        }
    }
    return ""
}
