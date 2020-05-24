//
//  UIPlayerViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/3/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UIPlayerViewController: UIViewController {
    
    //////////////////////////////
    // MARK: - Animation Variables
    //////////////////////////////
    private let entranceAnimationDuration: TimeInterval    = 0.2
    private let entranceAnimationDelay: TimeInterval       = 0.2
    private let auxiliaryIconBounceKeyPath: String         = "transform.scale"
    private let auxiliaryIconBounceScaleValues: [NSNumber] = [1.0,0.9,1.0]
    private let auxiliaryIconBounceScaleTimes: [NSNumber]  = [0.0,0.4,1.0]
    private let auxiliaryIconBounceDuration: TimeInterval  = 0.2
    private let auxiliaryIconBounceKey: String             = "Bounce"
    
    /////////////////////////////////////
    // MARK: - Auxiliary Button Variables
    /////////////////////////////////////
    private var colorsImageView   = UIImageView(image: .colors)
    private var effectsImageView  = UIImageView(image: .effects)
    private var countersImageView = UIImageView(image: .counters)
    private var colorsLabel       = UILabel(text: "COLORS")
    private var effectsLabel      = UILabel(text: "EFFECTS")
    private var countersLabel     = UILabel(text: "COUNTERS")
    private var colorsButton      = UIButton()
    private var effectsButton     = UIButton()
    private var countersButton    = UIButton()
    private let auxLabelSize      = CGSize(width: 130, height: 30)
    private let auxIconOffset     = CGFloat(-6)
    
    /////////////////////////////////////////
    // MARK: - Main Vertical Scroll Variables
    /////////////////////////////////////////
    private let handleHeight: CGFloat  = 4
    private let handleWidth: CGFloat   = 44
    private let handlePadding: CGFloat = 5
    private var verticalScrollView = UIScrollView()
    private var scrollHandle       = UIView()
    private var minimumScrollOffset: CGFloat {
        return bottomPadding + handleHeight + 2*handlePadding
    }
    
    ////////////////////////////
    // MARK: - Counter Variables
    ////////////////////////////
    private var horizontalScrollView = UIScrollView()
    private var counters = [UICounterViewController]()
    private let minimumCounterWidth: CGFloat = 90
    private let counterViewTag = 999

    ///////////////////////////
    // MARK: - Player Variables
    ///////////////////////////
    private let backgroundColor: UIColor = UIColor.init(hexVal: 0x262633)
    private let cornerRadius: CGFloat  = 15
    private var color: UIColor!
    private var params: CBParameters!
    
    ///////////////////////////////////
    // MARK: - Citys Blessing Variables
    ///////////////////////////////////
    private var cityLayer: CBCityLayer!
    private var isBlessed: Bool = false
    private let cityAlpha: Float = 0.2
    
    ////////////////////////////
    // MARK: - Monarch Variables
    ////////////////////////////
    private var isMonarch: Bool                    = false
    private let trumpitShadowColor: UIColor        = .black
    private let trumpitShadowOffset: CGSize        = .zero
    private let trumpitShadowOpacity: Float        = 0.2
    private let trumpitShadowRadius: CGFloat       = 5
    private var leftTrumpitImageView: UIImageView  = UIImageView(image: .leftTrumpit)
    private var rightTrumpitImageView: UIImageView = UIImageView(image: .rightTrumpit)
    private var trumpetOffset: CGFloat {
        return view.bounds.height/7
    }
    private var trumpetSize: CGSize {
        let size = view.bounds.width/3
        return CGSize(width: size, height: size)
    }
    
    /////////////////////////////////
    // MARK: - Player Death Variables
    /////////////////////////////////
    private var isDead: Bool = false
    private var deathOverlayView: UIView!
    
    //////////////////////////
    // MARK: - Other Variables
    //////////////////////////
    private var topPadding: CGFloat {return params.padding(forSide: .top)}
    private var bottomPadding: CGFloat {return params.padding(forSide: .bottom)}
    private var leftPadding: CGFloat {return params.padding(forSide: .left)}
    private var rightPadding: CGFloat {return params.padding(forSide: .right)}
    
    private var game: UIGameViewController {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.window?.rootViewController as! UIGameViewController
    }


    
    /////////////////////////
    // MARK: - Initialization
    /////////////////////////
    convenience init(color: UIColor, params: CBParameters) {
        self.init()
        self.color  = color
        self.params = params
        initializeSubviewHierarchy()
    }
    
    // We start by adding all subviews in the correct hierarchy. This makes life
    // easier later.
    private func initializeSubviewHierarchy() {
        view.addSubview(colorsImageView)
        view.addSubview(countersImageView)
        view.addSubview(effectsImageView)
        view.addSubview(colorsLabel)
        view.addSubview(countersLabel)
        view.addSubview(effectsLabel)
        view.addSubview(verticalScrollView)
        verticalScrollView.addSubview(colorsButton)
        verticalScrollView.addSubview(effectsButton)
        verticalScrollView.addSubview(countersButton)
        verticalScrollView.addSubview(horizontalScrollView)
        verticalScrollView.addSubview(scrollHandle)
    }
    
    
    ////////////////////
    // MARK: - Lifecycle
    ////////////////////
    
    // Upon loading the player self-rotates and self-positions.
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize = UIScreen.main.bounds
        let separation = UIGameViewController.playerSeparation
        view.transform = CGAffineTransform.init(rotationAngle: params.rotation())
        view.frame     = params.frame(within: screenSize, seperation: separation)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureBackgroundAppearance()
        configureAuxiliaryIconImages()
        configureAuxiliaryLabels()
        configureVerticalScrollView()
        configureAuxiliaryButtons()
        configureHorizontalScrollView()
        configureScrollHandle()
        configureInitialCounters()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performEntranceAnimation()
    }
    
    /////////////////////
    // MARK: - Background
    /////////////////////
    
    // Adds color to the background of the player. This can be seen when the
    // player is scrolled down to reveal the auxiliary buttons. The only exception
    // is in the 'black' theme where the background color is black.
    private func configureBackgroundAppearance() {
        if UserPreferences.invertedPlayerStyle {
            view.layer.backgroundColor = UIColor.black.cgColor
        } else {
            view.layer.backgroundColor = backgroundColor.cgColor
        }
        view.layer.cornerRadius = cornerRadius
    }
    
    ////////////////////////////
    // MARK: - Auxiliary Buttons
    ////////////////////////////
    
    // Returns the size that the colors, effects, and counters icons should be.
    private func calculateAuxiliaryIconSize() -> CGSize {
        let unpaddedWidth = view.bounds.width - leftPadding - rightPadding
        let size = (0.25 * unpaddedWidth/3) + 24
        return CGSize(width: size, height: size)
    }
    
    // Returns the font size of the colors, effects, and counters labels.
    private func calculateAuxiliaryLabelFontSize() -> CGFloat {
        return calculateAuxiliaryIconSize().height/5
    }
    
    // Called in viewDidLayoutSubviews. Adds three icons to the back of the player.
    // One for colors, effects, and counters.
    private func configureAuxiliaryIconImages() {

        let iconSize = calculateAuxiliaryIconSize()
        var yOrigin  = (view.bounds.height - minimumScrollOffset)/2 - iconSize.height/2
        yOrigin += auxIconOffset
        
        // Colors Icon
        var colorsXOrigin = (view.bounds.width * 1.5/7) - iconSize.width/2
        colorsXOrigin += leftPadding
        let colorsOrigin  = CGPoint(x: colorsXOrigin, y: yOrigin)
        colorsImageView.frame.origin = colorsOrigin
        colorsImageView.frame.size   = iconSize
        
        // Effects Icon
        var effectsXOrigin = view.bounds.width/2 - iconSize.width/2
        effectsXOrigin += leftPadding/2 - rightPadding/2
        let effectsOrigin  = CGPoint(x: effectsXOrigin, y: yOrigin)
        effectsImageView.frame.origin = effectsOrigin
        effectsImageView.frame.size   = iconSize
        
        // Counters Icon
        var countersXOrigin = (view.bounds.width * 5.5/7) - iconSize.width/2
        countersXOrigin -= rightPadding
        let countersOrigin  = CGPoint(x: countersXOrigin, y: yOrigin)
        countersImageView.frame.origin = countersOrigin
        countersImageView.frame.size   = iconSize
        
    }
    
    // Called in viewDidLayoutSubviews. Adds three labels under the icons behind the
    // player. One that says 'COLORS', 'EFFECTS', and 'COUNTERS'.
    private func configureAuxiliaryLabels() {

        let iconSize = calculateAuxiliaryIconSize()
        let fontSize = calculateAuxiliaryLabelFontSize()
        var yOrigin  = (view.bounds.height - minimumScrollOffset)/2 + iconSize.height/2
        yOrigin += auxIconOffset
        
        // Colors Label
        var colorsXOrigin = (view.bounds.width * 1.5/7) - auxLabelSize.width/2
        colorsXOrigin += leftPadding
        colorsLabel.font          = UIFont.tondo(weight: .bold, size: fontSize)
        colorsLabel.textColor     = UIColor.white
        colorsLabel.textAlignment = .center
        colorsLabel.frame.origin  = CGPoint(x: colorsXOrigin, y: yOrigin)
        colorsLabel.frame.size    = auxLabelSize
        
        // Effects Label
        var effectsXOrigin = view.bounds.width/2 - auxLabelSize.width/2
        effectsXOrigin += leftPadding/2 - rightPadding/2
        effectsLabel.font          = UIFont.tondo(weight: .bold, size: fontSize)
        effectsLabel.textColor     = UIColor.white
        effectsLabel.textAlignment = .center
        effectsLabel.frame.origin  = CGPoint(x: effectsXOrigin, y: yOrigin)
        effectsLabel.frame.size    = auxLabelSize
        
        // Counters Label
        var countersXOrigin = (view.bounds.width * 5.5/7) - auxLabelSize.width/2
        countersXOrigin -= rightPadding
        countersLabel.font          = UIFont.tondo(weight: .bold, size: fontSize)
        countersLabel.textColor     = UIColor.white
        countersLabel.textAlignment = .center
        countersLabel.frame.origin  = CGPoint(x: countersXOrigin, y: yOrigin)
        countersLabel.frame.size    = auxLabelSize
    }
    
    // Called in viewDidLayoutSubviews, but after the vertical scroll view is added.
    // This adds the three invisible buttons to the player that can be pressed
    // when the player slides down.
    private func configureAuxiliaryButtons() {
        
        let height        = view.bounds.height
        let unpaddedWidth = (view.bounds.width - leftPadding - rightPadding)/3
        let selector      = #selector(auxiliaryButtonPressed)
        
        // Colors Button
        let colorsOrigin           = CGPoint.zero
        let colorsWidth            = unpaddedWidth + leftPadding
        colorsButton.frame.origin  = colorsOrigin
        colorsButton.frame.size    = CGSize(width: colorsWidth, height: height)
        colorsButton.addTarget(self, action: selector, for: .touchUpInside)

        // Effects Button
        let effectsOrigin           = CGPoint(x: colorsWidth, y: 0)
        let effectsWidth            = unpaddedWidth
        effectsButton.frame.origin  = effectsOrigin
        effectsButton.frame.size    = CGSize(width: effectsWidth, height: height)
        effectsButton.addTarget(self, action: selector, for: .touchUpInside)
        
        // Counters Button
        let countersOrigin           = CGPoint(x: colorsWidth + effectsWidth, y: 0)
        let countersWidth            = unpaddedWidth + rightPadding
        countersButton.frame.origin  = countersOrigin
        countersButton.frame.size    = CGSize(width: countersWidth, height: height)
        countersButton.addTarget(self, action: selector, for: .touchUpInside)
    }
    
    // Called whenever any of the three invisible auxiliary buttons are pressed.
    // Their respective menu is presented in the orientation of the player.
    @objc func auxiliaryButtonPressed(_ sender: UIButton) {
        let auxMenu: UIViewController!
        
        if sender == colorsButton {
            makeIconBounce(colorsImageView)
            auxMenu = UIColorsViewController(player: self)
        } else if sender == effectsButton {
            makeIconBounce(effectsImageView)
            auxMenu = UIEffectsViewController(player: self)
        } else {
            makeIconBounce(countersImageView)
            auxMenu = UICountersViewController(player: self)
        }
        
        auxMenu.modalPresentationStyle = .overCurrentContext
        auxMenu.modalTransitionStyle = .crossDissolve
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.rootViewController?.present(auxMenu, animated: false)
        
    }

    
    ///////////////////////////////
    // MARK: - Main Vertical Scroll
    ///////////////////////////////
    
    // Adds a scroll view to the player. This scroll view will contain three
    // invisible buttons for the auxiliary menus behing the player, and it's bottom
    // half will be filled with a horizontal scroll view that will hold the counters
    // contained within the player.
    private func configureVerticalScrollView() {
        let width = view.bounds.width
        let height = view.bounds.height*2
        verticalScrollView.contentInsetAdjustmentBehavior = .never
        verticalScrollView.showsVerticalScrollIndicator = false
        verticalScrollView.showsHorizontalScrollIndicator = false
        verticalScrollView.isPagingEnabled = true
        verticalScrollView.bounces = false
        verticalScrollView.delegate = self
        verticalScrollView.contentSize = CGSize(width: width, height: height)
        verticalScrollView.frame = view.bounds
        //verticalScrollView.delaysContentTouches = false
    }
    
    // This adds a small handle to the top of the horizontal scroll view. It shows
    // that a user can scroll the player down.
    private func configureScrollHandle() {
        let leftPadding = params.padding(forSide: .left)
        let rightPadding = params.padding(forSide: .right)
        let xOffset = leftPadding/2 - rightPadding/2
        let x = view.bounds.width/2 - handleWidth/2 + xOffset
        let y = view.bounds.height + handlePadding + params.padding(forSide: .top)/2
        
        if UserPreferences.invertedPlayerStyle {
            scrollHandle.backgroundColor = color
        } else {
            scrollHandle.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        }
        
        scrollHandle.frame.size = CGSize(width: handleWidth, height: handleHeight)
        scrollHandle.frame.origin = CGPoint(x: x, y: y)
        scrollHandle.layer.cornerRadius = handleHeight/2
    }

    ///////////////////
    // MARK: - Counters
    ///////////////////
    
    // Adds a horizontal scroll view to the bottom half of the vertical scroll view.
    // This horizontal scroll view will hold all the counters the player has.
    private func configureHorizontalScrollView() {
        horizontalScrollView.backgroundColor = UserPreferences.invertedPlayerStyle ? .black : color
        horizontalScrollView.layer.cornerRadius = cornerRadius
        horizontalScrollView.contentInsetAdjustmentBehavior = .never
        horizontalScrollView.showsVerticalScrollIndicator = false
        horizontalScrollView.showsHorizontalScrollIndicator = false
        horizontalScrollView.frame.origin = CGPoint(x: 0, y: view.bounds.height)
        horizontalScrollView.frame.size = view.bounds.size
        horizontalScrollView.delegate = self
    }
    
    // The initial counters a player starts with are the counters that the user
    // has set as default counters in settings.
    private func configureInitialCounters() {
        for i in UserPreferences.defaultCounters {
            let value = i == 0 ? Setup.life! : 0
            let image = UIImage(counterIconFromInteger: i)
            addCounter(withValue: value, andIconImage: image)
        }
    }
    
    // Called whenever a counter is added or removed from the player.
    // The rightmost counter's seperator bar should be hidden.
    private func refreshCounterSeparatorBars() {
        counters.forEach({$0.toggleSeperatorBar(true)})
        counters.last?.toggleSeperatorBar(false)
    }
    
    // Called whenever a counter is added or removed from the player.
    // This removes subviews from the horizontal scroll view.
    // Then, adds every counter in the counter array back to the horizontal scroll view.
    private func refreshCounterViews() {
        for subview in horizontalScrollView.subviews {
            if subview.tag == counterViewTag {
                subview.removeFromSuperview()
            }
        }
        
        for counter in counters {
            horizontalScrollView.addSubview(counter.view)
        }
    }
    
    // Called whenever a counter is added or removed from the player. This takes
    // every counter's view and resizes it properly for the new amount of counters.
    // The horizontal scrolls views content size is also updated to match the new
    // width of the counters.
    private func resizeCounterViews() {
        let leftPadding   = params.padding(forSide: .left)
        let rightPadding  = params.padding(forSide: .right)
        let unpaddedWidth = view.bounds.width - leftPadding - rightPadding
        var counterWidth  = unpaddedWidth / CGFloat(counters.count)
        
        if counterWidth < minimumCounterWidth {
            counterWidth = minimumCounterWidth
        }
        
        var totalWidthOfCounters: CGFloat = 0
        
        for counter in counters {
            
            var width = counterWidth
            
            if counter.isEqual(counters.first) {
                width += leftPadding
            }
            
            if counter.isEqual(counters.last) {
                width += rightPadding
            }
            
            counter.view.frame.origin = CGPoint(x: totalWidthOfCounters, y: 0)
            counter.view.frame.size = CGSize(width: width, height: view.bounds.height)
            totalWidthOfCounters += width
        }
        
        horizontalScrollView.contentSize = CGSize(width: totalWidthOfCounters,
                                                  height: view.bounds.height)
    }
    
    // Called whenever a counter is added or removed from the player. This
    // updates every counters padding. Counters on the left and right edges
    // have left and right padding respecivly. While all counters have top
    // and bottom padding. The top, left, right, and bottom paddings of the
    // counters are the same as the players padding.
    private func repadCounterViews() {
        for counter in counters {
            
            var leftPadding: CGFloat   = 0
            var rightPadding: CGFloat  = 0
            
            if counter.isEqual(counters.first!) {
                leftPadding = params.padding(forSide: .left)
            }
            if counter.isEqual(counters.last!) {
                rightPadding = params.padding(forSide: .right)
            }
            
            counter.setPadding(top: params.padding(forSide: .top),
                               left: leftPadding,
                               right: rightPadding,
                               bottom: params.padding(forSide: .bottom))
            
        }
    }
    
    // Initializes a new counter and adds it to the player as long as a counter
    // with the given icon does not already exist.
    public func addCounter(withValue value: Int, andIconImage iconImage: UIImage) {
        if !counters.contains(where: {$0.iconImage.pngData() ==  iconImage.pngData()}) {
            let accentColor = UserPreferences.invertedPlayerStyle ? color! : .black
            let newCounter = UICounterViewController(initialValue: value,
                                                     iconImage: iconImage,
                                                     accentColor: accentColor)
            newCounter.view.tag = counterViewTag
            newCounter.hostPlayer = self
            counters.append(newCounter)
            resizeCounterViews()
            refreshCounterViews()
            refreshCounterSeparatorBars()
            repadCounterViews()
        }
    }
    
    // Removes a counter from the player if the player had the counter with the
    // given icon.
    public func removeCounter(withIconImage iconImage: UIImage) {
        if counters.contains(where: {$0.iconImage.isEqual(iconImage)}) {
            counters = counters.filter({!$0.iconImage.isEqual(iconImage)})
            resizeCounterViews()
            refreshCounterViews()
            refreshCounterSeparatorBars()
            repadCounterViews()
        }
       
    }
    
    // Returns an array containing the icons of ever counter the
    // player currently has. This is used by the counter auxiliary menu
    // to determine what counters the player currently has so
    // it can highlight the correct counters.
    public func getCurrentCounterIcons() -> [UIImage] {
        var icons = [UIImage]()
        for counter in counters {
            icons.append(counter.iconImage)
        }
        return icons
    }

    
    /////////////////////
    // MARK: - Animations
    /////////////////////
    private func performEntranceAnimation() {
        animateSlideUp()
    }
    
    // Called when the game starts and when auxiliary menus are closed. Moves the
    // vertical scroll view up so the counters can be seen.
    public func animateSlideUp() {
        UIView.animate(withDuration: entranceAnimationDuration) {
            UIView.setAnimationDelay(self.entranceAnimationDelay)
            let offset = CGPoint(x: 0, y: self.view.bounds.height)
            self.verticalScrollView.setContentOffset(offset, animated: false)
        }
    }
    
    // Called when the auxiliary buttons are pressed. This is used to make the
    // colors, effects, or counters icons bouce. It gives the user some feedback
    // upon a tap.
    private func makeIconBounce(_ icon: UIImageView) {
        let pop      = CAKeyframeAnimation()
        pop.keyPath  = auxiliaryIconBounceKeyPath
        pop.values   = auxiliaryIconBounceScaleValues
        pop.keyTimes = auxiliaryIconBounceScaleTimes
        pop.duration = auxiliaryIconBounceDuration
        icon.layer.add(pop, forKey: auxiliaryIconBounceKey)
    }
    
    ///////////////////////////
    // MARK: - Public Functions
    ///////////////////////////
    
    // Returns the absolute rotation of the current player. The auxiliary
    // menus use this to orient themselvs properly.
    public func rotation() -> CGFloat {
        return params.rotation()
    }

    // Called when a user updates the players color. The components that are
    // colored are different depending on if the user has inverted player
    // style on or off.
    public func setColor(_ newColor: UIColor) {
        self.color = newColor
        if UserPreferences.invertedPlayerStyle {
            scrollHandle.backgroundColor = newColor
            if cityLayer != nil {
                cityLayer.setColor(newColor)
            }
        } else {
            horizontalScrollView.backgroundColor = newColor
        }
        counters.forEach({$0.setAccentColor(newColor)})
    }
    
    public func getColor() -> UIColor {
        return color
    }
    
    /////////////////////////
    // MARK: - Citys Blessing
    /////////////////////////
    
    // Returns true if the player has the citys blessing. Otherwise false.
    public func hasCitysBlessing() -> Bool {
        return isBlessed
    }
    
    // If the parameter is true a city is added to the background of the player.
    // Otherwise the city is removed from the background of the player.
    public func toggleCitysBlessing(_ isBlessed: Bool) {
        self.isBlessed = isBlessed
        if isBlessed {
            let cityColor = UserPreferences.invertedPlayerStyle ? color! : .black
            let width = 3 * view.bounds.width
            let height = view.bounds.height
            let origin = CGPoint(x: -(width/3), y: 0)
            let size = CGSize(width: width, height: height)
            cityLayer = CBCityLayer(color: cityColor.cgColor,
                                    alpha: cityAlpha,
                                    averageBuildingWidth: view.bounds.width/10)
            cityLayer.frame = CGRect(origin: origin, size: size)
            horizontalScrollView.layer.addSublayer(cityLayer)
            cityLayer.animateEntrance()
            addCitysBlessingToGameHistory()
        } else {
            if cityLayer != nil {
                cityLayer.removeFromSuperlayer()
            }
        }
    }
    
    // When a player becomes blessed we add that event to the game history.
    private func addCitysBlessingToGameHistory() {
        let event = HistoryItem(time: NSDate().timeIntervalSince1970, image: .city)
        game.transcribeEvent(forPlayer: self, event: event)
    }
    

    
    //////////////////
    // MARK: - Monarch
    //////////////////
    
    // Returns true is the player is monarch. Otherwise false.
    public func hasMonarch() -> Bool {
        return isMonarch
    }
    
    // When monarch is toggled confetti is falls over the player for a few seconds.
    public func toggleMonarch(_ isMonarch: Bool) {
        self.isMonarch = isMonarch
        
        if isMonarch {
            let confetti = CBConfettiLayer(frame: horizontalScrollView.bounds)
            horizontalScrollView.layer.addSublayer(confetti)
            
            let leftXOrigin  = -trumpetSize.width/4
            let rightXOrigin = view.bounds.width - trumpetSize.width*3/4
            let leftOrigin   = CGPoint(x: leftXOrigin, y: trumpetOffset)
            let rightOrigin  = CGPoint(x: rightXOrigin, y: trumpetOffset)
            let leftFrame    = CGRect(origin: leftOrigin, size: trumpetSize)
            let rightFrame   = CGRect(origin: rightOrigin, size: trumpetSize)
            
            leftTrumpitImageView.frame               = leftFrame
            leftTrumpitImageView.layer.shadowColor   = trumpitShadowColor.cgColor
            leftTrumpitImageView.layer.shadowOffset  = trumpitShadowOffset
            leftTrumpitImageView.layer.shadowOpacity = trumpitShadowOpacity
            leftTrumpitImageView.layer.shadowRadius  = trumpitShadowRadius
            
            rightTrumpitImageView.frame               = rightFrame
            rightTrumpitImageView.layer.shadowColor   = trumpitShadowColor.cgColor
            rightTrumpitImageView.layer.shadowOffset  = trumpitShadowOffset
            rightTrumpitImageView.layer.shadowOpacity = trumpitShadowOpacity
            rightTrumpitImageView.layer.shadowRadius  = trumpitShadowRadius
            
            horizontalScrollView.addSubview(leftTrumpitImageView)
            horizontalScrollView.addSubview(rightTrumpitImageView)
            horizontalScrollView.sendSubviewToBack(leftTrumpitImageView)
            horizontalScrollView.sendSubviewToBack(rightTrumpitImageView)
            
            game.removeMonarchFromAllPlayers(asideFrom: self)
            addMonarchToGameHistory()
        } else {
            leftTrumpitImageView.removeFromSuperview()
            rightTrumpitImageView.removeFromSuperview()
        }
        
    }
    
    // When a player becomes monarch we add this event to the game history.
    private func addMonarchToGameHistory() {
        let event = HistoryItem(time: NSDate().timeIntervalSince1970, image: .crown)
        game.transcribeEvent(forPlayer: self, event: event)
    }
    
    // When the horizontal scroll view scrolls, if the player is monarch, the
    // origin of the trumpits are updated to make it so the trumpits
    // does not also scroll.
    private func updateTrumpitImageViewOriginsIfNeeded(scrollOffset: CGPoint) {
        let newLeftXOrigin  = scrollOffset.x - trumpetSize.width/4
        let newYOrigin      = leftTrumpitImageView.frame.origin.y
        let newLeftOrigin   = CGPoint(x: newLeftXOrigin, y: newYOrigin)
        let oldRightXOrigin = view.bounds.width - trumpetSize.width*3/4
        let newRightXOrigin = scrollOffset.x + oldRightXOrigin
        let newRightOrigin  = CGPoint(x: newRightXOrigin, y: newYOrigin)
        leftTrumpitImageView.frame.origin  = newLeftOrigin
        rightTrumpitImageView.frame.origin = newRightOrigin
    }
    


    ///////////////////////
    // MARK: - Player Death
    ///////////////////////
    
    // Returns true if the player is dead. Otherwise false.
    public func hasPlayerDeath() -> Bool {
        return isDead
    }
    
    // If the parameter is true the a dark overlay with a skull is added blocking
    // the player.
    public func togglePlayerDeath(_ isDead: Bool) {
        self.isDead = isDead
        if isDead {
            addDeathOverlay()
            addDeathToGameHistory()
        } else {
            removeDeathOverlay()
        }
    }
    
    // When a player becomes monarch we add this event to the game history.
    private func addDeathToGameHistory() {
        let event = HistoryItem(time: NSDate().timeIntervalSince1970, image: .death)
        game.transcribeEvent(forPlayer: self, event: event)
    }
    
    // Called when the player toggles player death to true. A dark overlay with
    // a skull is added blocking the player.
    private func addDeathOverlay() {
        let frame          = horizontalScrollView.frame
        let skullImageView = UIImageView(image: .skull)
        let skullSize      = CGFloat(140)
        let leftPadding    = params.padding(forSide: .left)
        let rightPadding   = params.padding(forSide: .right)
        let topPadding     = params.padding(forSide: .top)
        let bottomPadding  = params.padding(forSide: .bottom)
        let xOffset        = -rightPadding/2 + leftPadding/2
        let yOffset        = -bottomPadding/2 + topPadding/2
        let xOrigin        = frame.width/2 - skullSize/2 + xOffset
        let yOrigin        = frame.height/2 - skullSize/2 + yOffset
        skullImageView.tintColor    = .white
        skullImageView.frame.origin = CGPoint(x: xOrigin, y: yOrigin)
        skullImageView.frame.size   = CGSize(width: skullSize, height: skullSize)
        deathOverlayView            = UIView(frame: frame)
        deathOverlayView.addSubview(skullImageView)
        deathOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        verticalScrollView.addSubview(deathOverlayView)
        horizontalScrollView.isUserInteractionEnabled = false
    }
    
    // Called when the player toggles player deather to false. The dark overlay
    // with the skul is removed from blocking the player.
    private func removeDeathOverlay() {
        if deathOverlayView != nil {
            deathOverlayView.removeFromSuperview()
            deathOverlayView = nil
        }
        horizontalScrollView.isUserInteractionEnabled = true
    }
    

    //////////////
    // MARK: - Reset
    //////////////
    public func reset(removeCounters: Bool) {
        toggleMonarch(false)
        togglePlayerDeath(false)
        toggleCitysBlessing(false)
        
        // Each counter is reset. The new value is not added to history.
        counters.forEach({$0.reset(animated: false, writeToHistory: false)})
    
        // Then, if we need to remove counters we do. But, only the counters
        // that are not default counters are removed.
        if removeCounters {
            // If the counter is not a default counter it is removed.
            for counter in counters {
                var defaultIcons = [UIImage]()
                UserPreferences.defaultCounters.forEach({
                    defaultIcons.append(UIImage(counterIconFromInteger: $0))
                })
                if !defaultIcons.contains(counter.iconImage) {
                    removeCounter(withIconImage: counter.iconImage)
                }
            }
        }
    }
    
}

///////////////////////////////
// MARK: - UIScrollViewDelegate
///////////////////////////////

extension UIPlayerViewController: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == horizontalScrollView {
            updateTrumpitImageViewOriginsIfNeeded(scrollOffset: scrollView.contentOffset)
        }
        
        if scrollView == verticalScrollView {
            if scrollView.contentOffset.y < minimumScrollOffset {
                let offset = CGPoint(x: 0, y: minimumScrollOffset)
                scrollView.setContentOffset(offset, animated: false)
            }
        }
        
    }

}
