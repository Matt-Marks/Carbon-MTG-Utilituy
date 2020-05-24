//
//  UIFont+Extension.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/9/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

extension UIFont {
    
    enum TondoWeight {
        case light, regular, bold
    }
    
    static func tondo(weight: TondoWeight, size: CGFloat) -> UIFont {
        switch weight {
        case .light:   return UIFont.init(name: "Tondo-Light", size: size)!
        case .regular: return UIFont.init(name: "Tondo-Regular", size: size)!
        case .bold:    return UIFont.init(name: "Tondo-Bold", size: size)!
        }
    }
    
    static func dense(size: CGFloat) -> UIFont {
        return UIFont.init(name: "Dense", size: size)!
    }

}
