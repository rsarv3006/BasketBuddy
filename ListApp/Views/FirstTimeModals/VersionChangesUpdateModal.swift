import SwiftUI

struct VersionChangesUpdateModal: View {
    let dismissCallback: () -> Void
    
    var body: some View {
        VStack{
            Text("Updates in this Version!")
                .font(.largeTitle)
                .foregroundColor(.Theme.seaGreen)
                .padding(.bottom)
            Text("In the latest version when you share or recieve a list you can open it by clicking the link. This opens the share screen with the code already filled in to save you time!")
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
