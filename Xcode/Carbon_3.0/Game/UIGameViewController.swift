//
//  UIGameViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/3/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit
//import AVFoundation
//import MediaPlayer

///////////////////////////////////////////
// MARK: - UIGameViewControllerTimeDelegate
///////////////////////////////////////////
protocol UIGameViewControllerTimeDelegate {
    func timeDidChange(toTime time: Int)
    func timerDidChange(toState running: Bool)
}

///////////////////////////////
// MARK: - UIGameViewController
///////////////////////////////
class UIGameViewController: UIViewController {
    
    //////////////////////////////
    // MARK: Variables: Delegation
    //////////////////////////////
    public var auxiliaryTimeMenu: UIGameViewControllerTimeDelegate?
    
    /////////////////////////////
    // MARK: Variables: Constants
    /////////////////////////////
    private let rotationNone: CGFloat  = 0
    private let rotationRight: CGFloat = .pi/2
    
    ///////////////////////////////
    // MARK: Variables: Menu Button
    ///////////////////////////////
    private var menuButton             = UIButton()
    private var menuButtonFont         = UIFont.dense(size: 50)
    private var menuButtonColor        = UIColor.black
    private var menuButtonCornerRadius = CGFloat(30)
    private var menuButtonTintColor    = UIColor.white
    private var menuButtonTextColor    = UIColor.white
    private var menuButtonDefaultSize  = CGSize(width: 60, height: 60)
    private var menuButtonExpandedSize = CGSize(width: 120, height: 60)

    ///////////////////////////
    // MARK: Variables: Players
    ///////////////////////////
    private var players = [UIPlayerViewController]()
    public static let playerSeparation: CGFloat = 10
    
    ////////////////////////////////
    // MARK: Variables: Match Timing
    ////////////////////////////////
    private var matchTimer            = Timer()
    private var initialTime           = 3000
    private var currentTime           = 3000
    private var shouldAlertAtEnd      = false
    private var shouldAlertAtFive     = false
    private var shouldAlertAtTen      = false
    private var shouldDisplayTime     = false
    private var timeAlertSize         = CGSize(width: 300, height: 210)
    private var timeAlert10MinTitle   = "10 Mins Left"
    private var timeAlert10MinMessage = "Don't worry, you dont have to panic yet."
    private var timeAlert5MinTitle    = "5 Mins Left"
    private var timeAlert5MinMessage  = "Ok, now is when you should start panicking."
    private var timeAlertEndTitle     = "Time is Up!"
    private var timeAlertEndMessage   = "Pencils down everyone!"
    
    ///////////////////////////
    // MARK: Variables: History
    ///////////////////////////
    private var transcribedItems = [UIPlayerViewController : [TimeInterval : HistoryItem]]()

    /////////////////////////////
    // MARK: Variables: Overrides
    /////////////////////////////
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return UIRectEdge.all
    }
    
    //////////////////////////////////////
    // MARK: Variables: Computed Variables
    //////////////////////////////////////
    public var numberOfPlayers: Int {
        return Setup.layout.parameters.count
    }
    
    ///////////////////////
    // MARK: Initialization
    ///////////////////////
    init() {
        super.init(nibName: nil, bundle: nil)
        initializePlayerControllers()
        initializeSubviewHierarchy()
        initializeInitialHistoryItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // We start by initializing the player controllers. Their frames are set
    // later on.
    private func initializePlayerControllers() {
        for (i, params) in Setup.layout.parameters.enumerated() {
            let color = Setup.colors[i]
            players.append(UIPlayerViewController(color: color, params: params))
        }
    }
    
    // We get all these in place at the begining. Makes life easier later.
    private func initializeSubviewHierarchy() {
        players.forEach({view.addSubview($0.view)})
        view.addSubview(menuButton)
        view.bringSubviewToFront(menuButton)
    }
    
    // At the start of the game, an entry for initial life totals are added to
    // the history. This is called after the players are initialized.
    private func initializeInitialHistoryItems() {
        for player in players {
            let value = Setup.life!
            let icon  = UIImage.counterLife
            let item  = HistoryItem(time: 0.0, value: value, icon: icon)
            transcribedItems[player] = [0.0 : item]
        }
    }
    
    //////////////////
    // MARK: Lifecycle
    //////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMenuButton()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.bringSubviewToFront(menuButton)
    }

    ////////////////
    // MARK: History
    ////////////////
    public func transcribeEvent(forPlayer player: UIPlayerViewController, event: HistoryItem) {
        transcribedItems[player]![event.time] = event
    }
    
    public func getTranscribedTimes() -> [TimeInterval] {
        var times = [TimeInterval]()
        transcribedItems.values.forEach({times.append(contentsOf: $0.keys)})
        times.sort()
        times.removeDuplicates()
        return times
    }
    
    public func getPlayers(withEventAtTime time: TimeInterval) -> [UIPlayerViewController] {
        var playerList = [UIPlayerViewController]()
        for player in transcribedItems.keys {
            if transcribedItems[player]!.keys.contains(time) {
                playerList.append(player)
            }
        }
        return playerList
    }
    
    public func getEvent(forPlayer player: UIPlayerViewController, atTime time: TimeInterval) -> HistoryItem {
        return transcribedItems[player]![time]!
    }
    
    //////////////////////
    // MARK: Shake Gesture
    //////////////////////
    
    // Makes the view controller able to recognize motion.
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    // Called when motion events occur. We only are interested in the shake gesture.
    // The shake gesture quickly opens one of the menu pages or activates one of
    // the menu funcitons.
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            switch UserPreferences.shakeGesture {
            case 1: openMenuToPage(.timer)
            case 2: resetGame()
            case 3: openMenuToPage(.names)
            case 4: openMenuToPage(.chooser)
            case 5: openMenuToPage(.history)
            case 6: openMenuToPage(.dice)
            default: () // Shake gesture is off.
            }
        }
    }
    
    ////////////////////
    // MARK: Menu Button
    ////////////////////
    
    // Called when the game is loaded but also when the button needs to be resized
    // by the match timing funcitons.
    private func configureMenuButton() {
        let selector = #selector(menuButtonPressed)
        let rotation = calculateMenuButtonRotation()
        let size     = calculateMenuButtonSize()
        let origin   = calculateMenuButtonOrigin()
        let image    = getMenuButtonBackgroundImage()
        menuButton.backgroundColor    = menuButtonColor
        menuButton.layer.cornerRadius = menuButtonCornerRadius
        menuButton.tintColor          = menuButtonTintColor
        menuButton.titleLabel?.font   = menuButtonFont
        menuButton.transform          = CGAffineTransform.init(rotationAngle: rotation)
        menuButton.frame              = CGRect(origin: origin, size: size)
        menuButton.setBackgroundImage(image, for: .normal)
        menuButton.setTitleColor(menuButtonTextColor, for: .normal)
        menuButton.addTarget(self, action: selector, for: .touchUpInside)
        updateMenuButtonTextIfNeeded()
    }
    
    // There are only three layouts where the menu button is rotated.
    private func calculateMenuButtonRotation() -> CGFloat {
        let curr = Setup.layout!
        if curr == .one || curr == .twoB || curr == .fiveB {
            return rotationRight
        } else {
            return rotationNone
        }
    }
    
    // Returns the origin of the menu button.
    private func calculateMenuButtonOrigin() -> CGPoint {
        let screen     = UIScreen.main.bounds
        let seperation = UIGameViewController.playerSeparation
        let size       = calculateMenuButtonSize()
        switch Setup.layout! {
        case .one:
            // We position the bottom in the bottom right corner of the screen
            let xOrigin = screen.width - size.width - 10
            let yOrigin = screen.height - size.height - 10
            return CGPoint(x: xOrigin, y: yOrigin)
        case .twoB:
            // We position the button at the top right of the bottom player
            let params  = CBParameters.init(layout: .twoB, edge: .bottom)
            let frame   = params.frame(within: screen, seperation: seperation)
            let xOrigin = screen.width - size.width - seperation
            let yOrigin = frame.origin.y - size.height/2 - seperation/2
            return CGPoint(x: xOrigin, y: yOrigin)
        case .twoA, .three, .fourB, .fiveA:
            // We position the button at the top center of the bottom player
            let params  = CBParameters.init(layout: Setup.layout, edge: .bottom)
            let frame   = params.frame(within: screen, seperation: seperation)
            let xOrigin = frame.width/2 - size.width/2
            let yOrigin = frame.origin.y - size.height/2 - seperation/2
            return CGPoint(x: xOrigin, y: yOrigin)
        case .fourA, .fiveB, .sixA, .sixB:
            // We position the button at the top right of the bottom left player
            let params  = CBParameters.init(layout: Setup.layout, edge: .botLeft)
            let frame   = params.frame(within: screen, seperation: seperation)
            let xOrigin = frame.width - size.width/2 + seperation/2
            let yOrigin = frame.origin.y - size.height/2 - seperation/2
            return CGPoint(x: xOrigin, y: yOrigin)
        }
    }
    
    // Returns the size that the menu button should be. If the menu button is
    // rotated the size is returned with a flipped width and height. 
    private func calculateMenuButtonSize() -> CGSize {
        let rotation = calculateMenuButtonRotation()
        
        if rotation == rotationNone && !shouldDisplayTime {
            return menuButtonDefaultSize
        } else if rotation == rotationNone && shouldDisplayTime {
            return menuButtonExpandedSize
        } else if !shouldDisplayTime {
            return menuButtonDefaultSize.flippedWithAndHeight()
        } else {
            return menuButtonExpandedSize.flippedWithAndHeight()
        }
        
    }
    
    // Returns the D20 icon that should be shown on the menu button.
    // Otherwise it returns nil if the menu button is showing time instead.
    private func getMenuButtonBackgroundImage() -> UIImage? {
        return shouldDisplayTime ? nil : .d20
    }
    
    // Used by the timer to update the time shown on the menu button.
    private func updateMenuButtonTextIfNeeded() {
        if shouldDisplayTime {
            let mins = currentTime / 60
            let secs = currentTime % 60
            let minText = mins < 10 ? "0" + mins.description : mins.description
            let secText = secs < 10 ? "0" + secs.description : secs.description
            menuButton.setTitle(minText + ":" + secText, for: .normal)
        } else {
            menuButton.setTitle(nil, for: .normal)
        }
    }
    
    // Called when a user presses the D20 button in the middle of the game.
    // The in game menu is opened to the main page.
    @objc private func menuButtonPressed(_ sender: UIAnimatableButton) {
        openMenuToPage(.main)
    }
    
    
    //////////////
    // MARK: Reset
    //////////////
    public func resetGame() {
        
        if UserPreferences.shouldResetTimer {
            cancelMatchTimer()
        }
        
        if UserPreferences.shouldRemoveCounters {
            players.forEach({$0.reset(removeCounters: true)})
        } else {
            players.forEach({$0.reset(removeCounters: false)})
        }
        
        if UserPreferences.shouldKeepHistory {
            let timeOfReset = NSDate().timeIntervalSince1970
            for player in players {
                let item = HistoryItem(time: timeOfReset,
                                       value: Setup.life,
                                       icon: .counterLife)
                transcribedItems[player]![timeOfReset] = item
            }
        } else {
            for player in players {
                let initialEntry  = transcribedItems[player]![0.0]
                transcribedItems[player]?.removeAll()
                transcribedItems[player]![0.0] = initialEntry
            }
        }

    }
    
    /////////////////////
    // MARK: Match Timing
    /////////////////////
    
    // Returns the time that the timer counts down from.
    public func getInitialTime() -> Int {
        return initialTime
    }
    
    // Sets the time that the timer will start with.
    public func setInitialTime(_ newInitialTime: Int) {
        initialTime = newInitialTime
        auxiliaryTimeMenu?.timeDidChange(toTime: currentTime)
        updateMenuButtonTextIfNeeded()
    }
    
    // Returns the time left on the timer.
    public func getCurrentTime() -> Int {
        return currentTime
    }
    
    // Sets the currentlt time left on the timer.
    // Updates needed components for the change.
    public func setCurrentTime(_ newCurrentTime: Int) {
        currentTime = newCurrentTime
        auxiliaryTimeMenu?.timeDidChange(toTime: currentTime)
        updateMenuButtonTextIfNeeded()
    }
    
    // Returns true id the current time is not equal to the initial time.
    public func hasTimePassed() -> Bool {
        return currentTime != initialTime
    }
    
    // Returns true if the match timer is currently running.
    public func isTimerRunning() -> Bool {
        return matchTimer.isValid
    }
    
    // Starts the timer from the initial time.
    public func startMatchTimer() {
        currentTime = initialTime
        matchTimer = newMatchTimer()
        auxiliaryTimeMenu?.timerDidChange(toState: true)
        updateMenuButtonTextIfNeeded()
    }
    
    // Stops the timer and updates needed components.
    public func pauseMatchTimer() {
        if isTimerRunning() {
            matchTimer.invalidate()
        }
        auxiliaryTimeMenu?.timeDidChange(toTime: currentTime)
        auxiliaryTimeMenu?.timerDidChange(toState: false)
        updateMenuButtonTextIfNeeded()
    }
    
    // Starts the timer from the last known time.
    // Updates needed components.
    public func resumeMatchTimer() {
        matchTimer = newMatchTimer()
        auxiliaryTimeMenu?.timeDidChange(toTime: currentTime)
        auxiliaryTimeMenu?.timerDidChange(toState: false)
        updateMenuButtonTextIfNeeded()
    }
    
    // Stops the timer. Resets the time. Updates needed components.
    public func cancelMatchTimer() {
        pauseMatchTimer()
        currentTime = initialTime
        auxiliaryTimeMenu?.timeDidChange(toTime: currentTime)
        auxiliaryTimeMenu?.timerDidChange(toState: false)
        updateMenuButtonTextIfNeeded()
    }
    
    // Toggled if the timer will send an alert when the time runs out.
    public func toggleAlertAtEnd() {
        shouldAlertAtEnd.toggle()
    }
    
    // Toggled if the timer will send an alert when the time hits 5 mins.
    public func toggleAlertAtFive() {
        shouldAlertAtFive.toggle()
    }
    
    // Toggled if the timer will send an alert when the time hits 10 mins.
    public func toggleAlertAtTen() {
        shouldAlertAtTen.toggle()
    }
    
    // Toggled if the menu button will show the current time.
    public func toggleDisplayTime() {
        shouldDisplayTime.toggle()
        configureMenuButton()
    }
    
    // Returns true if an alert will appear when the time runs out.
    public func willAlertAtEnd() -> Bool {
        return shouldAlertAtEnd
    }
    
    // Returns true if an alert will appear when the time hits 5 mins.
    public func willAlertAtFive() -> Bool {
        return shouldAlertAtFive
    }
    
    // Returns true if an alert will appear when the time hits 10 mins.
    public func willAlertAtTen() -> Bool {
        return shouldAlertAtTen
    }
    
    // Returns true if the menu button is showing the time.
    public func isDisplayingTime() -> Bool {
        return shouldDisplayTime
    }
    
    // Used whever the timer needs to start. Returns a new timer that should
    // be used to assign to the 'matchTimer' variable.
    private func newMatchTimer() -> Timer {
        return Timer.scheduledTimer(timeInterval: 1.0,
                                    target: self,
                                    selector: #selector(subtractSecond),
                                    userInfo: nil,
                                    repeats: true)
    }
    
    // Called when a second shuld pass. Updates needed components. If the timer
    // hits 00:00 then the timer stops. If the timer needs to present an alert
    // one will be presented.
    @objc private func subtractSecond() {
        
        if currentTime == 0 {
            pauseMatchTimer()
            auxiliaryTimeMenu?.timerDidChange(toState: false)
        } else {
            currentTime -= 1
            auxiliaryTimeMenu?.timerDidChange(toState: true)
        }

        if currentTime == 0 {
            let alert = UIWonderfulAlert(title: timeAlertEndTitle,
                                         message: timeAlertEndMessage)
            present(alert, animated: false, completion: nil)
        }
        
        if currentTime == 300 {
            let alert = UIWonderfulAlert(title: timeAlert5MinTitle,
                                         message: timeAlert5MinTitle)
            present(alert, animated: false, completion: nil)
        }
        
        if currentTime == 600 {
            let alert = UIWonderfulAlert(title: timeAlert10MinTitle,
                                         message: timeAlert10MinTitle)
            present(alert, animated: false, completion: nil)
        }
        
        auxiliaryTimeMenu?.timeDidChange(toTime: currentTime)
        updateMenuButtonTextIfNeeded()
    }
    
    ////////////////////////////
    // MARK: Helpers & Utilities
    ////////////////////////////
    
    // Used to open the in game menu to the given page.
    private func openMenuToPage(_ page: UIMenuPageViewController.UIMenuPage) {
        let menu = UIMenuPageViewController(page: page)
        menu.modalTransitionStyle = .crossDissolve
        menu.modalPresentationStyle = .overCurrentContext
        present(menu, animated: false)
    }
    
    // Called when a player becomes monarch. Only one player can be monarch
    // so we need to remove it form all other player aside form the one
    // that has just become monarch.
    public func removeMonarchFromAllPlayers(asideFrom exemptPlayer: UIPlayerViewController) {
        for player in players {
            if player != exemptPlayer {
                player.toggleMonarch(false)
            }
        }
    }
    
    // Returns the players in the current game.
    public func getPlayers() -> [UIPlayerViewController] {
        return players
    }
    
    public func getPlayer(atIndex index: Int) -> UIPlayerViewController {
        if index < players.count {
            return players[index]
        } else {
            fatalError("No player at index")
        }
    }
}
