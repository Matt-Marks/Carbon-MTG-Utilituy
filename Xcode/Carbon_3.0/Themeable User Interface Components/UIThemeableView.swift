//
//  UIThemeableView.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/12/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UIThemeableView: UIView {
    
    
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
extension UIThemeableView: AppearanceModifiable {
    
    func updateAppearance(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: [.beginFromCurrentState, .allowUserInteraction],
                           animations: {
                            self.updateAppearance(animated: false)
            })
        } else {
            switch UserPreferences.appTheme {
            case 0: backgroundColor = .lightForeground
            case 1: backgroundColor = .darkForeground
            case 2: backgroundColor = .blackForeground
            default: ()
            }
        }
    }
    
    static func updateAppearance() {
        switch UserPreferences.appTheme {
        case 0: UIThemeableView.appearance().backgroundColor = .lightForeground
        case 1: UIThemeableView.appearance().backgroundColor = .darkForeground
        case 2: UIThemeableView.appearance().backgroundColor = .blackForeground
        default: ()
        }
    }
    
    @objc func appearanceDidChange() {
        updateAppearance(animated: true)
    }

}
