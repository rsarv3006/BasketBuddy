//
//  Main.swift
//  ListApp
//
//  Created by rjs on 12/29/21.
//

import SwiftUI
import GoogleMobileAds

struct Main: View {
    @Environment(\.presentationMode) var presentation
    @State private var showAdd = false
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var selectedStore: SelectedStore
    @EnvironmentObject var store: Store
    
    @AppStorage("shouldShowFirstStartModalForUIChangeMoveToBasketButtonPlacement") var firstTimeModal = true
    
    @SectionedFetchRequest(
        sectionIdentifier: ListItemSort.default.section,
        sortDescriptors: ListItemSort.default.descriptors,
        predicate: NSPredicate(format: "isVisible = %@", NSNumber(value: true)),
        animation: .default
    )
    private var listItems: SectionedFetchResults<String, ListItem>

    var body: some View {
        NavigationView {
            VStack {
                if !store.hasPurchasedAdsProduct {
                    GADHomeScreenBannerViewController()
                        .frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
                }
                ZStack {
                    ListComponent(listItems: listItems)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                NavigationLink(destination: Settings()) {
                                    Image(systemName: "gearshape")
                                        .foregroundColor(Color.Theme.seaGreen)
                                }
                                .frame(height: 96, alignment: .trailing)
                                // ^^ Workaroud, credit: https://stackoverflow.com/a/62209223/5421557
                            }
                            ListComponentBottomToolbar(
                                selectedListItem: $selectedStore.selectedListItem,
                                centerImageName: "plus",
                                leftButtonOnPress: {showAdd.toggle()},
                                middleButtonOnPress: {
                                    if selectedStore.selectedListItem == nil {
                                        showAdd.toggle()
                                    }
                                },
                                middleButtonOnSwipe: { value in
                                    if value.translation.height < 0 && selectedStore.selectedListItem == nil {
                                        showAdd.toggle()
                                    }
                                },
                                rightButtonOnPress: {
                                    if let safeSelectedItem = selectedStore.selectedListItem {
                                        ListItem.makeNotVisible(safeSelectedItem)
                                        selectedStore.selectedListItem = nil
                                    }},
                                shouldShowCenterButton: selectedStore.selectedListItem == nil
                            )
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                HStack {
                                    Text("BasketBuddy")
                                        .font(.headline)
                                        .foregroundColor(Color.Theme.seaGreen)
                                }
                            }
                        }
                        .onAppear {
                            selectedStore.selectedListItem = nil
                        }
                    if listItems.isEmpty {
                        Spacer().background(Color.Theme.linen)
                    }
                }
                .sheet(isPresented: $showAdd) {
                    AddItems(
                        viewContext: viewContext,
                        selectedItem: $selectedStore.selectedListItem
                    )
                }
                .sheet(isPresented: $firstTimeModal) {
                    UIChangeMoveToBasketButton {
                        firstTimeModal = false
                    }
                    .presentationDetents([.medium])
                }
            }
            .background(Color.Theme.linen)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
