//
//  UISettingsGesturesTableViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/10/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UISettingsGesturesTableViewController: UITableViewController {

    /*****************************/
    /***** Interface Outlets *****/
    /*****************************/
    @IBOutlet weak var shakeLabel: UIThemeableLabel!
    @IBOutlet weak var twoFingerTapLabel: UIThemeableLabel!
    @IBOutlet weak var oneFingerHoldLabel: UIThemeableLabel!
    @IBOutlet weak var twoFingerHoldLabel: UIThemeableLabel!
    
    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTextOfSideLabels()
    }
    
    /*****************************/
    /******* Configuration *******/
    /*****************************/
    private func configureNavigationBar() {
        self.title = "Gestures"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(doneButtonPressed))
        self.navigationItem.setRightBarButton(doneButton, animated: true)
    }
    
    /*****************************/
    /**** UITableViewDelegate ****/
    /*****************************/
    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        
        (cell as! UIThemeableTableViewCell).setSelectionStyle(.default)
    }
    
    /*****************************/
    /******** Side Labels ********/
    /*****************************/
    private func updateTextOfSideLabels() {
        
        switch UserPreferences.shakeGesture {
        case 0: shakeLabel.text = "Off"
        case 1: shakeLabel.text = "Timer"
        case 2: shakeLabel.text = "Reset"
        case 3: shakeLabel.text = "Names"
        case 4: shakeLabel.text = "Chooser"
        case 5: shakeLabel.text = "History"
        case 6: shakeLabel.text = "Dice"
        default: ()
        }
        
        switch UserPreferences.twoFingerTapGesture {
        case 0: twoFingerTapLabel.text = "Off"
        case 1: twoFingerTapLabel.text = "±2"
        case 2: twoFingerTapLabel.text = "±5"
        case 3: twoFingerTapLabel.text = "±10"
        default: ()
        }
        
        switch UserPreferences.oneFingerHold {
        case 0: oneFingerHoldLabel.text = "Off"
        case 1: oneFingerHoldLabel.text = "Linear"
        case 2: oneFingerHoldLabel.text = "Exponential"
        default: ()
        }
        
        switch UserPreferences.twoFingerHold {
        case 0: twoFingerHoldLabel.text = "Off"
        case 1: twoFingerHoldLabel.text = "Reset"
        case 2: twoFingerHoldLabel.text = "Infinity"
        default: ()
        }
        
    
    }
    
    /*****************************/
    /******* Button Actions ******/
    /*****************************/
    @objc func doneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
