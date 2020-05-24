//
//  UICountersViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/10/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UICountersViewController: UIViewController {

    /*****************************/
    /********* Variables *********/
    /*****************************/
    private var blurryBackground = UIBlurryView()
    private var player: UIPlayerViewController!
    private var previouslySelectedCounterImages: [UIImage]!
    private var selectedCounterImages: [UIImage]!
    
    /*****************************/
    /***** Interface Outlets *****/
    /*****************************/
    @IBOutlet var iconButtons: [UIIconButton]!
    @IBOutlet weak var completionButton: UISquircleButton!
    
    /*****************************/
    /******* Initialization ******/
    /*****************************/
    convenience init(player: UIPlayerViewController) {
        if abs(player.rotation()) == .pi/2 {
            self.init(nibName: "UICountersHorizontalViewController", bundle: nil)
        } else {
            self.init(nibName: "UICountersVerticalViewController", bundle: nil)
        }
        self.player = player
        previouslySelectedCounterImages = player.getCurrentCounterIcons()
        selectedCounterImages = player.getCurrentCounterIcons()
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureIconInitialSelection()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureBlurryBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blurryBackground.fadeIn()
        completionButton.emphasis = .secondary
    }

    /*****************************/
    /******* Configuration *******/
    /*****************************/
    
    // Sets the frame of the blurry background
    private func configureBlurryBackground() {
        blurryBackground.frame = view.bounds
    }
    
    // All the icons that are currently on the player are set to selected.
    private func configureIconInitialSelection() {
        for button in iconButtons {
            let iconImage = button.backgroundImage(for: .normal)!
            let iconsToSelect = previouslySelectedCounterImages!
            toggle(button, to: iconsToSelect.map({$0.pngData()}).contains(iconImage.pngData()))
        }
    }
    
    /*****************************/
    /******* Button Actions ******/
    /*****************************/
    
    // Called when the user selects a counter. If the counter is unselected it
    // becomes selected and vice versa. If the current selection becomes equal
    // to the counters currently on the player the bottom button says cancel.
    // Otherwise it says done.
    @IBAction func iconButtonPressed(_ sender: UIIconButton) {
        
        // First, we find the icon that was pressed
        let icon = sender.backgroundImage(for: .normal)!
        
        // If that icon was selected we remove it from the array of selected
        // icons. Otherwise we add it.
        if selectedCounterImages.contains(icon) {
            selectedCounterImages = selectedCounterImages.filter({!$0.isEqual(icon)})
        } else {
            selectedCounterImages.append(icon)
        }
        
        // We update the done button if the users selection is different than
        // the counteres currently on the player.
        if selectedCounterImages.elementsEqual(previouslySelectedCounterImages) {
            completionButton.emphasis = .secondary
            completionButton.setTitle("CANCEL", for: .normal)
        } else {
            completionButton.emphasis = .primary
            completionButton.setTitle("DONE", for: .normal)
        }

        // If the counter is selected we update its backgorund color. Otherwise
        // we set it to clear.
        toggle(sender, to: selectedCounterImages.contains(icon))
    }
    
    
    // Called when the user pressed the cancel or done button. If the button
    // says "Done" that means the user has selected different counters than
    // are on the player currently. Counters are added and removed from
    // the player as needed.
    @IBAction func completionButtonPressed(_ sender: UISquircleButton) {

        if sender.title(for: .normal) == "DONE" {
            for icon in selectedCounterImages {
                if !previouslySelectedCounterImages.contains(icon) {
                    player.addCounter(withValue: 0, andIconImage: icon)
                }
            }
            
            for icon in previouslySelectedCounterImages {
                if !selectedCounterImages.contains(icon) {
                    player.removeCounter(withIconImage: icon)
                }
            }
        }
        
        dismiss(animated: true)
        player.animateSlideUp()
    }

    /*****************************/
    /***** Counter Selection *****/
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
