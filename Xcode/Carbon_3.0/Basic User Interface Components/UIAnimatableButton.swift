//
//  UIAnimatableButton.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/8/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

// These buttons bounde capable of bouncing when they are hit.
class UIAnimatableButton: UIButton {
    
    /*****************************/
    /****** Public Variables *****/
    /*****************************/
    public var springy: Bool = true
    
    /*****************************/
    /***** Private Variables *****/
    /*****************************/
    private var currentScale: CGFloat = 1.0
    private var currentRotation: CGFloat = 0.0

    /*****************************/
    /**** Touch Event Handling ***/
    /*****************************/

    // This triggers when the users finger first touches the button.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if springy {
            performShrinkAnimation()
        }
    }
    
    // This triggers when the users finger is released from the button.
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if springy {
            performGrowAnimation()
        }
    }
    
    // This triggers when the users finger is released from the button.
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if springy {
            performGrowAnimation()
        }
    }
    
    /*****************************/
    /********* Animations ********/
    /*****************************/
    
    private func performShrinkAnimation(finished: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: [
                                 .beginFromCurrentState,
                                 .curveEaseInOut],
                       animations: {
                        self.setTransform(scale: 0.9)
        }, completion: { _ in
            finished?()
        })
    }
    
    private func performGrowAnimation(finished: (() -> Void)? = nil) {
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 4,
                       initialSpringVelocity: 30,
                       options: [
                                 .beginFromCurrentState,
                                 .curveEaseInOut],
                       animations: {
                        self.setTransform(scale: 1.0)
        }, completion: { _ in
            finished?()
        })
    }
    
    public func performSpinAnimation(finished: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.setTransform(rotation: self.currentRotation + .pi)
        }, completion: { _ in
            finished?()
        })
    }
    
    /*****************************/
    /**** Helpers & Utilities ****/
    /*****************************/
    
    // Sets this buttons transform for the given scale and rotation values by
    // building a new transform. This is done to preserve the current rotation
    // and scale values. The current scale & rotation values are updated.
    private func setTransform(scale: CGFloat? = nil, rotation: CGFloat? = nil) {
        currentScale    = scale ?? currentScale
        currentRotation = rotation ?? currentRotation
        let scaleTransform    = CGAffineTransform.init(scaleX: currentScale, y: currentScale)
        let rotationTransform = CGAffineTransform.init(rotationAngle: currentRotation)
        self.transform = scaleTransform.concatenating(rotationTransform)
    }
    
}
