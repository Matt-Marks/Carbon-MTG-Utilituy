//
//  UIThemeableTableViewCell.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/12/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UIThemeableTableViewCell: UITableViewCell {
    
    
    @IBInspectable var canSelect: Bool = true {
        didSet {
            selectable = canSelect
        }
    }
    
    
    /*****************************/
    /********* Variables *********/
    /*****************************/
    
    private var selectable = true

    private let lightDimColor = UIColor.init(hexVal: 0xcccccc)
    
    private let darkDimColor = UIColor.init(hexVal: 0x333333)
    
    private var color: UIColor {
        switch UserPreferences.appTheme {
        case 1: return .darkForeground
        case 2: return .blackForeground
        default: return .lightForeground
        }
    }
    
    private var dimColor: UIColor {
        switch UserPreferences.appTheme {
        case 1: return UIColor.init(hexVal: 0x6F7680)
        case 2: return UIColor.init(hexVal: 0x2E2E2E)
        default: return UIColor.init(hexVal: 0xD1D1D1)
        }
    }
    
    
    
    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    
    
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
    
    /*****************************/
    /******* Public Methods ******/
    /*****************************/
    public func setSelectionStyle(_ style: UITableViewCell.SelectionStyle) {
        self.selectionStyle = .none
        selectable = style != .none
    }
    
    
    
    /*****************************/
    /**** Touch Event Handling ***/
    /*****************************/
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if selectable {
            animateBackgroundColor(dimColor, duration: 0.2)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if selectable {
            animateBackgroundColor(color, duration: 0.5)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if selectable {
            animateBackgroundColor(color, duration: 0.5)
        }
    }
    
    private func animateBackgroundColor(_ newColor: UIColor, duration: CFTimeInterval) {
        let dim = CABasicAnimation()
        dim.keyPath               = "backgroundColor"
        dim.fromValue             = backgroundColor!.cgColor
        dim.toValue               = newColor.cgColor
        dim.duration              = duration
        dim.isRemovedOnCompletion = true
        dim.timingFunction        = CAMediaTimingFunction.init(name: .easeInEaseOut)
        dim.fillMode              = .forwards
        dim.isRemovedOnCompletion = true
        backgroundColor           = newColor
        layer.add(dim, forKey: "dimAnimation")
    }

}

// MARK: - AppearanceModifiable
extension UIThemeableTableViewCell: AppearanceModifiable {
    
    func updateAppearance(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: [.beginFromCurrentState, .allowUserInteraction],
                           animations: {
                            self.updateAppearance(animated: false)
            })
        } else {
            tintColor = UserPreferences.accentColor
            switch UserPreferences.appTheme {
            case 0: backgroundColor = .lightForeground
            case 1: backgroundColor = .darkForeground
            case 2: backgroundColor = .blackForeground
            default: ()
            }
        }
    }
    
    static func updateAppearance() {
        UIThemeableTableViewCell.appearance().tintColor = UserPreferences.accentColor

        switch UserPreferences.appTheme {
        case 0: UIThemeableTableViewCell.appearance().backgroundColor = .lightForeground
        case 1: UIThemeableTableViewCell.appearance().backgroundColor = .darkForeground
        case 2: UIThemeableTableViewCell.appearance().backgroundColor = .blackForeground
        default: ()
        }
        
    }
    
    @objc func appearanceDidChange() {
        updateAppearance(animated: true)
    }
}
