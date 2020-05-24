//
//  AppearanceModifiable.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/12/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import Foundation
import UIKit

// All UIThemeable components are AppearanceModifiable
protocol AppearanceModifiable {
    
    // This static function sets the UIAppearance of the item.
    static func updateAppearance()
    
    // The instance function is used to change the look of the object to the
    // exact same look that is set in the UIAppearance of the object. This is
    // really only used on the UISettingsThemeAndAppearanceTableViewController
    // so it animates when the theme is changed.
    func updateAppearance(animated: Bool)

    // This is used in a selector method of the notification observation
    func appearanceDidChange()
}


