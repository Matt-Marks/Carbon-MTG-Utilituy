//
//  PremiumLabel.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 1/17/19.
//  Copyright © 2019 Matt Marks. All rights reserved.
//

import UIKit

class CarbonProLabel: UILabel {

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        isHidden = UserPreferences.ownsPremium
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handlePurchaseNotification),
                                               name: .PurchaseNotification,
                                               object: nil)
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        isHidden = true
    }
    
}
