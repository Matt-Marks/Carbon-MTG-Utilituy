//
//  UIView+Extension.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/15/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func prepareForEntranceAnimation() {
        transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
    }
    
    func performEntranceAnimation() {
        if transform.a != 1.0 {
            let scale             = CASpringAnimation()
            scale.keyPath         = "transform.scale"
            scale.duration        = 0.4
            scale.initialVelocity = 16
            scale.damping         = 60
            scale.stiffness       = 200
            scale.fromValue       = 0.0
            scale.toValue         = 1.0
            scale.isRemovedOnCompletion = false
            layer.add(scale, forKey: "scaleIn")
            transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            
            self.isUserInteractionEnabled = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                self.isUserInteractionEnabled = true
            })
        }
        
        

    }
    
}
