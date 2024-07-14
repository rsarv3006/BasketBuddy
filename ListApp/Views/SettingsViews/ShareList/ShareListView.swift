import SwiftUI
import UniformTypeIdentifiers

struct ShareListView: View {
    @EnvironmentObject var store: Store
    
    @SectionedFetchRequest(
        sectionIdentifier: ListItemSort.default.section,
        sortDescriptors: ListItemSort.default.descriptors,
        predicate: NSPredicate(format: "isVisible = %@", NSNumber(value: true)),
        animation: .default
    )
    private var listItems: SectionedFetchResults<String, ListItem>
    
    @State private var selectedItems: Set<ListItem> = []
    @State private var shouldPresentCopiedToClipboardAlert = false
    @State private var shouldPresentShareCodeAlert = false
    @State private var shareCode: String? = nil
    @State private var didShareCodeAttemptError = false
    @State private var shareCodeError: String? = nil
    
    var body: some View {
        VStack {
            Button(action: {
                if areAllItemsSelected(listItems, selectedItems) {
                    selectedItems.removeAll()
                } else {
                    listItems.forEach { section in
                        section.forEach { item in
                            self.selectedItems.insert(item)
                        }
                    }
                }
            }) {
                Text(listItems.count > 0 && selectedItems.count == getTotalItemsCount(listItems) ? "DeSelect All" : "Select All")
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .foregroundColor(Color.Theme.linen)
                    .background(Color.Theme.seaGreen)
                    .cornerRadius(12)
            }
            
            ZStack {
                List {
                    ForEach(listItems) { section in
                        Section(header: Text(section.id).foregroundColor(Color.Theme.seaGreen)) {
                            ForEach(section) { item in
                                ShareListRow(item: item, isSelected: self.selectedItems.contains(item)) {
                                    if self.selectedItems.contains(item) {
                                        self.selectedItems.remove(item)
                                    } else {
                                        self.selectedItems.insert(item)
                                    }
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                        }
                    }
                }
                .background(Color.Theme.linen)
                .scrollContentBackground(.hidden)
                .frame(maxWidth: .infinity)
                
                if listItems.isEmpty {
                    Spacer().background(Color.Theme.linen)
                }
            }
            
            HStack {
                Button {
                    UIPasteboard.general.setValue(buildItemsDisplayString(selectedItems), forPasteboardType: UTType.plainText.identifier)
                    shouldPresentCopiedToClipboardAlert = true
                } label: {
                    Text("Copy to Clipboard")
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .foregroundColor(Color.Theme.linen)
                        .background(Color.Theme.seaGreen)
                        .cornerRadius(12)
                }
                .alert("Copied to Clipboard", isPresented: $shouldPresentCopiedToClipboardAlert) {
                    Button("OK", role: .cancel) {}
                }
                
                Button {
                    Task {
                        do {
                            if selectedItems.count > 0 {
                                let itemsToShare = ShareService.convertListItemsToShareListDto(listItems: selectedItems)
                                shareCode = try await ShareService.createShare(items: itemsToShare)
                                shouldPresentShareCodeAlert = true
                            } else {
                                shareCodeError = "No items have been selected."
                                didShareCodeAttemptError = true
                            }
                            
                                
                        } catch {
                            shareCodeError = error.localizedDescription
                            didShareCodeAttemptError = true
                        }
                    }
                } label: {
                    Text("Share by Code")
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .foregroundColor(Color.Theme.linen)
                        .background(Color.Theme.seaGreen)
                        .cornerRadius(12)
                }
                .alert("Your code is \(shareCode ?? "")", isPresented: $shouldPresentShareCodeAlert) {
                    Button("OK") {
                    }
                    Button("Copy to Clipboard", role: .cancel) {
                        UIPasteboard.general.setValue("Someone has shared a BasketBudy list with you! Use the code \(shareCode ?? "") to access the list.", forPasteboardType: UTType.plainText.identifier)
                    }
                }
                .alert("Error encountered trying to share your list. Error: \(shareCodeError ?? "")", isPresented: $didShareCodeAttemptError) {
                    Button("OK", role: .cancel) {}
                }
            }
            .padding(.bottom)
        }
        .background(Color.Theme.linen)
    }
}
