//
//  Premium.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 1/17/19.
//  Copyright © 2019 Matt Marks. All rights reserved.
//

import Foundation
import UIKit

public struct CarbonProUtilities {
    
    public static func promptWithPremium(overController controller: UIViewController) {
        let premium = CarbonProViewController()
        premium.modalTransitionStyle   = .coverVertical
        premium.modalPresentationStyle = .formSheet
        controller.present(premium, animated: true)
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }
    
    public static let CarbonPro       = "nanotube.carbon.pro"
    public static let Old_Infinity    = "nanotube.carbon.infinity"
    public static let Old_ForeverPack = "nanotube.carbon.foreverpack"
    public static let Old_ProPack     = "nanotube.carbon.propack"
    public static let Old_SaveGames   = "nanotube.carbon.savegames"

    public static let helper = InAppPurchaseHelper(productIds: [CarbonPro,
                                                                Old_Infinity,
                                                                Old_ForeverPack,
                                                                Old_ProPack,
                                                                Old_SaveGames])
}
