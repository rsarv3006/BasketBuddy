import SwiftUI

struct SettingsViewShareButtons: View {
    private let shareLinkUrl = URL(string: "https://apps.apple.com/us/app/basketbuddy/id6446040498")
    
    var body: some View {
        NavigationLink("Import Shared Items", destination: ImportShareListView())
            .buttonStyle(.bordered)

        NavigationLink("Share Your List!", destination: ShareListView())
            .buttonStyle(.bordered)

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
