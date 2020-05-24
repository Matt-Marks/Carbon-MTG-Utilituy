//
//  UISetupLifeViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/27/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UISetupLifeViewController: UIPageViewControllerPage {
    
    /*****************************/
    /***** Interface Outlets *****/
    /*****************************/
    @IBOutlet weak var twentyButton: UISquircleButton!
    @IBOutlet weak var thirtyButton: UISquircleButton!
    @IBOutlet weak var fourtyButton: UISquircleButton!
    @IBOutlet weak var customLifeButton: UISquircleButton!
    
    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
    }
    
    /*****************************/
    /******* Configuration *******/
    /*****************************/
    
    // Sets the font, and size of life buttons. Sets the 'one big player button'
    // to look outlined.
    private func configureButtons() {
        twentyButton.fontType = .dense
        thirtyButton.fontType = .dense
        fourtyButton.fontType = .dense
        twentyButton.fontSize = 80
        thirtyButton.fontSize = 80
        fourtyButton.fontSize = 80
        customLifeButton.fill = .outlined
    }
    
    /*****************************/
    /***** Interface Actions *****/
    /*****************************/
    
    // Sets life to 20 and advances to the player page.
    @IBAction func twentyLifeButtonPressed(_ sender: UISquircleButton) {
        (pageController as! UISetupPageViewController).moveToPage(.players)
        Setup.life = 20
    }
    
    // Sets life to 30 and advances to the player page.
    @IBAction func thirtyLifeButtonPressed(_ sender: UISquircleButton) {
        (pageController as! UISetupPageViewController).moveToPage(.players)
        Setup.life = 30
    }
    
    // Sets life to 40 and advances to the player page.
    @IBAction func fourtyLifeButtonPressed(_ sender: UISquircleButton) {
        (pageController as! UISetupPageViewController).moveToPage(.players)
        Setup.life = 40
    }
    
    // Brings up a number pad so the user can enter a custom number.
    @IBAction func customLifeButtonPressed(_ sender: UISquircleButton) {
        let numPad = UINumberPadPopUpViewController()
        numPad.delegate = self
        numPad.dataSource = self
        
        switch UserPreferences.appTheme {
        case 1: numPad.setPopUpViewBackgroundColor(UIColor.darkForeground)
        case 2: numPad.setPopUpViewBackgroundColor(UIColor.blackForeground)
        default: numPad.setPopUpViewBackgroundColor(UIColor.lightForeground)
        }
        
        present(numPad, animated: false)
    }
    

}

extension UISetupLifeViewController: UINumberPadPopUpViewControllerDelegate {
    func numberPadPopUp(_ numberPadPopUp: UINumberPadPopUpViewController, didDismissWithNumber number: Int) {
        (pageController as! UISetupPageViewController).moveToPage(.players)
        Setup.life = number
    }
}

extension UISetupLifeViewController: UINumberPadPopUpViewControllerDataSource {
    func numberPadPopUpSetTextColor(_ numberPadPopUp: UINumberPadPopUpViewController) -> UIColor {
        switch UserPreferences.appTheme {
        case 1: return .white
        case 2: return .white
        default: return .black
        }
    }
    
    func numberPadPopUpSetNumberButtonColor(_ numberPadPopUp: UINumberPadPopUpViewController) -> UIColor {
        return .silver
    }
    
    func numberPadPopUpSetAcceptButtonColor(_ numberPadPopUp: UINumberPadPopUpViewController) -> UIColor {
        return UserPreferences.accentColor
    }
    
    func numberPadPopUpSetAcceptButtonTitle(_ numberPadPopUp: UINumberPadPopUpViewController) -> String {
        return "SET"
    }
    
    
}
