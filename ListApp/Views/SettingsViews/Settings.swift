//
//  Settings.swift
//  ListApp
//
//  Created by rjs on 12/29/21.
//

import SwiftUI
import GoogleMobileAds
import StoreKit

struct Settings: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var store: Store
    
    @State var isCategoriesViewVisible: Bool = false
    @State var isbasketHistoryViewVisible: Bool = false
    @State var isEditStaplesViewVisible: Bool = false
    @State var isStapleAlertVisible: Bool = false
    @State var isStapleLoadSuccess: Bool = false
    @State var isLegalViewVisible: Bool = false
    
    private let shareLinkUrl = URL(string: "https://apps.apple.com/us/app/basketbuddy/id6446040498")
    
    var body: some View {
        VStack {
            ScrollView {
                
                NavigationLink(destination: SettingsCategoriesView(), isActive: $isCategoriesViewVisible) {
                    Button("Categories", action: {
                        isCategoriesViewVisible.toggle()
                    })
                    .buttonStyle(.bordered)
                }
                NavigationLink(
                    destination: SettingsBasketHistoryView(viewContext: viewContext),
                    isActive: $isbasketHistoryViewVisible) {
                        Button("Basket History", action: {
                            isbasketHistoryViewVisible.toggle()
                        })
                        .buttonStyle(.bordered)
                    }
                NavigationLink(destination: SettingsEditStaplesView(), isActive: $isEditStaplesViewVisible) {
                    Button("Edit Pantry Staples", action: {
                        isEditStaplesViewVisible.toggle()
                    })
                    .buttonStyle(.bordered)
                    .padding(.top)
                }
                
                Button("Load Pantry Staples", action: {
                    isStapleLoadSuccess = ListItem.loadStaples(viewContext)
                    isStapleAlertVisible.toggle()
                })
                .buttonStyle(.bordered)
                .alert(isStapleLoadSuccess
                       ? "Loaded Staples successfully."
                       : "Issue encountered loading staples, please try again.", isPresented: $isStapleAlertVisible) {
                    Button("OK", role: .cancel) {}
                }
                
                NavigationLink(destination: SettingsLegalView(), isActive: $isLegalViewVisible) {
                    Button("Legal Information", action: {
                        isLegalViewVisible.toggle()
                    })
                    .buttonStyle(.bordered)
                    .padding(.vertical)
                }
                
                if let product = store.removeAdsProduct {
                    SettingsInAppPurchases(product: product)
                        .padding(.bottom)
                }
                
                if let shareLinkUrl = shareLinkUrl {
                    ShareLink("Share BasketBuddy!", item: shareLinkUrl)
                        .buttonStyle(.bordered)
                }
                
                Button("Contact Support", action: {
                    let webCrawlerObfuscation = "@incoming.gitlab.com"
                    let email = "contact-project+donutsahoy-listapp-32477383-issue-\(webCrawlerObfuscation)"
                    let subject = "Support Request"
                    
                    let urlString = "mailto:\(email)?subject=\(subject)"
                    let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                    
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                })
                .buttonStyle(.bordered)
                
                
            }
            if !store.hasPurchasedAdsProduct {
                Spacer()
                GADSettingsLargeRectangleBannerViewController()
                    .frame(width: GADAdSizeMediumRectangle.size.width, height: GADAdSizeMediumRectangle.size.height, alignment: .center)
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Settings")
                        .font(.headline)
                        .foregroundColor(Color.Theme.seaGreen)
                }
            }
        }
        .background(Color.Theme.linen)
    }
}
