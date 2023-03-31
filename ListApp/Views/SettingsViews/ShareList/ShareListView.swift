//
//  ShareListView.swift
//  BasketBuddy
//
//  Created by Robert J. Sarvis Jr on 3/28/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct ShareListView: View {
    @SectionedFetchRequest(
        sectionIdentifier: ListItemSort.default.section,
        sortDescriptors: ListItemSort.default.descriptors,
        predicate: NSPredicate(format: "isVisible = %@", NSNumber(value: true)),
        animation: .default
    )
    private var listItems: SectionedFetchResults<String, ListItem>
    
    @State private var selectedItems: Set<ListItem> = []
    @State private var shouldPresentCopiedToClipboardAlert = false
    
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
                Text(listItems.count > 0 && selectedItems.count == listItems.count ? "DeSelect All" : "Select All")
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .foregroundColor(Color.Theme.linen)
                    .background(Color.Theme.seaGreen)
                    .cornerRadius(12)
            }
            
            
            List {
                ForEach(listItems) { section in
                    Section(header: Text(section.id).foregroundColor(Color.Theme.seaGreen)) {
                        ForEach(section) { item in
                            if let item = item {
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
            }
            .background(Color.Theme.linen)
            .scrollContentBackground(.hidden)
            .frame(maxWidth: .infinity)
            
            if listItems.isEmpty {
                Spacer().background(Color.Theme.linen)
            }
            
            Button {
                UIPasteboard.general.setValue(buildItemsDisplayString(selectedItems), forPasteboardType: UTType.plainText.identifier)
                shouldPresentCopiedToClipboardAlert = true
            } label: {
                Text("Copy Selections to Clipboard")
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .foregroundColor(Color.Theme.linen)
                    .background(Color.Theme.seaGreen)
                    .cornerRadius(12)
            }
            .alert("Copied to Clipboard", isPresented: $shouldPresentCopiedToClipboardAlert) {
                Button("OK", role: .cancel) {}
            }
        }
        .background(Color.Theme.linen)
    }
}
