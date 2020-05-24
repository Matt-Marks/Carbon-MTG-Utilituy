//
//  UISetupChooserViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/27/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UISetupChooserViewController: UIPageViewControllerPage {

    /*****************************/
    /********* Constants *********/
    /*****************************/
    private let colors: [UIColor] = [.neon, .lithium, .helium, .iron, .oxygen,
                                     .barium, .chlorine, .phosphorus, .silicon,
                                     .zinc, .nitrogen]
    
    /*****************************/
    /***** Interface Outlets *****/
    /*****************************/
    @IBOutlet weak var titleLabel: UIThemeableLabel!
    @IBOutlet weak var subtitleLabel: UIThemeableLabel!
    @IBOutlet weak var skipButton: UISquircleButton!
    
    /*****************************/
    /********* Variables *********/
    /*****************************/
    private var chooser = UIChooserViewController()
    
    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        chooser = UIChooserViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureChooserController()
    }
    
    /*****************************/
    /******* Configuration *******/
    /*****************************/
    private func configureChooserController() {
        chooser.delegate = self
        chooser.dataSource = self
        view.addSubview(chooser.view)
        view.sendSubviewToBack(chooser.view)
        chooser.view.frame = view.bounds
    }
    
    /*****************************/
    /***** Interface Actions *****/
    /*****************************/
    
    // If a user decides to skip the chooser random colors are assigned to the
    // players and we transition to a new game.
    @IBAction func skipButtonPressed(_ sender: UISquircleButton) {
        
        // We initialize & clear the colors array just in case.
        Setup.colors = [UIColor]()
        
        // We generate one color per player.
        while Setup.colors!.count < Setup.players! {
            var randomColor = colors.randomElement()
            while Setup.colors!.contains(randomColor!) {
                randomColor = colors.randomElement()
            }
            Setup.colors!.append(randomColor!)
        }
        
        Setup.transitionToGame()
    }
    
    /*****************************/
    /********* Animations ********/
    /*****************************/
    
    // Called when fingers are placed on the screen. Hides everything.
    private func hideInterfaceElements() {
        (pageController as! UISetupPageViewController).nagivationVisibility = false
        UIView.animate(withDuration: 0.2) {
            self.titleLabel.alpha = 0.0
            self.subtitleLabel.alpha = 0.0
            self.skipButton.alpha = 0.0
            self.skipButton.isEnabled = false;
        }
    }
    
    // Called when fingers are lifted from the screen if the chooser did not
    // finish choosing. Makes sure all the elements are visible again.
    private func showInterfaceElements() {
        (pageController as! UISetupPageViewController).nagivationVisibility = true
        UIView.animate(withDuration: 0.2) {
            self.titleLabel.alpha = 1.0
            self.subtitleLabel.alpha = 1.0
            self.skipButton.alpha = 1.0
            self.skipButton.isEnabled = true;
        }
    }
    
}

// MARK: - UIChooserViewControllerDelegate
extension UISetupChooserViewController: UIChooserViewControllerDelegate {
    
    func chooser(_ controller: UIChooserViewController, stateDidChange state: UIChooserState) {
        switch state {
        case .noninteracting: showInterfaceElements()
        case .interacting: hideInterfaceElements()
        case .finished: Setup.transitionToGame()
        }
        
    }
    
    func chooser(_ controller: UIChooserViewController, didEndChoosingWithColors colors: [UIColor]) {
        
        // If the players place less fingers on the chooser than there are players, the
        // number of colors the chooser gives will be less than the number of players.
        // If this happens, we need to generate some colors to fill in the rest.
        var startingColors = colors
        
        while startingColors.count < Setup.players {
            var possibleColors = UIColor.elementColors
            possibleColors.removeFirst() // Players will not start white
            var randomColor = possibleColors.randomElement()
            while startingColors.contains(randomColor!) {
                randomColor = possibleColors.randomElement()
            }
            startingColors.append(randomColor!)
        }
        
        Setup.colors = startingColors
    }
}

// MARK: - UIChooserViewControllerDataSource
extension UISetupChooserViewController: UIChooserViewControllerDataSource {
    
    func avalibleColors(for: UIChooserViewController) -> [UIColor] {
        return colors
    }
    
    func pulseDuration(for: UIChooserViewController) -> Double {
        return 0.8
    }
    
    func numberOfPulses(for: UIChooserViewController) -> Int {
        return 2
    }
}


