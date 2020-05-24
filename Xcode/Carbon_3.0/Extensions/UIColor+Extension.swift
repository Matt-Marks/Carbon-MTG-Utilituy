//
//  UIColor+Extension.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 8/18/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    public convenience init(hexVal: Int) {
        let red   = CGFloat((hexVal >> 16) & 0xFF)/255.0
        let green = CGFloat((hexVal >> 8) & 0xFF)/255.0
        let blue  = CGFloat((hexVal >> 0) & 0xFF)/255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    var hexVal: Int {
        var red: CGFloat   = 0
        var green: CGFloat = 0
        var blue: CGFloat  = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return Int(red * 255) << 16 | Int(green * 255) << 8 | Int(blue * 255) << 0
    }
    
    // Light Mode Colors
    static var lightSeparator  = UIColor.init(hexVal: 0xC6C7CB)
    static var lightBackground = UIColor.init(hexVal: 0xEEEFF3)
    static var lightForeground = UIColor.init(hexVal: 0xFFFFFF)
    
    // Dark Mode Colors
    static var darkSeparator  = UIColor.init(hexVal: 0x38434D)
    static var darkBackground = UIColor.init(hexVal: 0x151F2B)
    static var darkForeground = UIColor.init(hexVal: 0x1D2938)
    
    // True Black Colors
    static var blackSeparator  = UIColor.init(hexVal: 0x525252)
    static var blackBackground = UIColor.init(hexVal: 0x000000)
    static var blackForeground = UIColor.init(hexVal: 0x000000)
    
    static var ghost    = UIColor.init(hexVal:0xEFEDF4) // Dark White
    static var silver   = UIColor.init(hexVal:0x8E9EA8) // Darker White
    static var coral    = UIColor.init(hexVal:0xF24C49) // Pinkish Red
    static var sapphire = UIColor.init(hexVal:0x49A4E5) // Light Blue
    static var cobalt   = UIColor.init(hexVal:0x192835) // Dark Blue
    static var navy     = UIColor.init(hexVal:0x111E26) // Darker Blue
    
    static var carbon     = UIColor.init(hexVal: 0xFFFFFF)
    static var neon       = UIColor.init(hexVal: 0xE52C61)
    static var lithium    = UIColor.init(hexVal: 0xF34C49)
    static var helium     = UIColor.init(hexVal: 0xFF6E31)
    static var iron       = UIColor.init(hexVal: 0xFF9D31)
    static var oxygen     = UIColor.init(hexVal: 0xFFCD31)
    static var barium     = UIColor.init(hexVal: 0x81C652)
    static var chlorine   = UIColor.init(hexVal: 0x03C074)
    static var phosphorus = UIColor.init(hexVal: 0x1BA19D)
    static var silicon    = UIColor.init(hexVal: 0x3182C5)
    static var zinc       = UIColor.init(hexVal: 0x586CB8)
    static var nitrogen   = UIColor.init(hexVal: 0x7E55AB)

    static var elementColors = [carbon, neon, lithium, helium,
                                iron, oxygen, barium, chlorine,
                                phosphorus, silicon, zinc, nitrogen]
    
    static var accentColors = [sapphire, neon, lithium, helium,
                               iron, oxygen, barium, chlorine,
                               phosphorus, silicon, zinc, nitrogen]
}

