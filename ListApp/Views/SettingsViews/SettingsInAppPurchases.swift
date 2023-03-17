//
//  SettingsInAppPurchases.swift
//  BasketBuddy
//
//  Created by Robert J. Sarvis Jr on 3/8/23.
//

import SwiftUI
import StoreKit

struct SettingsInAppPurchases: View {
    @EnvironmentObject var store: Store
    @State var isPurchased: Bool = false
    @State var errorTitle = ""
    @State var isShowingError: Bool = false
    
    private let product: Product
    
    init(product: Product) {
        self.product = product
    }
    
    var body: some View {
        VStack {
            if !store.hasPurchasedAdsProduct {
                Button("Remove Ads - $1.99", action: {
                    Task {
                        await buy()
                    }
                })
                .buttonStyle(.bordered)
            }
            
            Button("Restore Purchases", action: {
                Task {
                    try? await AppStore.sync()
                }
            })
            .buttonStyle(.bordered)
        }
        .alert(isPresented: $isShowingError, content: {
            Alert(title: Text(errorTitle), message: nil, dismissButton: .default(Text("Okay")))
        })
    }
    
    func buy() async {
        do {
            if try await store.purchase(product) != nil {
                withAnimation {
                    isPurchased = true
                }
            }
        } catch StoreError.failedVerification {
            errorTitle = "Your purchase could not be verified by the App Store."
            isShowingError = true
        } catch {
            print("Failed purchase for \(String(describing: product.id)): \(error)")
        }
    }
}
