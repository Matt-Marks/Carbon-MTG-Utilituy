//
//  UIImage+Extension.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/27/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    // Premium Page Icons
    static var grayscaleApp       = UIImage(named: "Grayscale_App")!
    static var grayscaleBuildings = UIImage(named: "Grayscale_Buildings")!
    static var grayscaleColors    = UIImage(named: "Grayscale_Colors")!
    static var grayscaleCrown     = UIImage(named: "Grayscale_Crown")!
    static var grayscaleHand      = UIImage(named: "Grayscale_Hand")!
    static var grayscalePlayers   = UIImage(named: "Grayscale_Players")!
    static var grayscaleSkull     = UIImage(named: "Grayscale_Skull")!
    static var grayscaleSun       = UIImage(named: "Grayscale_Sun")!
    static var grayscaleSwitch    = UIImage(named: "Grayscale_Switch")!
    static var grayscaleText      = UIImage(named: "Grayscale_Text")!
    
    static var navigationBack = UIImage(named: "Navigation_BackArrow")!
    static var navigationHome = UIImage(named: "Navigation_Home")!
    static var navigationClose = UIImage(named: "Navigation_Close")!
    static var player = UIImage(named: "Auxiliary_Player")!
    static var d20 = UIImage(named: "D20")!
    static var numPadDelete = UIImage(named: "NumPad_Backspace")!
    static var colors = UIImage(named: "Auxiliary_ColorWheel")!
    static var effects = UIImage(named: "Auxiliary_Wand")!
    static var counters = UIImage(named: "Auxiliary_Counters")!
    static var positiveInfinity = UIImage(named: "Auxiliary_Infinity")!
    static var negativeInfinity = UIImage(named: "Auxiliary_NegativeInfinity")!
    static var emitterCircle = UIImage(named: "Emitter_Circle")!
    static var skull = UIImage(named: "Auxiliary_Death")!
    static var play = UIImage(named: "Auxiliary_Play")!
    static var pause = UIImage(named: "Auxiliary_Pause")!
    static var city = UIImage(named: "Auxiliary_City")!
    static var crown = UIImage(named: "Auxiliary_Crown")!
    static var death = UIImage(named: "Auxiliary_Death")!
    static var leftTrumpit = UIImage(named: "Left_Trumpit")!
    static var rightTrumpit = UIImage(named: "Right_Trumpit")!
    

    
    
    
    
    
    
    
    static var counterLife       = UIImage(named: "Counter_Life")!
    static var counterEnergy     = UIImage(named: "Counter_Energy")!
    static var counterExperience = UIImage(named: "Counter_Experience")!
    static var counterPoison     = UIImage(named: "Counter_Poison")!
    static var counterStorm      = UIImage(named: "Counter_Storm")!
    static var counterTax        = UIImage(named: "Counter_Tax")!
    static var counterDamage     = UIImage(named: "Counter_Damage")!
    static var counterWhite      = UIImage(named: "Counter_White")!
    static var counterBlue       = UIImage(named: "Counter_Blue")!
    static var counterBlack      = UIImage(named: "Counter_Black")!
    static var counterRed        = UIImage(named: "Counter_Red")!
    static var counterGreen      = UIImage(named: "Counter_Green")!
    static var counterColorless  = UIImage(named: "Counter_Colorless")!
    
    public convenience init(counterIconFromInteger num: Int) {
        switch num {
        case 0:  self.init(named: "Counter_Life")!
        case 1:  self.init(named: "Counter_Energy")!
        case 2:  self.init(named: "Counter_Experience")!
        case 3:  self.init(named: "Counter_Poison")!
        case 4:  self.init(named: "Counter_Storm")!
        case 5:  self.init(named: "Counter_Tax")!
        case 6:  self.init(named: "Counter_Damage")!
        case 7:  self.init(named: "Counter_White")!
        case 8:  self.init(named: "Counter_Blue")!
        case 9:  self.init(named: "Counter_Black")!
        case 10: self.init(named: "Counter_Red")!
        case 11: self.init(named: "Counter_Green")!
        case 12: self.init(named: "Counter_Colorless")!
        default: self.init()
        }
    }
    
}
