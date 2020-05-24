//
//  UIBlurryView.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/10/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UIBlurryView: UIVisualEffectView {

    /*****************************/
    /******* Initialization ******/
    /*****************************/
    
    // We initialize the blue background with 0.0 alpha with the intention of
    // chainging the alpha in the view did appear method of the view controller
    // that holds this view.
    convenience init() {
        self.init(effect: UIBlurEffect(style: .dark))
        self.alpha = 0.0
    }
    
    /*****************************/
    /******* Public Methods ******/
    /*****************************/
    
    // This should be called in view did appear method of the view
    // controller that holds this view.
    public func fadeIn() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1.0
        }
    }

}
