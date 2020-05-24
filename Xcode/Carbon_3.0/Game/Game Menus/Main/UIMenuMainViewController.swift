//
//  UIMenuMainViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/3/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UIMenuMainViewController: UIPageViewControllerPage {

    /*****************************/
    /***** Interface Outlets *****/
    /*****************************/
    
    // The six buttons that are options in the menu.
    @IBOutlet weak var timerButton: UIAnimatableButton!
    @IBOutlet weak var resetButton: UIAnimatableButton!
    @IBOutlet weak var namesButton: UIAnimatableButton!
    @IBOutlet weak var chooserButton: UIAnimatableButton!
    @IBOutlet weak var historyButton: UIAnimatableButton!
    @IBOutlet weak var diceButton: UIAnimatableButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var resetLabel: UILabel!
    @IBOutlet weak var namesLabel: UILabel!
    @IBOutlet weak var chooserLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var diceLabel: UILabel!
    
    // The button that brings the user back to the setup sequence.
    @IBOutlet weak var mainMenuButton: UISquircleButton!
    
    ///////////////////////////
    // MARK: Computed Variables
    ///////////////////////////
    private var game: UIGameViewController {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.window?.rootViewController as! UIGameViewController
    }
    
    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForEntranceAnimation()
        configureButtons()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performEntranceAnimation()
    }
    
    /*****************************/
    /******* Configuration *******/
    /*****************************/
    
    // This changes to buttons to be white themed to match the theme of the
    // auciliary menus.
    private func configureButtons() {
        timerButton.tintColor = .white
        resetButton.tintColor = .white
        namesButton.tintColor = .white
        chooserButton.tintColor = .white
        historyButton.tintColor = .white
        diceButton.tintColor = .white
        mainMenuButton.fill = .outlined
        mainMenuButton.emphasis = .auxiliary
    }
    
    /*****************************/
    /***** Interface Actions *****/
    /*****************************/
    
    // The timer button moves to the timer menu page.
    @IBAction func timerButtonPressed(_ sender: UIAnimatableButton) {
        (pageController as! UIMenuPageViewController).moveToPage(.timer)
    }
    
    // The reset button removes all extra counters from all players, resets
    // life to its initial values, and clears the game history.
    @IBAction func resetButtonPressed(_ sender: UIAnimatableButton) {
        game.resetGame()
        sender.performSpinAnimation {
            (self.pageController as! UIMenuPageViewController).dismiss(animated: true)
        }
    }
    
    // The names button moves to the names menu page.
    @IBAction func namesButtonPressed(_ sender: UIAnimatableButton) {
        
        let comingSoonAlert = UIWonderfulAlert(title: "OH NO!",
                                               message: "We will eventually get this done. We promise!")
        
        present(comingSoonAlert, animated: false, completion: nil)
    }
    
    // The chooser button moves to the chooser menu page.
    @IBAction func chooserButtonPressed(_ sender: UIAnimatableButton) {
        (pageController as! UIMenuPageViewController).moveToPage(.chooser)
    }
    
    // The history button moves to the history menu page.
    @IBAction func historyButtonPressed(_ sender: UIAnimatableButton) {
        (pageController as! UIMenuPageViewController).moveToPage(.history)
    }
    
    // The dice button moves to the dice menu page.
    @IBAction func diceButtonPressed(_ sender: UIAnimatableButton) {
        (pageController as! UIMenuPageViewController).moveToPage(.dice)
    }
    
    // This will exit the game and return to the setup menu. The user will
    // not be able to return to this game. A warning appears to let the user
    // know this, this warning can be turned off in the app settings.
    @IBAction func mainMenuButtonPressed(_ sender: UISquircleButton) {
        
        if UserPreferences.preventPopups {
            transitionToSetup()
        } else {
            let choiceAlert = UIChoicePopUpViewController()
            choiceAlert.delegate = self
            choiceAlert.dataSource = self
            
            switch UserPreferences.appTheme {
            case 1: choiceAlert.setPopUpViewBackgroundColor(UIColor.darkForeground)
            case 2: choiceAlert.setPopUpViewBackgroundColor(UIColor.blackForeground)
            default: choiceAlert.setPopUpViewBackgroundColor(UIColor.lightForeground)
            }
            
            present(choiceAlert, animated: false, completion: nil)
            
        }
    }
    

    private func transitionToSetup() {
        game.pauseMatchTimer()
        let app = UIApplication.shared.delegate as! AppDelegate
        let setup = UISetupPageViewController()
        pageController.dismiss(animated: true, completion: nil)
        UIView.transition(from: app.window!.rootViewController!.view,
                          to: setup.view,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          completion: { _ in
                            app.window?.rootViewController = setup
        })
    }

    /*****************************/
    /***** Entrance Animation ****/
    /*****************************/
    
    // We have to prepare the antrance animation upon the view loading. We only
    // perform the entrance animatino if this page is the first page opened of
    // the menu.
    private func prepareForEntranceAnimation() {
        if (pageController as! UIMenuPageViewController).getInitialPage() == .main {
            timerButton.prepareForEntranceAnimation()
            resetButton.prepareForEntranceAnimation()
            namesButton.prepareForEntranceAnimation()
            chooserButton.prepareForEntranceAnimation()
            historyButton.prepareForEntranceAnimation()
            diceButton.prepareForEntranceAnimation()
            timerLabel.prepareForEntranceAnimation()
            resetLabel.prepareForEntranceAnimation()
            namesLabel.prepareForEntranceAnimation()
            chooserLabel.prepareForEntranceAnimation()
            historyLabel.prepareForEntranceAnimation()
            diceLabel.prepareForEntranceAnimation()
            mainMenuButton.prepareForEntranceAnimation()
        }
    }
    
    // In view did appear, if this is the first page of the menu, we perform
    // the entrance animation and all the buttons and labels and things bounce
    // in. First impressions matter.
    private func performEntranceAnimation() {
        if (pageController as! UIMenuPageViewController).getInitialPage() == .main {
            timerButton.performEntranceAnimation()
            resetButton.performEntranceAnimation()
            namesButton.performEntranceAnimation()
            chooserButton.performEntranceAnimation()
            historyButton.performEntranceAnimation()
            diceButton.performEntranceAnimation()
            timerLabel.performEntranceAnimation()
            resetLabel.performEntranceAnimation()
            namesLabel.performEntranceAnimation()
            chooserLabel.performEntranceAnimation()
            historyLabel.performEntranceAnimation()
            diceLabel.performEntranceAnimation()
            mainMenuButton.performEntranceAnimation()
        }
    }
    
    
}

extension UIMenuMainViewController: UIChoicePopUpViewControllerDelegate {
    func alertPopUp(_ choicePopUp: UIChoicePopUpViewController, didDismissWithAcceptance accepted: Bool) {
        if accepted {
            transitionToSetup()
        }
    }
    
    
}

extension UIMenuMainViewController: UIChoicePopUpViewControllerDataSource {
    func choicePopUpSetTitle(_ choicePopUp: UIChoicePopUpViewController) -> String {
        return "CAREFUL!"
    }
    
    func choicePopUpSetMessage(_ choicePopUp: UIChoicePopUpViewController) -> String {
        return "Are you sure? You will not be able to return to this game."
    }
    
    func choicePopUpSetSize(_ choicePopUp: UIChoicePopUpViewController) -> CGSize {
        return CGSize(width: 300, height: 230)
    }
    
    func choicePopUpSetDismissButtonColor(_ choicePopUp: UIChoicePopUpViewController) -> UIColor {
        return .silver
    }
    
    func choicePopUpSetDismissButtonTitle(_ choicePopUp: UIChoicePopUpViewController) -> String {
        return "CANCEL"
    }
    
    func choicePopUpSetAcceptButtonColor(_ choicePopUp: UIChoicePopUpViewController) -> UIColor {
        return .lithium
    }
    
    func choicePopUpSetAcceptButtonTitle(_ choicePopUp: UIChoicePopUpViewController) -> String {
        return "EXIT"
    }
    
    func choicePopUpSetTextColor(_ alertPopUp: UIChoicePopUpViewController) -> UIColor {
        switch UserPreferences.appTheme {
        case 1: return .white
        case 2: return .white
        default: return .black
        }
    }
}
