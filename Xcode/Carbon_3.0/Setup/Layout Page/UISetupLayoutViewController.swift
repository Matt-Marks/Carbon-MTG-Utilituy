//
//  UISetupLayoutViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/27/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UISetupLayoutViewController: UIPageViewControllerPage {

    /*****************************/
    /***** Interface Outlets *****/
    /*****************************/
    
    // The buttons representing the different layout options.
    @IBOutlet weak var leftButton: UIAnimatableButton!
    @IBOutlet weak var rightButton: UIAnimatableButton!

    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Whever this view appears we have to clear the content of the buttons.
        // Since the user can navigate forwards and backwards through the
        // setup menu, these buttons need to be able to change their look.
        // So we clear them so the old appearances dont stay behind the new
        // ones if the used switches from two to four players or vice versa.
        clearButtonSublayers()
        
        // We only have options for two and four players because one and three
        // player games do not have layout options.
        switch Setup.players! {
        case 2: configureTwoPlayerOptions()
        case 4: configureFourPlayerOptions()
        case 5: configureFivePlayerOptions()
        case 6: configureSixPlayerOptions()
        default: () // Default here is never called.
        }
    }
    
    /*****************************/
    /******* Configuration *******/
    /*****************************/
    
    // This clears all the sublayers in both the left and right button.
    // We do this to prepare them to be drawn again.
    private func clearButtonSublayers() {
        leftButton.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
        rightButton.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
    }
    
    // This sets the left buttons appearance to reflect the TwoA layout and the
    // right buttons appearance to reflect the TwoB layout.
    private func configureTwoPlayerOptions() {
        addPlayer(to: leftButton,  layout: .twoA, edge: .top,    iconSize: 35)
        addPlayer(to: leftButton,  layout: .twoA, edge: .bottom, iconSize: 35)
        addPlayer(to: rightButton, layout: .twoB, edge: .top,    iconSize: 35)
        addPlayer(to: rightButton, layout: .twoB, edge: .bottom, iconSize: 35)
    }
    
    // This sets the left buttons appearance to reflect the FourA layout and the
    // right buttons appearance to reflect the FourB layout.
    private func configureFourPlayerOptions() {
        addPlayer(to: leftButton,  layout: .fourA, edge: .topLeft,  iconSize: 22)
        addPlayer(to: leftButton,  layout: .fourA, edge: .topRight, iconSize: 22)
        addPlayer(to: leftButton,  layout: .fourA, edge: .botLeft,  iconSize: 22)
        addPlayer(to: leftButton,  layout: .fourA, edge: .botRight, iconSize: 22)
        addPlayer(to: rightButton, layout: .fourB, edge: .top,      iconSize: 22)
        addPlayer(to: rightButton, layout: .fourB, edge: .left,     iconSize: 22)
        addPlayer(to: rightButton, layout: .fourB, edge: .right,    iconSize: 22)
        addPlayer(to: rightButton, layout: .fourB, edge: .bottom,   iconSize: 22)
    }
    
    // This sets the left buttons appearance to reflect the FiveA layout and the
    // right buttons appearance to reflect the FiveB layout.
    private func configureFivePlayerOptions() {
        addPlayer(to: leftButton,  layout: .fiveA, edge: .topLeft,  iconSize: 22)
        addPlayer(to: leftButton,  layout: .fiveA, edge: .topRight, iconSize: 22)
        addPlayer(to: leftButton,  layout: .fiveA, edge: .left,     iconSize: 22)
        addPlayer(to: leftButton,  layout: .fiveA, edge: .right,    iconSize: 22)
        addPlayer(to: leftButton,  layout: .fiveA, edge: .bottom,   iconSize: 22)
        addPlayer(to: rightButton, layout: .fiveB, edge: .topLeft,  iconSize: 22)
        addPlayer(to: rightButton, layout: .fiveB, edge: .topRight, iconSize: 22)
        addPlayer(to: rightButton, layout: .fiveB, edge: .right,    iconSize: 22)
        addPlayer(to: rightButton, layout: .fiveB, edge: .botLeft,  iconSize: 22)
        addPlayer(to: rightButton, layout: .fiveB, edge: .botRight, iconSize: 22)
    }
    
    // This sets the left buttons appearance to reflect the SixA layout and the
    // right buttons appearance to reflect the SixB layout.
    private func configureSixPlayerOptions() {
        addPlayer(to: leftButton,  layout: .sixA, edge: .topLeft,  iconSize: 22)
        addPlayer(to: leftButton,  layout: .sixA, edge: .topRight, iconSize: 22)
        addPlayer(to: leftButton,  layout: .sixA, edge: .left,     iconSize: 22)
        addPlayer(to: leftButton,  layout: .sixA, edge: .right,    iconSize: 22)
        addPlayer(to: leftButton,  layout: .sixA, edge: .botLeft,  iconSize: 22)
        addPlayer(to: leftButton,  layout: .sixA, edge: .botRight, iconSize: 22)
        addPlayer(to: rightButton, layout: .sixB, edge: .top,      iconSize: 22)
        addPlayer(to: rightButton, layout: .sixB, edge: .topLeft,  iconSize: 22)
        addPlayer(to: rightButton, layout: .sixB, edge: .topRight, iconSize: 22)
        addPlayer(to: rightButton, layout: .sixB, edge: .botLeft,  iconSize: 22)
        addPlayer(to: rightButton, layout: .sixB, edge: .botRight, iconSize: 22)
        addPlayer(to: rightButton, layout: .sixB, edge: .bottom,   iconSize: 22)
    }
    
    // Adds a player to the given button.
    private func addPlayer(to button: UIButton,
                           layout: CBLayout,
                           edge: CBEdge,
                           iconSize: CGFloat) {
        
        let player = CALayer()
        let params = CBParameters(layout: layout, edge: edge)
        let frame = params.frame(within: button.bounds, seperation: 7)
        let icon = getIconLayer(frame: frame,
                                rotation: params.rotation(),
                                iconSize: iconSize)
        
        player.addSublayer(icon)
        player.frame = frame
        player.backgroundColor = UserPreferences.accentColor.cgColor
        player.cornerRadius = 10
        button.layer.addSublayer(player)
    }
    
    // Used by the addPlayer method to make the icon that is placed in
    // the player frame
    public func getIconLayer(frame: CGRect,
                             rotation: CGFloat,
                             iconSize: CGFloat) -> CALayer {
        
        let iconLayer = CALayer()
        let maskLayer = CALayer()
        let iconXOrigin = frame.width/2 - iconSize/2
        let iconYOrigin = frame.height/2 - iconSize/2
        let iconOrigin = CGPoint(x: iconXOrigin, y: iconYOrigin)
        let iconSize = CGSize(width: iconSize, height: iconSize)
        
        iconLayer.frame = CGRect(origin: iconOrigin, size: iconSize)
        maskLayer.frame = iconLayer.bounds
        maskLayer.contents = UIImage.player.cgImage
        iconLayer.mask = maskLayer
        iconLayer.backgroundColor = UIColor.white.cgColor
        iconLayer.transform = CATransform3DMakeRotation(rotation, 0, 0, 1)
        
        return iconLayer
    }
    
    /*****************************/
    /***** Interface Actions *****/
    /*****************************/
    
    @IBAction func leftButtonPressed(_ sender: UIAnimatableButton) {
        (pageController as! UISetupPageViewController).moveToPage(.chooser)
        
        switch Setup.players! {
        case 2: Setup.layout = .twoA
        case 4: Setup.layout = .fourA
        case 5: Setup.layout = .fiveA
        case 6: Setup.layout = .sixA
        default: () // Default here is never called.
        }
        
    }
    
    @IBAction func rightButtonPressed(_ sender: UIAnimatableButton) {
        (pageController as! UISetupPageViewController).moveToPage(.chooser)
        
        switch Setup.players! {
        case 2: Setup.layout = .twoB
        case 4: Setup.layout = .fourB
        case 5: Setup.layout = .fiveB
        case 6: Setup.layout = .sixB
        default: () // Default here is never called.
        }
    }
        
        
}
