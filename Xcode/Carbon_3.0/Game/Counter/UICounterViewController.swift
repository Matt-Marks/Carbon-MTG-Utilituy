//
//  UICounterViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/10/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UICounterViewController: UIViewController {
    
    let iconSize: CGSize = CGSize(width: 42, height: 42)
    
    /*****************************/
    /***** Interface Objects *****/
    /*****************************/
    private let seperatorBar      = CALayer()
    private let numberLabel       = UILabel()
    private let iconImageView     = UIImageView()
    private let infinityImageView = UIImageView()
    private let upButton          = UIButton()
    private let downButton        = UIButton()
    
    /*****************************/
    /**** Gestrue Recognizers ****/
    /*****************************/
    private let oneFingerUpTapGestureRecognizer         = UITapGestureRecognizer()
    private let oneFingerDownTapGestureRecognizer       = UITapGestureRecognizer()
    private let twoFingerUpTapGestureRecognizer         = UITapGestureRecognizer()
    private let twoFingerDownTapGestureRecognizer       = UITapGestureRecognizer()
    private let oneFingerUpLongPressGestureRecognizer   = UILongPressGestureRecognizer()
    private let oneFingerDownLongPressGestureRecognizer = UILongPressGestureRecognizer()
    private let twoFingerUpLongPressGestureRecognizer   = UILongPressGestureRecognizer()
    private let twoFingerDownLongPressGestureRecognizer = UILongPressGestureRecognizer()
    
    /*****************************/
    /***** General Variables *****/
    /*****************************/
    public var hostPlayer: UIPlayerViewController! // The player holding this counter
    private var initialValue: Int! // The starting value of the counter
    private var currentValue: Int! // The current value of the counter
    public  var iconImage: UIImage! // The image placed under the number
    private var topPadding: CGFloat! // Moves elements down
    private var leftPadding: CGFloat! // Moves elements right
    private var rightPadding: CGFloat! // Moves elements left
    private var bottomPadding: CGFloat! // moves elements up
    private var isInfinite: Bool! // True if the counter is infinite
    private var accentColor: UIColor! // The color of the elements
    private var holdTimer: Timer! // Used to change the number when the counter is held.
    private var holdTimerDelta: TimeInterval! // The time between number changes when the counter is held
    
    /*****************************/
    /***** Computed Variables ****/
    /*****************************/
    
    // This is the size of the large number in the center of the counter.
    private var fontSize: CGFloat {
        let heightSize = (view.bounds.height - topPadding - bottomPadding) * 0.6
        let widthSize  = (view.bounds.width - leftPadding - rightPadding) * 0.7
        return widthSize > heightSize ? heightSize : widthSize
    }
    
    // The counter needs to be able to interact with the game to perform actions
    // such as writing to history.
    private var game: UIGameViewController {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.window?.rootViewController as! UIGameViewController
    }
    
    /*****************************/
    /****** Initialization *******/
    /*****************************/
    convenience init(initialValue: Int, iconImage: UIImage, accentColor: UIColor) {
        self.init()
        self.initialValue   = initialValue
        self.currentValue   = initialValue
        self.iconImage      = iconImage
        self.topPadding     = 0
        self.leftPadding    = 0
        self.rightPadding   = 0
        self.bottomPadding  = 0
        self.isInfinite     = false
        self.accentColor    = accentColor
        self.holdTimer      = Timer()
        self.holdTimerDelta = 0.1
        initializeSubviewHierarchy()
    }

    // Adds elements to the counter and then adds gesture recognizers to the buttons.
    private func initializeSubviewHierarchy() {
        view.layer.addSublayer(seperatorBar)
        view.addSubview(numberLabel)
        view.addSubview(iconImageView)
        view.addSubview(infinityImageView)
        view.addSubview(upButton)
        view.addSubview(downButton)
        upButton.addGestureRecognizer(oneFingerUpTapGestureRecognizer)
        upButton.addGestureRecognizer(twoFingerUpTapGestureRecognizer)
        upButton.addGestureRecognizer(oneFingerUpLongPressGestureRecognizer)
        upButton.addGestureRecognizer(twoFingerUpLongPressGestureRecognizer)
        downButton.addGestureRecognizer(oneFingerDownTapGestureRecognizer)
        downButton.addGestureRecognizer(twoFingerDownTapGestureRecognizer)
        downButton.addGestureRecognizer(oneFingerDownLongPressGestureRecognizer)
        downButton.addGestureRecognizer(twoFingerDownLongPressGestureRecognizer)
    }
    
    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureGestureRecognizers()
        configureNumberLabel()
        configureIconImageView()
        configureInfinityImageView()
        configureSeperatorBar()
        configureButtons()
    }
    
    // Counters are equal if there icon image's are equal.
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? UICounterViewController {
            return object.iconImage == iconImage
        } else {
            return false
        }
    }
    
    /******************************/
    /** Gestures - Configuration **/
    /******************************/
    
    // Configures 6 gesture recognizers. A single tap, double tap, and long hold.
    // Those recognizers are configured for both the up and down buttons.
    private func configureGestureRecognizers() {
        
        // We set how many tocuhes and taps are required for each gesture
        oneFingerUpTapGestureRecognizer.numberOfTapsRequired            = 1
        oneFingerDownTapGestureRecognizer.numberOfTapsRequired          = 1
        twoFingerUpTapGestureRecognizer.numberOfTouchesRequired         = 2
        twoFingerDownTapGestureRecognizer.numberOfTouchesRequired       = 2
        oneFingerUpLongPressGestureRecognizer.numberOfTouchesRequired   = 1
        oneFingerDownLongPressGestureRecognizer.numberOfTouchesRequired = 1
        twoFingerUpLongPressGestureRecognizer.numberOfTouchesRequired   = 2
        twoFingerDownLongPressGestureRecognizer.numberOfTouchesRequired = 2
        
        // We tell the tap gestures what functions they trigger
        oneFingerUpTapGestureRecognizer.addTarget(self,   action: #selector(oneFingerTapUpRecognized))
        oneFingerDownTapGestureRecognizer.addTarget(self, action: #selector(oneFingerTapDownRecognized))
        twoFingerUpTapGestureRecognizer.addTarget(self,   action: #selector(twoFingerTapUpRecognized))
        twoFingerDownTapGestureRecognizer.addTarget(self, action: #selector(twoFingerTapDownRecognized))
        
        // We tell the long press gestures what functions they trigger
        oneFingerUpLongPressGestureRecognizer.addTarget(self,   action: #selector(oneFingerHoldUpRecognized))
        oneFingerDownLongPressGestureRecognizer.addTarget(self, action: #selector(oneFingerHoldDownRecognized))
        twoFingerUpLongPressGestureRecognizer.addTarget(self,   action: #selector(twoFingerHoldUpRecognized))
        twoFingerDownLongPressGestureRecognizer.addTarget(self, action: #selector(twoFingerHoldDownRecognized))
    }
    
    /******************************/
    /** Gesture - One Finger Tap **/
    /******************************/
    
    // If the counter is not infinite this performs the actions set by the user
    // for one finger taps. Otherwise it just removed infinity.
    @objc private func oneFingerTapUpRecognized(sender: UITapGestureRecognizer) {
        isInfinite ? removeInfinity(animated: true) : incrementValue(by: 1)
    }
    
    
    // If the counter is not infinite this performs the actions set by the user
    // for one finger taps. Otherwise it just removed infinity.
    @objc private func oneFingerTapDownRecognized(sender: UITapGestureRecognizer) {
        isInfinite ? removeInfinity(animated: true) : decrementValue(by: 1)
    }
    
    
    /******************************/
    /** Gesture - Two Finger Tap **/
    /******************************/
    
    // If the counter is not infinite this performs the actions set by the user
    // for two finger taps. Otherwise it just removed infinity.
    @objc private func twoFingerTapUpRecognized(sender: UITapGestureRecognizer) {
        if isInfinite {
            removeInfinity(animated: true)
        } else {
            switch UserPreferences.twoFingerTapGesture {
            case 1: incrementValue(by: 2)
            case 2: incrementValue(by: 5)
            case 3: incrementValue(by: 10)
            default: ()
            }
        }
    }
    
    // If the counter is not infinite this performs the actions set by the user
    // for two finger taps. Otherwise it just removed infinity.
    @objc private func twoFingerTapDownRecognized(sender: UITapGestureRecognizer) {
        if isInfinite {
            removeInfinity(animated: true)
        } else {
            switch UserPreferences.twoFingerTapGesture {
            case 1: decrementValue(by: 2)
            case 2: decrementValue(by: 5)
            case 3: decrementValue(by: 10)
            default: ()
            }
        }
    }
    
    
    /*******************************/
    /** Gesture - One Finger Hold **/
    /*******************************/
    
    // If the counter is not infinite this performs the actions set by the user
    // for one finger holds. Otherwise it just removed infinity.
    @objc private func oneFingerHoldUpRecognized(sender: UITapGestureRecognizer) {
        if isInfinite {
            if sender.state == .began {
                removeInfinity(animated: true)
            }
        } else {
            if UserPreferences.oneFingerHold != 0 {
                switch sender.state {
                case .began: handleOneFingerHoldUp()
                case .ended, .failed, .cancelled: oneFingerHoldDidStop()
                default: ()
                }
            }
        }
        
        // When this gesture is toggled we kill all the other gestures
        // TODO: - come back to this later and make it nice
        oneFingerUpTapGestureRecognizer.isEnabled = false
        oneFingerDownTapGestureRecognizer.isEnabled = false
        twoFingerUpTapGestureRecognizer.isEnabled = false
        twoFingerDownTapGestureRecognizer.isEnabled = false
        //oneFingerUpLongPressGestureRecognizer.isEnabled = false
        oneFingerDownLongPressGestureRecognizer.isEnabled = false
        twoFingerUpLongPressGestureRecognizer.isEnabled = false
        twoFingerDownLongPressGestureRecognizer.isEnabled = false
        
        oneFingerUpTapGestureRecognizer.isEnabled = true
        oneFingerDownTapGestureRecognizer.isEnabled = true
        twoFingerUpTapGestureRecognizer.isEnabled = true
        twoFingerDownTapGestureRecognizer.isEnabled = true
        //oneFingerUpLongPressGestureRecognizer.isEnabled = true
        oneFingerDownLongPressGestureRecognizer.isEnabled = true
        twoFingerUpLongPressGestureRecognizer.isEnabled = true
        twoFingerDownLongPressGestureRecognizer.isEnabled = true
    }
    
    // If the counter is not infinite this performs the actions set by the user
    // for one finger holds. Otherwise it just removed infinity.
    @objc private func oneFingerHoldDownRecognized(sender: UITapGestureRecognizer) {
        if isInfinite {
            if sender.state == .began {
                removeInfinity(animated: true)
            }
        } else {
            if UserPreferences.oneFingerHold != 0 {
                switch sender.state {
                case .began: handleOneFingerHoldDown()
                case .ended, .failed, .cancelled: oneFingerHoldDidStop()
                default: ()
                }
            }
        }
        
        // When this gesture is toggled we kill all the other gestures
        // TODO: - come back to this later and make it nice
        oneFingerUpTapGestureRecognizer.isEnabled = false
        oneFingerDownTapGestureRecognizer.isEnabled = false
        twoFingerUpTapGestureRecognizer.isEnabled = false
        twoFingerDownTapGestureRecognizer.isEnabled = false
        oneFingerUpLongPressGestureRecognizer.isEnabled = false
        //oneFingerDownLongPressGestureRecognizer.isEnabled = false
        twoFingerUpLongPressGestureRecognizer.isEnabled = false
        twoFingerDownLongPressGestureRecognizer.isEnabled = false
        
        oneFingerUpTapGestureRecognizer.isEnabled = true
        oneFingerDownTapGestureRecognizer.isEnabled = true
        twoFingerUpTapGestureRecognizer.isEnabled = true
        twoFingerDownTapGestureRecognizer.isEnabled = true
        oneFingerUpLongPressGestureRecognizer.isEnabled = true
        //oneFingerDownLongPressGestureRecognizer.isEnabled = true
        twoFingerUpLongPressGestureRecognizer.isEnabled = true
        twoFingerDownLongPressGestureRecognizer.isEnabled = true
    }
    
    // Called when the one finger hold is stopped. This stops the timer so the
    // number stops changing. The time delta is reset to prepare for the next hold.
    private func oneFingerHoldDidStop() {
        holdTimer.invalidate()
        holdTimerDelta = 0.1
    }
    
    // Every time the hold timer triggers another hold timer is created. This
    // method returns a new timer. This is used to reduce the code in the
    // handleOneFingerHoldUp() and handleOneFingerHoldDown() methods.
    private func newHoldTimer(_ selector: Selector ) -> Timer {
        return Timer.scheduledTimer(timeInterval: holdTimerDelta,
                                    target: self,
                                    selector: selector,
                                    userInfo: nil,
                                    repeats: false)
    }
    
    
    // This is used when the player activates the one finger hold up on the counter.
    // This method recursivly calls itself to change the counter value while
    // the player is holding up.
    @objc private func handleOneFingerHoldUp() {
        holdTimer = newHoldTimer(#selector(handleOneFingerHoldUp))

        // If exponential is chosen, the time between number changes decreases
        // while holding. Thus speading up the changes.
        if UserPreferences.oneFingerHold == 2 {
            holdTimerDelta /= 1.02
        }
        
        incrementValue(by: 1)
    }
    
    // This is used when the player activates the one finger hold down on the counter.
    // This method recursivly calls itself to change the counter value while
    // the player is holding down.
    @objc private func handleOneFingerHoldDown() {
        holdTimer = newHoldTimer(#selector(handleOneFingerHoldDown))
        
        // If exponential is chosen, the time between number changes decreases
        // while holding. Thus speading up the changes.
        if UserPreferences.oneFingerHold == 2 {
            holdTimerDelta /= 1.02
        }
    
        decrementValue(by: 1)
    }
    
    
    
    /*******************************/
    /** Gesture - Two Finger Hold **/
    /*******************************/
    
    // If the counter is not infinite this performs the actions set by the user
    // for two finger holds. Otherwise it just removed infinity.
    @objc private func twoFingerHoldUpRecognized(sender: UITapGestureRecognizer) {
        if isInfinite {
            if sender.state == .began {
                removeInfinity(animated: true)
            }
        } else {
            if sender.state == .began {
                switch UserPreferences.twoFingerHold {
                case 1: reset(animated: true, writeToHistory: true)
                case 2: makeCounterPositiveInfinity()
                default: ()
                }
            }
        }
    }
    
    // If the counter is not infinite this performs the actions set by the user
    // for two finger holds. Otherwise it just removed infinity.
    @objc private func twoFingerHoldDownRecognized(sender: UITapGestureRecognizer) {
        if isInfinite {
            if sender.state == .began {
                removeInfinity(animated: true)
            }
        } else {
            if sender.state == .began {
                switch UserPreferences.twoFingerHold {
                case 1: reset(animated: true, writeToHistory: true)
                case 2: makeCounterNegativeInfinity()
                default: ()
                }
            }
        }
    }
 
    
    /*****************************/
    /******** Number Label *******/
    /*****************************/
    
    // Configures the large number label in the middle of the counter that takes
    // up the entire counter.
    private func configureNumberLabel() {
        let xOrigin    = leftPadding/2 - rightPadding/2
        let yConstant  = topPadding/2 - bottomPadding/2
        let yOrigin    = view.bounds.height/2 - fontSize/2 + yConstant
        numberLabel.textColor     = accentColor
        numberLabel.textAlignment = .center
        numberLabel.font          = UIFont.dense(size: fontSize)
        numberLabel.text          = currentValue.description
        numberLabel.frame.origin  = CGPoint(x: xOrigin, y: yOrigin)
        numberLabel.frame.size    = CGSize(width: view.bounds.width, height: fontSize)
    }
    

    
    /*****************************/
    /********** Infinity *********/
    /*****************************/
    
    // Places the infinity image view in the same position as the number label.
    // The infinity image view originally starts with no image.
    private func configureInfinityImageView() {
        let xOrigin = view.bounds.width/2 - numberLabel.frame.height/2
        let xOffset = leftPadding/2 - rightPadding/2
        let yOrigin = view.bounds.height/2 - numberLabel.frame.height/2
        let yOffset = topPadding/2 - bottomPadding/2
        let size    = numberLabel.frame.height
        infinityImageView.tintColor    = accentColor
        infinityImageView.frame.origin = CGPoint(x: xOrigin + xOffset, y: yOrigin + yOffset)
        infinityImageView.frame.size   = CGSize(width: size, height: size)
    }
    
    // Called when the user makes the counter positive infinity by holding
    // two fingers on the up button.
    private func makeCounterPositiveInfinity() {
        animateInfinityEntrance(fromActivationOf: upButton)
        if !UserPreferences.historyHidesCounters {
            let event = HistoryItem(time: NSDate().timeIntervalSince1970,
                                    image: .positiveInfinity,
                                    icon: iconImage)
            game.transcribeEvent(forPlayer: hostPlayer, event: event)
        }
    }
    
    // Called when the user makes the counter negative infinity by holding
    // two fingers on the down button.
    private func makeCounterNegativeInfinity() {
        animateInfinityEntrance(fromActivationOf: downButton)
        if !UserPreferences.historyHidesCounters {
            let event = HistoryItem(time: NSDate().timeIntervalSince1970,
                                    image: .negativeInfinity,
                                    icon: iconImage)
            game.transcribeEvent(forPlayer: hostPlayer, event: event)
        }
    }

    // Removes the infinity and the counter is put back to the way it was
    // prior to going infinite.
    private func removeInfinity(animated: Bool) {
        isInfinite = false
        numberLabel.isHidden = false
        infinityImageView.image = nil
        if animated {
            flashElement(view, toColor: UIColor.white.withAlphaComponent(0.5))
        }
    }
    
    // Called when the counter goes infinite. The button responsible for making
    // the infinity flashes white, the number label is hidden, and the counter
    // becomes either positive or negative infinity.
    private func animateInfinityEntrance(fromActivationOf button: UIButton) {
        flashElement(button, toColor: UIColor.white.withAlphaComponent(0.5))
        isInfinite = true
        numberLabel.isHidden = true
        infinityImageView.image = button.isEqual(upButton) ? .positiveInfinity : .negativeInfinity
        popInInfinity()
        addInfinityExplosion()
    }
    
    // Uses a spring animation to make the infinity image view pop in naturally.
    private func popInInfinity() {
        infinityImageView.alpha = 0.0
        infinityImageView.transform = CGAffineTransform.init(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 30,
                       options: .curveEaseOut,
                       animations: {
                        self.infinityImageView.alpha = 1.0
                        self.infinityImageView.transform = CGAffineTransform.identity
        })
    }
    
    // When the counter becomes infinite this adds a nice particle effect to the
    // background of the counter.
    private func addInfinityExplosion() {
        // The cells for the explosion
        let cell = CAEmitterCell()
        cell.birthRate     = 80
        cell.lifetime      = 1.5
        cell.lifetimeRange = 0.25
        cell.velocity      = 60
        cell.velocityRange = 50
        cell.emissionRange = CGFloat.pi * 2.0
        cell.color         = UIColor.black.cgColor
        cell.contents      = UIImage.emitterCircle.cgImage
        cell.scale         = 0.05
        cell.scaleRange    = 0.3
        cell.alphaSpeed    = -1/cell.lifetime
        cell.alphaRange    = 0
        
        // The explosion
        let emitter = CAEmitterLayer()
        emitter.emitterSize     = CGSize(width:fontSize, height:fontSize)
        emitter.emitterPosition = infinityImageView.center
        emitter.emitterShape    = CAEmitterLayerEmitterShape.circle
        emitter.emitterMode     = CAEmitterLayerEmitterMode.outline
        emitter.emitterCells    = [cell]
        view.layer.insertSublayer(emitter, at: 0)
        
        // Makes the explosion last a finite amount of time.
        let birthRateAnimation = CABasicAnimation(keyPath: "birthRate")
        let timingName         = CAMediaTimingFunctionName.easeOut
        let timingFunciton     = CAMediaTimingFunction(name: timingName)
        birthRateAnimation.fromValue             = 1.0
        birthRateAnimation.toValue               = 0.0
        birthRateAnimation.fillMode              = CAMediaTimingFillMode.forwards
        birthRateAnimation.isRemovedOnCompletion = false
        birthRateAnimation.duration              = 0.05
        birthRateAnimation.timingFunction        = timingFunciton
        emitter.add(birthRateAnimation, forKey: "birthRate")
    }
    
    

    /*****************************/
    /********* Icon Image ********/
    /*****************************/
    
    // Configures the little icon that appears under the number label. This icon
    // represents the type of resource the counter keeps track of.
    private func configureIconImageView() {
        let xOffset = leftPadding/2 - rightPadding/2
        let yOffset = topPadding/2 - bottomPadding/2
        let xOrigin = view.bounds.width/2 - iconSize.width/2 + xOffset
        let yOrigin = view.bounds.height/2 + fontSize/2 + yOffset - 15
        iconImageView.image        = iconImage
        iconImageView.tintColor    = accentColor
        iconImageView.frame.origin = CGPoint(x: xOrigin, y: yOrigin)
        iconImageView.frame.size   = iconSize
    }
    
    /*****************************/
    /******* Seperator Bar *******/
    /*****************************/
    
    // The seperator bar is added to the right of every counter. If the player
    // style is inverted the seperator bars are hidden.
    private func configureSeperatorBar() {
        let width: CGFloat = 3
        let height: CGFloat = view.bounds.height
        seperatorBar.backgroundColor = UIColor.black.withAlphaComponent(0.15).cgColor
        seperatorBar.frame.origin = CGPoint(x: view.bounds.width - width/2, y: 0)
        seperatorBar.frame.size = CGSize(width: width, height: height)
        
        if UserPreferences.invertedPlayerStyle {
            toggleSeperatorBar(false)
        }
    }
    
    // The player uses this method to toggle the most rightmost seperator bar off.
    // The counter object itself does not know that it is the most rightmost one.
    public func toggleSeperatorBar(_ barVisibility: Bool) {
        seperatorBar.isHidden = !barVisibility
    }
    
    /*****************************/
    /********** Buttons **********/
    /*****************************/
    
    // Configures the increment and decrement buttons positions within the counter.
    private func configureButtons() {
        let offset = topPadding/2 - bottomPadding/2
        let height = view.bounds.height
        let width  = view.bounds.width
        upButton.frame.origin = CGPoint(x: 0, y: 0)
        upButton.frame.size   = CGSize(width: width, height: height/2 + offset)
        downButton.frame.origin = CGPoint(x: 0, y: height/2 + offset)
        downButton.frame.size   = CGSize(width: width, height: height/2 - offset)
    }
    
    /*****************************/
    /********** Padding **********/
    /*****************************/
    
    // Called from the player when the counters are set up. This makes sure
    // the elements in the counter are offset the correct amounts if they are
    // on the edge of the phone.
    public func setPadding(top: CGFloat, left: CGFloat, right: CGFloat, bottom: CGFloat) {
        topPadding    = top
        leftPadding   = left
        rightPadding  = right
        bottomPadding = bottom
        configureNumberLabel()
        configureIconImageView()
        configureInfinityImageView()
        configureButtons()
    }
    
    /*****************************/
    /******* Value Editing *******/
    /*****************************/
    
    // Updates the value of the counter and displays it on the number label.
    // The change is recorded in the game history.
    public func setValue(_ newValue: Int, writeToHistory: Bool) {
        currentValue = newValue
        numberLabel.text = newValue.description
        if writeToHistory && !UserPreferences.historyHidesCounters {
            let event = HistoryItem(time: NSDate().timeIntervalSince1970,
                                    value: newValue,
                                    icon: iconImage)
            game.transcribeEvent(forPlayer: hostPlayer, event: event)
        }
    }
    
    // Increases the counter by the given amount and dims the up button.
    public func incrementValue(by increment: Int) {
        setValue(currentValue + increment, writeToHistory: true)
        flashElement(upButton, toColor: accentColor.withAlphaComponent(0.3))
    }
    
    // Decreases the counter by the given amount and dims the down button.
    public func decrementValue(by decrement: Int) {
        setValue(currentValue - decrement, writeToHistory: true)
        flashElement(downButton, toColor: accentColor.withAlphaComponent(0.3))
    }
    
    /*****************************/
    /********* Animations ********/
    /*****************************/

    // Flashes the given element the given color. Used when the counters
    // value is changed, when the counter is reset, or when infinity is removed.
    private func flashElement(_ element: UIView, toColor color: UIColor) {
        let dimColor     = color
        let presentation = element.layer.presentation()
        let currentVal   = presentation?.value(forKeyPath: "backgroundColor")
        let clear        = UIColor.clear.cgColor
        let dim          = CAKeyframeAnimation()
        dim.keyPath      = "backgroundColor"
        dim.values       = [currentVal ?? clear, dimColor.cgColor, clear]
        dim.keyTimes     = [0.0, 0.4, 1.0]
        dim.duration     = 0.3
        element.layer.add(dim, forKey: "dim")
    }
    
    /*****************************/
    /*********** Other ***********/
    /*****************************/
    
    // Called when the counter is displayed by the player. The accent color is
    // black if the player has a colored background, and it is the player
    // color if the player is black.
    public func setAccentColor(_ newColor: UIColor) {
        if UserPreferences.invertedPlayerStyle {
            accentColor = newColor
            numberLabel.textColor = newColor
            iconImageView.tintColor = newColor
        }
    }
    
    // Resets the counter to its inital value.
    // If the parameter is true the entire counter flashes white.
    public func reset(animated: Bool, writeToHistory: Bool) {
        removeInfinity(animated: false)
        setValue(initialValue, writeToHistory: writeToHistory)
        if animated {
            flashElement(view, toColor: UIColor.white.withAlphaComponent(0.5))
        }
    }
}
