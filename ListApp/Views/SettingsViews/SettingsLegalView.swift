//
//  SettingsLegalView.swift
//  BasketBuddy
//
//  Created by Robert J. Sarvis Jr on 3/3/23.
//

import SwiftUI

struct SettingsLegalView: View {
    var body: some View {
        ScrollView {
            Text("Terms & Conditions")
                .font(.title)
                .foregroundColor(Color.Theme.seaGreen)
            
            Text(TermsAndConditions)
                .font(.title3)
                .foregroundColor(Color.Theme.seaGreen)
                .padding(.horizontal)
            
            Text("Privacy Policy")
                .font(.title)
                .foregroundColor(Color.Theme.seaGreen)
                .padding(.top)
            
            Text(PrivacyPolicy)
                .font(.title3)
                .foregroundColor(Color.Theme.seaGreen)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .background(Color.Theme.linen)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Legal")
                        .font(.headline)
                        .foregroundColor(Color.Theme.seaGreen)
                }
            }
        }
    }
}

struct SettingsLegalView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsLegalView()
    }
}
