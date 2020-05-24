//
//  UIMenuDiceViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/3/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit
import GameplayKit

class UIMenuDiceViewController: UIPageViewControllerPage {

    ///////////////////////////
    // MARK: Variables: General
    ///////////////////////////
    private let lengthOfNumberPresentation: TimeInterval = 1.0
    
    /////////////////////////////////////
    // MARK: Variables: Interface Ourlets
    /////////////////////////////////////
    @IBOutlet weak var d4Button: UIAnimatableButton!
    @IBOutlet weak var d6Button: UIAnimatableButton!
    @IBOutlet weak var d8Button: UIAnimatableButton!
    @IBOutlet weak var d10Button: UIAnimatableButton!
    @IBOutlet weak var d12Button: UIAnimatableButton!
    @IBOutlet weak var d20Button: UIAnimatableButton!
    
    //////////////////
    // MARK: Lifecycle
    //////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForEntranceAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performEntranceAnimation()
    }
    
    ///////////////////////////
    // MARK: Dice Button Action
    ///////////////////////////
    
    // Called when a user taps on a dice.
    @IBAction func diceButtonPressed(_ sender: UIAnimatableButton) {
        
        
        // First, we disable the button until the animation is complete.
        sender.isUserInteractionEnabled = false
        
        // We store the icon on the button so we can reinstate it after the
        // animation. We do this becayse during the animation we have to remove
        // the icon from the button.
        let diceIcon = sender.backgroundImage(for: .normal)
        
        // The tag of the button is the highest number the dice can roll.
        let randomNumber = getRandomNumber(forDiceWithSides: sender.tag)
        
        // We change the button from displaying a dice to displaying a number.
        sender.setBackgroundImage(nil, for: .normal)
        sender.setTitle(randomNumber.description, for: .normal)
        
        // An explosion and spring animation are added to the button.
        addExplosionAnimation(sender)
        addSpringAnimation(sender)
        
        // After a short period time, the button reverts to its original state.
        Timer.scheduledTimer(withTimeInterval: lengthOfNumberPresentation,
                             repeats: false,
                             block: { _ in
                                sender.isUserInteractionEnabled = true
                                sender.setTitle(nil, for: .normal)
                                sender.setBackgroundImage(diceIcon, for: .normal)
                                self.addSpringAnimation(sender)
        })
        
    }

    
    //////////////////////
    // MARK: Random Number
    //////////////////////
    
    // Returns a random number between 1 and the given number inclusive.
    private func getRandomNumber(forDiceWithSides sides: Int) -> Int {
        let random = GKRandomDistribution(lowestValue: 1, highestValue: sides)
        return random.nextInt()
    }

    ///////////////////
    // MARK: Animations
    ///////////////////
    
    // Adds a brief spring animation to the given button
    private func addSpringAnimation(_ button: UIButton) {
        let scale  = CASpringAnimation()
        let timing = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        scale.keyPath               = "transform.scale"
        scale.fromValue             = 0.6
        scale.toValue               = 1.0
        scale.damping               = 9.0
        scale.initialVelocity       = 3.1
        scale.duration              = 1.5
        scale.timingFunction        = timing
        scale.isRemovedOnCompletion = false
        button.transform              = CGAffineTransform(scaleX: 1.0, y: 1.0)
        button.layer.add(scale, forKey: "entranceScale")
    }
    
    // Adds a brief explosion animation to the given button.
    private func addExplosionAnimation(_ button: UIButton) {
        
        let cell = CAEmitterCell()
        cell.birthRate     = 50
        cell.lifetime      = 1
        cell.lifetimeRange = 0.25
        cell.velocity      = 60
        cell.velocityRange = 50
        cell.emissionRange = CGFloat.pi * 2.0
        cell.color         = UIColor.white.cgColor
        cell.contents      = #imageLiteral(resourceName: "Emitter_Circle").cgImage
        cell.scale         = 0.05
        cell.scaleRange    = 0.2
        cell.alphaSpeed    = -1
        cell.alphaRange    = 0
        
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: button.bounds.midX, y: button.bounds.midY)
        emitter.emitterShape    = CAEmitterLayerEmitterShape.circle
        emitter.emitterMode     = CAEmitterLayerEmitterMode.outline
        emitter.emitterSize     = CGSize(width:10, height: 10)
        emitter.emitterCells    = [cell]
        
        let fade = CABasicAnimation()
        fade.keyPath               = "opacity"
        fade.fromValue             = 1
        fade.toValue               = 0
        fade.duration              = 0.4
        fade.fillMode              = CAMediaTimingFillMode.forwards;
        fade.isRemovedOnCompletion = false;
        
        emitter.add(fade, forKey: "fade")
        button.layer.insertSublayer(emitter, at: 0)
    }

    private func prepareForEntranceAnimation() {
        if (pageController as! UIMenuPageViewController).getInitialPage() == .dice {
            for subview in view.subviews {
                subview.prepareForEntranceAnimation()
            }
        }
    }
    
    private func performEntranceAnimation() {
        if (pageController as! UIMenuPageViewController).getInitialPage() == .dice {
            for subview in view.subviews {
                subview.performEntranceAnimation()
            }
        }
    }

}
