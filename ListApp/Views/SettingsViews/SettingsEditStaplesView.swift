//
//  SettingsEditStaples.swift
//  ListApp
//
//  Created by rjs on 1/5/22.
//

import SwiftUI
import GoogleMobileAds

struct SettingsEditStaplesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var store: Store
    
    @SectionedFetchRequest(sectionIdentifier: ListItemSort.default.section, sortDescriptors: ListItemSort.default.descriptors, predicate: NSPredicate(format: "isStaple = %@", NSNumber(value: true)), animation: .default)
    private var stapleItems: SectionedFetchResults<String, ListItem>

    @EnvironmentObject var selectedStore: SelectedStore
    @State var showAdd: Bool = false

    var body: some View {
        VStack {
            if !store.hasPurchasedAdsProduct {
                GADSettingsEditPantryBannerViewController()
                    .frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
            }
            ZStack {
                List {
                    ForEach(stapleItems) { section in
                        Section(header: Text(section.id).foregroundColor(Color.Theme.seaGreen)) {
                            ForEach(section) { item in
                                ListComponentItem(item: item, selectedItem: $selectedStore.selectedStaple)
                                    .listRowBackground(Color.Theme.seaGreen)
                                    .onTapGesture {
                                        if selectedStore.selectedStaple == item {
                                            selectedStore.selectedStaple = nil
                                        } else {
                                            selectedStore.selectedStaple = item
                                        }
                                    }
                            }
                        }
                    }
                }
                if stapleItems.isEmpty {
                    Spacer()
                        .background(Color.Theme.linen)
                }
            }
            .background(Color.Theme.linen)
            .scrollContentBackground(.hidden)
            .frame(maxWidth: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ListComponentBottomToolbar(selectedListItem: $selectedStore.selectedStaple, centerImageName: selectedStore.selectedStaple == nil ? "plus" : "note.text.badge.plus", leftButtonOnPress: {showAdd.toggle()}, middleButtonOnPress: {
                    if selectedStore.selectedStaple == nil {
                        showAdd.toggle()
                    } else if let staple = selectedStore.selectedStaple {
                        ListItem.makeItemVisible(staple)
                        selectedStore.selectedStaple = nil
                    }
                }, middleButtonOnSwipe: { value in
                    if value.translation.height < 0 && selectedStore.selectedStaple == nil {
                        showAdd.toggle()
                    }
                }, rightButtonOnPress: {
                    if let safeSelectedStaple = selectedStore.selectedStaple {
                        ListItem.makeNotVisible(safeSelectedStaple)
                        selectedStore.selectedStaple = nil
                    }})

                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("Pantry Staples")
                            .font(.headline)
                            .foregroundColor(Color.Theme.seaGreen)
                    }
                }

            }
            .sheet(isPresented: $showAdd) {
                AddItems(viewContext: viewContext, selectedItem: $selectedStore.selectedStaple, isStaple: true)
            }
        }
        .background(Color.Theme.linen)
    }
}
