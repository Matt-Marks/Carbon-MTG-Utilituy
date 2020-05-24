//
//  UIChooserViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/3/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

enum UIChooserState {
    case interacting, noninteracting, finished
}

protocol UIChooserViewControllerDelegate {
    func chooser(_ controller: UIChooserViewController, stateDidChange state: UIChooserState)
    func chooser(_ controller: UIChooserViewController, didEndChoosingWithColors colors: [UIColor])
}

protocol UIChooserViewControllerDataSource {
    func avalibleColors(for: UIChooserViewController) -> [UIColor]
    func pulseDuration(for: UIChooserViewController) -> Double
    func numberOfPulses(for: UIChooserViewController) -> Int
}

class UIChooserViewController: UIViewController {
    
    public var delegate: UIChooserViewControllerDelegate!
    public var dataSource: UIChooserViewControllerDataSource!
    
    private var countdownTimer = Timer()
    private var pulseNum = 0
    private var fingerDict = [Int:CircleView]()
    private var state: UIChooserState!
    private var winner: CircleView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isMultipleTouchEnabled = true
    }
    
    @available(iOS 13.0, *)
    override var editingInteractionConfiguration: UIEditingInteractionConfiguration {
        return .none
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        // Called every time a finger is added to the screen.
        // Adds a circle around the touch and attempts to start the countdown.
        for touch in touches {
            if winner == nil {
                addCircleForTouch(touch)
                updateState()
                startStopCountdown()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Called every time a finger moves on the screen.
        // Moves the circle around the moving touch.
        for touch in touches {
            moveCircleForTouch(touch)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Called when a finger leaves the screen.
        // Removes the circle around the touch.
        for touch in touches {
            removeCircleForTouch(touch)
            updateState()
            startStopCountdown()
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !UserPreferences.preventPopups {
            showAlert()
        }
        
        // Called when a phone call occurs, max fingers reached, or other such interuption happens.
        // Removes all circles around all touches.
        
        for touch in touches {
            removeCircleForTouch(touch)
            updateState()
            startStopCountdown()
        }
        
        
    }
    
    private func showAlert() {
        
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
        
        let title = "OH NO!"
        
        var message: String {

            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                return "This device only supports up to 5 unique touches at once."
            case .pad:
                return "Maximum number of touches exceeded."
            default:
                return "Something went wrong."
            }
        }
        
                
        let alert = UIWonderfulAlert(title: title,
                                     message: message)
        
        present(alert, animated: false)
        
    }
    
    private func updateState() {
        // Notifies the delegate if the chooser is being used or not
        var newState: UIChooserState!
        
        if winner != nil && fingerDict.count < 1 {
            newState = .finished
        } else if fingerDict.count < 1 {
            newState = .noninteracting
        } else {
            newState = .interacting
        }
        
        if state != newState {
            state = newState
            delegate.chooser(self, stateDidChange: state)
        }
        
    }
    
    private func addCircleForTouch(_ touch: UITouch) {
        // Adds a circle around a touch and assignes it to that touch
        let color = nextColor()
        let circle = CircleView.init(color: color, pulseDuration: dataSource.pulseDuration(for: self))
        let key = touch.hashValue
        let position = touch.location(in: view)
        circle.center = position
        fingerDict[key] = circle
        view.addSubview(circle)
        circle.animate(.entrance)
    }
    
    private func moveCircleForTouch(_ touch: UITouch) {
        // When a finger is moved the circles move with them.
        let key = touch.hashValue
        let position = touch.location(in: view)
        let circle = fingerDict[key]
        circle?.center = position
    }
    
    private func removeCircleForTouch(_ touch: UITouch) {
        // Removes all refrences to the touch, and animates its circle away.
        let key = touch.hashValue
        let circle = fingerDict[key]
        fingerDict.removeValue(forKey: key)
        circle?.animate(.exit)
    }
    
    private func nextColor() -> UIColor {
        // Called when a finger is placed on the screen.
        // If there delegate only provides one color, that color is returned.
        // If the delegate provides multiple colors, a color that is not being used is returned.
        // If no color can be returned, then
        var color = randomColor()
        let currentColors = fingerDict.values.map({$0.color})
        let avalibleColors = dataSource.avalibleColors(for: self)
        let canHaveMultipleCircleColors = avalibleColors.count > 1
        

        while currentColors.count < 11 && currentColors.contains(color) && canHaveMultipleCircleColors {
            color = randomColor()
        }
        
        return color
    }

    private func randomColor() -> UIColor {
        // Called when a finger is placed on the screen.
        // Returns a random color from the provided colors from the delegate.
        return dataSource.avalibleColors(for: self).randomElement()!
    }
    
    private func randomTouch() -> CircleView {
        // Called when a winner is chosen. This returns a random touch on the screen
        return Array(fingerDict.values).randomElement()!
    }
    
    private func startStopCountdown() {
        // When called a finger is placed or removed form the screen.
        // The current countdown is cancled and restarted. If this method is not called
        // within 2 pulses the coundown is completed and a winner is chosen.
        pulseNum = 0
        countdownTimer.invalidate()
        if fingerDict.count > 1 {
            countdownTimer = Timer.scheduledTimer(withTimeInterval: dataSource.pulseDuration(for: self),
                                             repeats: true, block: { _ in
                                                self.fingerDict.values.forEach({$0.animate(.pulse)})
                                                self.pulseNum += 1
                                                if self.pulseNum > self.dataSource.numberOfPulses(for: self) {
                                                    self.countdownTimer.invalidate()
                                                    self.selectWinner()
                                                }
            })
        }
    }
    
    private func selectWinner() {
        // After randomly choosing a winner, the delegate is given the winning colors,
        // the winning circle is animated, and the state is updated to finished.
        let finalColors = fingerDict.values.map({$0.color})
        delegate.chooser(self, didEndChoosingWithColors: finalColors)
        winner = randomTouch()
        fingerDict.values.forEach({$0 == winner ? $0.animate(.winner) : $0.animate(.exit)})
    }
    

    // MARK: - CircleView
    private class CircleView: UIView {
        
        // MARK: Constants Declaration
        enum CircleAnimationType {
            case entrance, exit, winner, pulse
        }
        
        // MARK: Variables Declaration
        public var color = UIColor.white
        private var pulseDuration: Double!
        
        convenience init (color: UIColor, pulseDuration: Double) {
            self.init()
            self.color = color
            self.pulseDuration = pulseDuration
            configure()
        }
        
        private func configure() {
            // Every circle has the same shape, and border thickness.
            frame = CGRect(x:0 ,y:0 ,width: 130, height: 130)
            layer.borderWidth = 10
            layer.borderColor = color.cgColor
            layer.cornerRadius = 65
        }
        
        private func animateEntrance() {
            // Expands a circle from nothing with a slight spring in its step.
            let scale = CASpringAnimation()
            scale.keyPath = "transform.scale"
            scale.fromValue = 0.3
            scale.toValue = 1.0
            scale.damping = 6.0
            scale.initialVelocity = 3.1
            scale.duration = 1.5
            scale.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
            scale.isRemovedOnCompletion = false
            transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            layer.add(scale, forKey: "entranceScale")
        }
        
        private func animateExit() {
            // Shrinks the circle into oblivion.
            let currentValue = layer.presentation()?.value(forKeyPath: "transform.scale")
            let scale = CABasicAnimation()
            let fade = CABasicAnimation()
            scale.keyPath = "transform.scale"
            scale.fromValue = currentValue
            scale.toValue = 0.01
            scale.duration = 0.2
            scale.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
            scale.isRemovedOnCompletion = false
            fade.keyPath = "opacity"
            fade.fromValue = layer.presentation()?.value(forKeyPath: "opacity")
            fade.toValue = 0.0
            fade.duration = 0.2
            fade.fillMode = CAMediaTimingFillMode.forwards;
            transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            alpha = 0.0
            layer.add(scale, forKey: "exitScale")
            layer.add(fade, forKey: "fadeOut")
        }
        
        
        private func animateWinner() {
            // The winning circle is expanded
            let currentValue = layer.presentation()?.value(forKeyPath: "transform.scale")
            let currentColor = layer.presentation()?.value(forKey: "backgroundColor")
            let scale = CASpringAnimation()
            let fill = CABasicAnimation()
            scale.keyPath = "transform.scale"
            scale.fromValue = currentValue
            scale.toValue = 2.0
            scale.duration = 1.5
            scale.damping = 6.0
            scale.initialVelocity = 3.1
            scale.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
            scale.isRemovedOnCompletion = false
            fill.keyPath = "backgroundColor"
            fill.fromValue = currentColor
            fill.toValue = color.cgColor
            fill.duration = 0.5
            fill.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
            backgroundColor = UIColor(cgColor: color.cgColor)
            layer.add(fill, forKey: "backgroundColor")
            transform  = CGAffineTransform(scaleX: 2.0, y: 2.0)
            layer.add(scale, forKey: "winnerScale")
        }
        
        private func animatePulse() {
            // On the tick of every countdown this pulse occurs.
            let currentValue = layer.presentation()?.value(forKeyPath: "transform.scale")
            let currentColor = layer.presentation()?.value(forKey: "backgroundColor")
            let pulse = CABasicAnimation()
            let fill = CABasicAnimation()
            pulse.keyPath = "transform.scale"
            pulse.fromValue = currentValue
            pulse.toValue = 1.4
            pulse.duration = pulseDuration/2
            pulse.autoreverses = true
            pulse.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
            pulse.isRemovedOnCompletion = true
            fill.keyPath = "backgroundColor"
            fill.fromValue = currentColor
            fill.toValue = color.cgColor
            fill.duration = pulseDuration/2
            fill.autoreverses = true
            fill.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
            layer.add(fill, forKey: "backgroundColor")
            layer.add(pulse, forKey: "pulse")
        }
        
        public func animate(_ animation: CircleAnimationType) {
            // Triggers an animation sequence for a circle around a touch
            switch animation {
            case .entrance: animateEntrance()
            case .exit: animateExit()
            case .winner: animateWinner()
            case .pulse: animatePulse()
            }
        }
        
    }

}
