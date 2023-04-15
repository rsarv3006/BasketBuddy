//
//  SettingsViewShareButtons.swift
//  BasketBuddy
//
//  Created by Robert J. Sarvis Jr on 3/28/23.
//

import SwiftUI

struct SettingsViewShareButtons: View {
    @State private var isShareListViewVisible: Bool = false
    @State private var isImportShareViewVisible: Bool = false
    
    private let shareLinkUrl = URL(string: "https://apps.apple.com/us/app/basketbuddy/id6446040498")
    
    var body: some View {
        NavigationLink(destination: ImportShareListView(), isActive: $isImportShareViewVisible) {
            Button("Import Shared Items!", action: {
                isImportShareViewVisible.toggle()
            })
            .buttonStyle(.bordered)
        }
        
        NavigationLink(destination: ShareListView(), isActive: $isShareListViewVisible) {
            Button("Share Your List!", action: {
                isShareListViewVisible.toggle()
            })
            .buttonStyle(.bordered)
        }

        
        if let shareLinkUrl = shareLinkUrl {
            ShareLink("Share BasketBuddy!", item: shareLinkUrl)
                .buttonStyle(.bordered)
        }
    }
}

struct SettingsViewShareButtons_Previews: PreviewProvider {
    static var previews: some View {
        SettingsViewShareButtons()
    }
}
