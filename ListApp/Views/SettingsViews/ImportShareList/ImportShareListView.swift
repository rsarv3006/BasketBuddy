import SwiftUI
import Combine

struct ImportShareListView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var shareCodeInput = ""
    @State private var codeErrorString = ""
    @State private var didImportError = false
    @State private var importErrorString = ""
    @State private var isButtonDisabled = false
    @State private var sharedItems: [ShareListItem] = []
    @State private var isLoading = false
    @Binding private var deeplinkTarget: DeeplinkManager.DeeplinkTarget?

    init(shareCodeId: String = "", deeplinkTarget: Binding<DeeplinkManager.DeeplinkTarget?> = .constant(nil)) {
        self._shareCodeInput = State(initialValue: shareCodeId)
        self._deeplinkTarget = deeplinkTarget
    }
    var body: some View {
        VStack (alignment: .center) {
            VStack {
                Text("Import Shared List")
                    .font(.title)
                    .foregroundColor(Color.Theme.seaGreen)
                
                ZStack {
                    TextField("Share Code", text: $shareCodeInput)
                        .autocorrectionDisabled(true)
                        .foregroundColor(Color.Theme.seaGreen)
                        .textFieldStyle(TextFieldDefaultBackgroundSeagreenBorder())
                        .textInputAutocapitalization(.characters)
                        .onChange(of: shareCodeInput, perform: { newValue in
                            codeErrorString = ""
                            shareCodeInput = newValue.filter({ character in
                                AllowedShareCodeCharacters.contains(character)
                            })
                            if newValue.count > 6 {
                                shareCodeInput = String(newValue.prefix(6))
                            }
                        })
                        .padding(.horizontal)
                        .padding(.horizontal)
                    
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                }

                
                if !codeErrorString.isEmpty {
                    Text(codeErrorString)
                        .font(.caption)
                        .foregroundColor(Color.Theme.redMunsell)
                }
                
                Button("Import List") {
                    Task {
                        do {
                            if shareCodeInput.count < 6 {
                                codeErrorString = "Share code must be 6 characters"
                                return
                            }
                            isButtonDisabled = true
                            isLoading = true

                            let getShareResult = try await ShareService.getShare(shareId: shareCodeInput)

                            sharedItems = getShareResult.data
                            isButtonDisabled = false
                            isLoading = false
                        } catch {
                            if error.localizedDescription.contains("Not Found") {
                                importErrorString = "Share code not found"
                            } else {
                                importErrorString = "Error importing list"
                            
                            }
                            didImportError = true
                            isButtonDisabled = false
                            isLoading = false
                        }
                    }
                }
                .disabled(shareCodeInput.count != 6 || isButtonDisabled)
                .buttonStyle(.bordered)
                .padding(.top)
                .alert(importErrorString, isPresented: $didImportError) {
                    Button("OK") {}
                }
            }
            
            if !sharedItems.isEmpty {
                ItemsToBeAddedView(itemsToBeAdded: $sharedItems)
            }
            
            Spacer()
        }
        .background(Color.Theme.linen)
        .navigationBarItems(leading: Group {
            if deeplinkTarget != nil {
                Button(action: {
                    deeplinkTarget = nil
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(Color.Theme.seaGreen)
                        Text("Back")
                            .foregroundColor(Color.Theme.seaGreen)
                    }
                }
            }
        })
    }
}

