//
//  InAppPurchaseHelper.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 1/17/19.
//  Copyright © 2019 Matt Marks. All rights reserved.
//

import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

extension Notification.Name {
    static let PurchaseNotification = Notification.Name("PurchaseNotification")
}

open class InAppPurchaseHelper: NSObject {
    
    // The products that will be used
    private let productIdentifiers: Set<ProductIdentifier>
    
    // Tracks which items have been purchased.
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    
    // Used by SKProductsRequest delegate to perform requests to Apple servers.
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    // Initialization
    public init(productIds: Set<ProductIdentifier>) {
        productIdentifiers = productIds
        
        // For each product identifier, we check if the value is stored in user defaults.
        // If it is, then the identifier is inserted into the purchasedProductIdentifiers set.
        // Later, we will add an indentifier to the set following a purchase.
        for productIdentifier in productIds {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
                print("Previously Purchased: \(productIdentifier)")
            } else {
                print("Not Purchased: \(productIdentifier)")
            }
        }
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    // Returns the formatted price for the given product.
    public static func priceString(_ product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle       = .currency
        formatter.locale            = product.priceLocale
        return formatter.string(from: product.price)
    }
}

// MARK: - StoreKit API
extension InAppPurchaseHelper {
    
    // Saves the user's completion handler for future execution.
    // Then creates and initiates a request via an SKProductsRequest object.
    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    // Creates a payment object using an SKProduct (retrieved form the Apple
    // server) to add to a payment queue. The code utilizes a singleton
    // SKPaymentQueue object called default().
    public func buyProduct(_ product: SKProduct) {
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // Returns true if the given product has been purchased.
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    // Some devices and accounts may not permit an in-app purchase. This can
    // happen for example, if parental controls are set to disallow it.
    // Apple requires this situation to be handled gracefully. If this returns
    // false, the buy button should show "Not Available".
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    // If the user deletes and re-installs the app or installs it on another
    // device, they need the ability to access previouslt purchased items.
    // As a purchase transaction observer, InAppPurchaseHelper is already being
    // notified when purchases have been restored. This reacts to the
    // notification by restoring the purchases.
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}

// MARK: - SKProductsRequestDelegate

// Used to get a list of products, their titles, descriptions, and prices from Apple's servers
extension InAppPurchaseHelper: SKProductsRequestDelegate {
    
    // Called when the list is succesfully retrieved. It recives an array of
    // SKProduct objects and passes them to the previously saved completion handler.
    // The handler reloads the table with new data. If a problem occurs,
    // request(_:dodFailWithError:) is called. In either case, when the request
    // finishes, both the request and the completion handler
    // are leared with clearRequestAndHandler().
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

// MARK: - SKPaymentTransactionObserver

// Payment verification is achieved by having the InAppPurchaseHelper observe
// transactions happening on the SKPaymentQueue. Before settings up
// InAppPurchaseHelper as an SKPaymentQueue transaction observer, the class must
// conform to the SKPaymentTransactionObserver protocol.
extension InAppPurchaseHelper: SKPaymentTransactionObserver {
    
    // This is the only method actually required for the protocol.
    // This is called when one or more transaction states change. This method
    // evaluates the state of each transaction in an array of updated
    // transactions and calls the relevant helper method: complete(transaction:),
    // restore(transaction:), or fail(transaction:).
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            default: ()
            }
        }
    }
    
    // If the transaction was completed, it adds to the set of purchases
    // and saves the identifier in UserDefaults. It alse posts a notification
    // with that transaction so any interested object in the app can listed for
    // it to do things like update the user interface. Finally in both cases
    // of success or failure it marks the transaction as finished.
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    // If the transaction was restored, it adds to the set of purchases
    // and saves the identifier in UserDefaults. It alse posts a notification
    // with that transaction so any interested object in the app can listed for
    // it to do things like update the user interface. Finally in both cases
    // of success or failure it marks the transaction as finished.
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        
        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        NotificationCenter.default.post(name: .PurchaseNotification, object: identifier)
    }
    
    
}
