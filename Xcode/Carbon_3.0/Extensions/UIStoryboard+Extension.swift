//
//  UIStoryboard+Extension.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/23/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    enum UIStoryboardIdentifier: String {
        case settingsMain = "UISettingsMainTableViewController"
        case premium = "Premium"
    }
    
    static func instantiateViewController(withIdentifier identifier: UIStoryboardIdentifier) -> UIViewController {
        let storyboard = UIStoryboard(name: identifier.rawValue, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier.rawValue)
        return controller
    }
}

