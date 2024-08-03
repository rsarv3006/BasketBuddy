import SwiftUI

struct VersionChangesUpdateModal: View {
    let dismissCallback: () -> Void
    
    var body: some View {
        VStack{
            Text("Updates in this Version!")
                .font(.largeTitle)
                .foregroundColor(.Theme.seaGreen)
                .padding(.bottom)
            Text("We've added a widget! We've taken advantage of changes in the latest iOS 17 release to include a widget where you can see and mark things off your list without opening the app!")
                .foregroundColor(.Theme.seaGreen)
                .padding(.bottom)
            Spacer()
            Button("Good to know", action: dismissCallback)
                .buttonStyle(.bordered)
                .padding(.bottom)
        }
        .padding(.horizontal)
        .background(Color.Theme.linen)
    }
    
}


struct UIChangeMoveToBasketButton_Previews: PreviewProvider {
    static var previews: some View {
        VersionChangesUpdateModal {}
    }
}
