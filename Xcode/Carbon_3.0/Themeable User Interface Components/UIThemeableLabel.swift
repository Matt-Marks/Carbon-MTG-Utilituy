//
//  UIThemeableLabel.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/12/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UIThemeableLabel: UILabel {
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        updateAppearance(animated: false)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appearanceDidChange),
                                               name: .AppearanceDidChange,
                                               object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .light && UserPreferences.shouldUseSystemLightDarkMode {
                
                UserPreferences.appTheme = 0
                updateAppearance(animated: true)
            }
            if traitCollection.userInterfaceStyle == .dark && UserPreferences.shouldUseSystemLightDarkMode {
                
                UserPreferences.appTheme = UserPreferences.trueBlackDarkTheme ? 2 : 1
                updateAppearance(animated: true)
            }
        }
    }
    
}

// MARK: - AppearanceModifiable
extension UIThemeableLabel: AppearanceModifiable {
    
    func updateAppearance(animated: Bool) {
        if animated {
            
            // The text color of labels is not an animatable property.
            // We we have to use the transition method.
            UIView.transition(with: self,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.updateAppearance(animated: false)
            })
        } else {
            
            textColor = UserPreferences.appTheme == 0 ? .black : .white
        }
    }
    

    
    static func updateAppearance() {
        UIThemeableLabel.appearance().textColor = UserPreferences.appTheme == 0 ? .black : .white
    }
    
    @objc func appearanceDidChange() {
        updateAppearance(animated: true)
    }
}
