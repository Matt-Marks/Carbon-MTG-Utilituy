//
//  UISettingsDefaultCountersTableViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/10/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UISettingsDefaultCountersTableViewController: UITableViewController {

    // An array of the toggles on the screen in row order.
    @IBOutlet var toggles: [UIThemeableSwitch]!
    
    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setInitialToggleStates()
    }
    
    // Toggles each switch on or off depending on if the counter is a
    // default counter or not.
    private func setInitialToggleStates() {
        for (i, toggle) in toggles.enumerated() {
            toggle.isOn = UserPreferences.defaultCounters.contains(i + 1)
        }
    }
    
    /*****************************/
    /******* Configuration *******/
    /*****************************/
    private func configureNavigationBar() {
        self.title = "Default Counters"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(doneButtonPressed))
        self.navigationItem.setRightBarButton(doneButton, animated: true)
    }
    
    /*****************************/
    /**** UITableViewDelegate ****/
    /*****************************/
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! UIThemeableTableViewCell).setSelectionStyle(.none)
    }
    
    /*****************************/
    /********** Actions **********/
    /*****************************/
    
    // Called when a counter is toggled. Adds or removes the
    // counter from the default counters.
    @IBAction func counterToggled(_ sender: UIThemeableSwitch) {
        if UserPreferences.ownsPremium {
            UserPreferences.toggleDefaultCounter(sender.tag)
        } else {
            sender.isOn = false
            Monetization.promptWithPremium(over: self)
        }
    }
    
    @objc func doneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}

