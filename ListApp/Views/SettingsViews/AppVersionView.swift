import SwiftUI

struct AppVersionView: View {
    var body: some View {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            Text("App version: \(appVersion)")
                .padding(.top)
                .foregroundColor(.Theme.seaGreen)
        } else {
            EmptyView()
        }
    }
}

struct AppVersionView_Previews: PreviewProvider {
    static var previews: some View {
        AppVersionView()
    }
}
