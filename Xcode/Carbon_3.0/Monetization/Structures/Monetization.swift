//
//  MonetizationUtilities.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 1/28/19.
//  Copyright © 2019 Matt Marks. All rights reserved.
//

import Foundation
import UIKit

struct Monetization {
    
    public static func promptWithPremium(over controller: UIViewController) {
        let premium = CarbonProViewController()
        premium.modalTransitionStyle   = .coverVertical
        premium.modalPresentationStyle = .formSheet
        controller.present(premium, animated: true)
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
    
    struct ProductID {
        
        // Non-Consumables
        public static let CarbonPro         = "nanotube.carbon.pro"
        public static let Old_Infinity      = "nanotube.carbon.infinity"
        public static let Old_ForeverPack   = "nanotube.carbon.foreverpack"
        public static let Old_ProPack       = "nanotube.carbon.propack"
        public static let Old_SaveGames     = "nanotube.carbon.savegames"
        
        // Consumables
        public static let Tip_Appreciated   = "nanotbe.carbon.appreciatedTip"
        public static let Tip_Complimentary = "nanotbe.carbon.complimentaryTip"
        public static let Tip_Flattering    = "nanotbe.carbon.flatteringTip"
        public static let Tip_Generous      = "nanotbe.carbon.generousTip"
        public static let Tip_Noble         = "nanotbe.carbon.nobleTip"
        public static let Tip_Decorous      = "nanotbe.carbon.decorousTip"
        public static let Tip_Humbling      = "nanotbe.carbon.humblingTip"
    }
    
    public static let proProductIds: Set<String> = [ProductID.CarbonPro,
                                                    ProductID.Old_Infinity,
                                                    ProductID.Old_ForeverPack,
                                                    ProductID.Old_ProPack,
                                                    ProductID.Old_SaveGames]
    
    public static let tipProductIds: Set<String> = [ProductID.Tip_Appreciated,
                                                    ProductID.Tip_Complimentary,
                                                    ProductID.Tip_Flattering,
                                                    ProductID.Tip_Generous,
                                                    ProductID.Tip_Noble,
                                                    ProductID.Tip_Decorous,
                                                    ProductID.Tip_Humbling]
    
    public static let proStore = InAppPurchaseHelper(productIds: proProductIds)
    public static let tipStore = InAppPurchaseHelper(productIds: tipProductIds)
}
