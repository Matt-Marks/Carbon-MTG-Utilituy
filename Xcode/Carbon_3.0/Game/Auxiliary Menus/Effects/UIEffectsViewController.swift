//
//  UIEffectsViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/10/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UIEffectsViewController: UIViewController {

    /*****************************/
    /********* Variables *********/
    /*****************************/
    private var player: UIPlayerViewController!
    private var blurryBackground = UIBlurryView()
    @IBOutlet weak var citysBlessingButton: UIIconButton!
    @IBOutlet weak var monarchButton: UIIconButton!
    @IBOutlet weak var deathButton: UIIconButton!
    
    /*****************************/
    /******* Initialization ******/
    /*****************************/
    convenience init(player: UIPlayerViewController) {
        if abs(player.rotation()) == .pi/2 {
            self.init(nibName: "UIEffectsHorizontalViewController", bundle: nil)
        } else {
            self.init(nibName: "UIEffectsVerticalViewController", bundle: nil)
        }
        self.player = player
        view.transform = CGAffineTransform.init(rotationAngle: player.rotation())
        initializeSubviewHierarchy()
    }
    
    private func initializeSubviewHierarchy() {
        view.addSubview(blurryBackground)
        view.sendSubviewToBack(blurryBackground)
    }
    
    
    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureBlurryBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureButtonSelection()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blurryBackground.fadeIn()
    }
    
    /*****************************/
    /******* Configuration *******/
    /*****************************/
    
    // Sets the frame of the blurry background
    private func configureBlurryBackground() {
        blurryBackground.frame = view.bounds
    }
    
    private func configureButtonSelection() {
        toggle(citysBlessingButton, to: player.hasCitysBlessing())
        toggle(monarchButton, to: player.hasMonarch())
        toggle(deathButton, to: player.hasPlayerDeath())
    }
    
    /*****************************/
    /***** Interface Acitons *****/
    /*****************************/
    @IBAction func citysBlessingPressed(_ sender: UIIconButton) {
        if UserPreferences.ownsPremium {
            player.toggleCitysBlessing(!player.hasCitysBlessing())
            configureButtonSelection()
            dismiss(animated: true)
            player.animateSlideUp()
        } else {
            Monetization.promptWithPremium(over: self)
        }
    }
    
    @IBAction func monarchPressed(_ sender: UIIconButton) {
        if UserPreferences.ownsPremium {
            player.toggleMonarch(!player.hasMonarch())
            configureButtonSelection()
            dismiss(animated: true)
            player.animateSlideUp()
        } else {
            Monetization.promptWithPremium(over: self)
        }
    }
    
    @IBAction func killPlayerPressed(_ sender: UIIconButton) {
        if UserPreferences.ownsPremium {
            player.togglePlayerDeath(!player.hasPlayerDeath())
            configureButtonSelection()
            dismiss(animated: true)
            player.animateSlideUp()
        } else {
            Monetization.promptWithPremium(over: self)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UISquircleButton) {
        dismiss(animated: true)
        player.animateSlideUp()
    }
    
    /*****************************/
    /****** Effect Selection *****/
    /*****************************/
    
    // Sets the background color of a counter to the accent color if the
    // selected parameter is true. Otherwise clear.
    private func toggle(_ button: UIIconButton, to selected: Bool) {
        if selected {
            button.backgroundColor = UserPreferences.accentColor
        } else {
            button.backgroundColor = .clear
        }
    }

}
