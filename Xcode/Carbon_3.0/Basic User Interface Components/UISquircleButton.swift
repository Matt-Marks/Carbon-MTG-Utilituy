//
//  UISquircleButton.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/8/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

// The squircle button is used in many places in the application.
class UISquircleButton: UIAnimatableButton {

    /*****************************/
    /****** Public Variables *****/
    /*****************************/
    
    // When changed the fill of the button is updated.
    public var fill: UISquircleButtonFillStyle = .filled {
        didSet { update(fill: fill, emphasis: emphasis) }
    }
    
    // When changed the background color of the button is updated.
    public var emphasis: UISquircleButtomEmphasis = .primary {
        didSet { update(fill: fill, emphasis: emphasis) }
    }
    
    // When changed the font of the button is updated.
    public var fontType: UISquircleButtonFont = .tondo {
        didSet { update(font: fontType, size: fontSize) }
    }
    
    // When changed the font size of the button is updated.
    public var fontSize: CGFloat = 22 {
        didSet { update(font: fontType, size: fontSize) }
    }
    
    /*****************************/
    /******** Enumerations *******/
    /*****************************/
    
    // Dense is used for numbers and Tondo is used for words.
    enum UISquircleButtonFont {
        case dense, tondo
    }

    // Filled means white text with a solid color backgorund. Outlined means
    // colored text with a clear background and a small border around the
    // perimiter of the button.
    enum UISquircleButtonFillStyle {
        case filled, outlined
    }
    
    // The emphasis of the button is just the color of the button.
    enum UISquircleButtomEmphasis {
        case primary, secondary, danger, auxiliary
        var color: UIColor {
            switch self {
            case .primary:   return UserPreferences.accentColor
            case .secondary: return .silver
            case .danger:    return .coral
            case .auxiliary: return .white
            }
        }
    }
    
    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    
    // This is the first thing called on the button. It sets up the default
    // parameters of the button to filled, tondo, primary, and font size 22.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        update(fill: fill, emphasis: emphasis)
        update(font: fontType, size: fontSize)
        layer.cornerRadius = rect.height/5
        clipsToBounds = true
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        update(fill: fill, emphasis: emphasis)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appearanceDidChange),
                                               name: .AppearanceDidChange,
                                               object: nil)
    }
    
    /*****************************/
    /*********** Other ***********/
    /*****************************/
    
    // This is called with the style of the button is changed.
    private func update(fill: UISquircleButtonFillStyle, emphasis: UISquircleButtomEmphasis) {
        
        var titleColor = fill == .filled ? .white : UserPreferences.accentColor
        if fill == .outlined && UserPreferences.appTheme != 0 || emphasis == .auxiliary {
            titleColor = .white
        }
        
        layer.borderColor = emphasis.color.cgColor
        layer.borderWidth = fill == .filled ? 0 : 1.5
        backgroundColor   = fill == .filled ? emphasis.color : .clear
        setTitleColor(titleColor, for: .normal)
    }
    
    // This is called when the font is changed.
    private func update(font: UISquircleButtonFont, size: CGFloat) {
        if fontType == .dense {
            titleLabel?.font = UIFont.dense(size: size)
        } else if fontType == .tondo {
            titleLabel?.font = UIFont.tondo(weight: .bold, size: size)
        }
    }
    
    
    
}

extension UISquircleButton: AppearanceModifiable {
    static func updateAppearance() {
        // Nothing to do
    }
    
    func updateAppearance(animated: Bool) {
        // Nothing to do
    }
    
    @objc func appearanceDidChange() {
        update(fill: fill, emphasis: emphasis)
    }
    
    
}
