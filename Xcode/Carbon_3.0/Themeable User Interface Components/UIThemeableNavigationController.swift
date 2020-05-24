//
//  UIThemeableNavigationController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/12/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UIThemeableNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
extension UIThemeableNavigationController: AppearanceModifiable {
    
    func updateAppearance(animated: Bool) {
        if animated {
            UIView.transition(with: navigationBar,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.updateAppearance(animated: false)
            })
        } else {
            navigationBar.isTranslucent = false
            navigationBar.tintColor = UserPreferences.accentColor
    
            
            switch UserPreferences.appTheme {
            case 0:
                view.backgroundColor = .lightBackground
                navigationBar.barTintColor = .lightForeground
                navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
                navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
            case 1:
                view.backgroundColor = .darkBackground
                navigationBar.barTintColor = .darkForeground
                navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
                navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            case 2:
                view.backgroundColor = .blackBackground
                navigationBar.barTintColor = .blackForeground
                navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
                navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            default: ()
            }
            
 
        }
    }
    
    static func updateAppearance() {
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = UserPreferences.accentColor
        
        
        switch UserPreferences.appTheme {
        case 0:
            UINavigationBar.appearance().barStyle = .default
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        case 1:
            UINavigationBar.appearance().barStyle = .black
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        case 2:
            UINavigationBar.appearance().barStyle = .black
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        default: ()
        }
        
    }
    
    @objc func appearanceDidChange() {
        updateAppearance(animated: true)
    }
}
