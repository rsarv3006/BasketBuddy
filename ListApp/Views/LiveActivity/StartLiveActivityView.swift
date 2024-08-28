import SwiftUI
import CoreData

struct StartLiveActivityView: View {
    @EnvironmentObject var viewModel: StartLiveActivityViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if viewModel.activityViewState?.activityState == .active {
                Button("End Shopping Live Activity") {
                    viewModel.onEndShoppingActivityButtonPressed(dismissTimeInterval: nil)
                }
                .buttonStyle(.bordered)
            } else {
                Button("Start Shopping Live Activity") {
                    viewModel.onStartShoppingActivityButtonPressed()
                }
                .buttonStyle(.bordered)
                .onAppear {
                    viewModel.loadImpendingBedtime()
                }
            }
            
            if let errorMessage = viewModel.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(Color.red)
                }
            }
        }
    }
}
