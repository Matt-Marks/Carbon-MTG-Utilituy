//
//  UISetupHomeViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/27/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UISetupHomeViewController: UIPageViewControllerPage {
    

    /*****************************/
    /***** Interface Outlets *****/
    /*****************************/
    @IBOutlet weak var molculeImageView: UIThemeableImageView!
    @IBOutlet weak var titleLabel: UIThemeableLabel!
    @IBOutlet weak var subtitleLabel: UIThemeableLabel!
    @IBOutlet weak var startGameButton: UISquircleButton!
    @IBOutlet weak var settingsButton: UISquircleButton!
    
    
    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        molculeImageView.prepareForEntranceAnimation()
        titleLabel.prepareForEntranceAnimation()
        subtitleLabel.prepareForEntranceAnimation()
        startGameButton.prepareForEntranceAnimation()
        settingsButton.prepareForEntranceAnimation()
        configureSettingsButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateEntrance()
    }
    
    /*****************************/
    /******* Configuration *******/
    /*****************************/
    
    // Makes the settings button silver
    private func configureSettingsButton() {
        settingsButton.emphasis = .secondary
    }
    
    /*****************************/
    /***** Interface Actions *****/
    /*****************************/
    
    
    // When the start game button is pressed the setup sequence begins.
    // The first page the user is directed to is the page to set life.
    @IBAction func startGameButtonPressed(_ sender: UISquircleButton) {
        (pageController as! UISetupPageViewController).moveToPage(.life)
    }
    
    // The settings button brings up the settings menu.
    @IBAction func settingsButtonPressed(_ sender: UISquircleButton) {
        let settings = UIStoryboard.instantiateViewController(withIdentifier: .settingsMain)
        let navControl = UIThemeableNavigationController(rootViewController: settings)
        navControl.modalPresentationStyle = .formSheet
        present(navControl, animated: true)
    }
    
    /*****************************/
    /******* Public Methods ******/
    /*****************************/
    
    // When the app is started up or the user returns to the setup menu from
    // a game we animate the entrance of all the elements on this page with a
    // slight pop and bounce. First impression are important.
    public func animateEntrance() {
        molculeImageView.performEntranceAnimation()
        titleLabel.performEntranceAnimation()
        subtitleLabel.performEntranceAnimation()
        startGameButton.performEntranceAnimation()
        settingsButton.performEntranceAnimation()
    }

}
