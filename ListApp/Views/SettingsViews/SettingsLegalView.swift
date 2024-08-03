import SwiftUI

struct SettingsLegalView: View {
    
    private var termsAndConditions: some View {
        ScrollView {
            Text("Terms & Conditions")
                .font(.title)
                .foregroundColor(Color.Theme.seaGreen)
            
            Text(TermsAndConditions)
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
    
    private var privacyPolicy: some View {
        ScrollView {
            Text("Privacy Policy")
                .font(.title)
                .foregroundColor(Color.Theme.seaGreen)
            
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
    
    private var eula: some View {
        ScrollView {
            Text("EULA")
                .font(.title)
                .foregroundColor(Color.Theme.seaGreen)
            
            Text(EULAString)
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
                    Text("EULA")
                        .font(.headline)
                        .foregroundColor(Color.Theme.seaGreen)
                }
            }
        }
    }
    
    var body: some View {
        TabView {
            termsAndConditions
                .tabItem {
                    Text("Terms & Conditions")
                        .font(.largeTitle)
                        .foregroundColor(Color.Theme.seaGreen)
                }
            
            privacyPolicy
                .tabItem {
                    Text("Privacy Policy")
                        .font(.largeTitle)
                        .foregroundColor(Color.Theme.seaGreen)
                }
            
            eula
                .tabItem {
                    Text("EULA")
                        .font(.largeTitle)
                        .foregroundColor(Color.Theme.seaGreen)
                }
        }
    }
}

struct SettingsLegalView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsLegalView()
    }
}
