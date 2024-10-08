import Foundation
import StoreKit

let SmallTipId = "smallTip"

public enum StoreError: Error {
    case failedVerification
}

class Store: ObservableObject {
    var updateListenerTask: Task<Void, Error>? = nil
    
    @Published var smallTipInAppPurchase: Product? = nil
    @Published var hasPurchasedSmallTip: Bool = false
    
    
    init() {
        updateListenerTask = listenForTransactions()
        Task {
            await requestProducts()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    @MainActor
    func requestProducts() async {
        do {
            let storeProducts = try await Product.products(for: [SmallTipId])
            if storeProducts.count > 0 {
                let foundProduct = storeProducts[0]
                
                if foundProduct.type == .consumable, foundProduct.id == SmallTipId {
                    smallTipInAppPurchase = foundProduct
                }
            }
        } catch {
            print("Failed product request from the App Store server: \(error)")
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    @MainActor
    func updateCustomerProductStatus() async {
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                
                if transaction.productType == .nonConsumable, transaction.productID == SmallTipId {
                    hasPurchasedSmallTip = true
                }
            } catch {
                print("Failed to verify transactions")
            }
        }
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    
                    await self.updateCustomerProductStatus()
                    
                    await transaction.finish()
                } catch {
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            
            await updateCustomerProductStatus()
            
            await transaction.finish()
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
}
