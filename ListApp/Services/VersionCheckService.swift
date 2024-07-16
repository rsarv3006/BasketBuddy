import SwiftUI

class VersionCheckService: ObservableObject {
    @Published var isOutdated = false
    private let configService: ConfigService
    
    init(configService: ConfigService = .shared) {
        self.configService = configService
    }
    
    @MainActor
    func checkVersion() async {
        guard let config = await configService.getConfig() else {
            isOutdated = false
            return
        }
        
        let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
        isOutdated = compareVersions(currentVersion, config.minAppVersion ?? "") == .orderedAscending
    }
    
    private func compareVersions(_ version1: String, _ version2: String) -> ComparisonResult {
        return version1.compare(version2, options: .numeric)
    }
}

struct VersionCheckViewModifier: ViewModifier {
    @StateObject private var versionCheckService = VersionCheckService()
    @State private var showUpdateAlert = false
    
    func body(content: Content) -> some View {
        content
            .task {
                await versionCheckService.checkVersion()
            }
            .onChange(of: versionCheckService.isOutdated) { isOutdated in
                showUpdateAlert = isOutdated
            }
            .alert("Update Required", isPresented: $showUpdateAlert) {
                Button("Update") {
                    if let url = URL(string: "itms-apps://apple.com/app/id<YOUR_APP_ID>") {
                        UIApplication.shared.open(url)
                    }
                }
            } message: {
                Text("A new version of the app is available. Please update to continue.")
            }
    }
}

extension View {
    func checkAppVersion() -> some View {
        self.modifier(VersionCheckViewModifier())
    }
}
