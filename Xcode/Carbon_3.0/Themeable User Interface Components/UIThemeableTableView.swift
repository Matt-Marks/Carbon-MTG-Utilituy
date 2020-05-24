//
//  UIThemeableTableView.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/12/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UIThemeableTableView: UITableView {

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
extension UIThemeableTableView: AppearanceModifiable {
    
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
            case 0:
                backgroundColor = .lightBackground
                separatorColor = .lightSeparator
            case 1:
                backgroundColor = .darkBackground
                separatorColor = .darkSeparator
            case 2:
                backgroundColor = .blackBackground
                separatorColor = .blackSeparator
            default: ()
            }
        }
    }
    
    
    static func updateAppearance() {
        
        switch UserPreferences.appTheme {
        case 0:
            UIThemeableTableView.appearance().backgroundColor = .lightBackground
            UIThemeableTableView.appearance().separatorColor = .lightSeparator
        case 1:
            UIThemeableTableView.appearance().backgroundColor = .darkBackground
            UIThemeableTableView.appearance().separatorColor = .darkSeparator
        case 2:
            UIThemeableTableView.appearance().backgroundColor = .blackBackground
            UIThemeableTableView.appearance().separatorColor = .blackSeparator
        default: ()
        }
    }
    
    @objc func appearanceDidChange() {
        updateAppearance(animated: true)
    }
}
