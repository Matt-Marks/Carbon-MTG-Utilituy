//
//  UISettingsGeneralTableViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/17/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UISettingsGeneralTableViewController: UITableViewController {

    /*****************************/
    /***** Interface Outlets *****/
    /*****************************/
    @IBOutlet weak var preventPopupsSwitch: UIThemeableSwitch!
    @IBOutlet weak var resetRemovesCountersSwitch: UIThemeableSwitch!
    @IBOutlet weak var resetResetsTimerSwitch: UIThemeableSwitch!
    @IBOutlet weak var resetKeepsHistory: UIThemeableSwitch!
    @IBOutlet weak var historyHidesCounters: UIThemeableSwitch!
    
    
    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        preventPopupsSwitch.isOn        = UserPreferences.preventPopups
        resetRemovesCountersSwitch.isOn = UserPreferences.shouldRemoveCounters
        resetResetsTimerSwitch.isOn     = UserPreferences.shouldResetTimer
        resetKeepsHistory.isOn          = UserPreferences.shouldKeepHistory
        historyHidesCounters.isOn       = UserPreferences.historyHidesCounters
    }
    
    /*****************************/
    /******* Configuration *******/
    /*****************************/
    private func configureNavigationBar() {
        self.title = "General"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(doneButtonPressed))
        self.navigationItem.setRightBarButton(doneButton, animated: true)
    }
    
    ////////////////////////////
    // Interface Builder Actions
    ////////////////////////////
    @objc func doneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func preventPopupsToggled(_ sender: UIThemeableSwitch) {
        UserPreferences.preventPopups = sender.isOn
    }
    @IBAction func resetRemovesCountersToggled(_ sender: UIThemeableSwitch) {
        UserPreferences.shouldRemoveCounters = sender.isOn
    }
    
    @IBAction func resetResetsTimerToggled(_ sender: UIThemeableSwitch) {
        UserPreferences.shouldResetTimer = sender.isOn
    }
    
    @IBAction func resetKeepsHistoryToggled(_ sender: UIThemeableSwitch) {
        UserPreferences.shouldKeepHistory = sender.isOn
    }
    
    @IBAction func historyHidesCountersToggled(_ sender: UIThemeableSwitch) {
        UserPreferences.historyHidesCounters = sender.isOn
    }
    
    ////////////////////////////
    // MARK: UITableViewDelegate
    ////////////////////////////
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! UIThemeableTableViewCell).setSelectionStyle(.none)
    }
    
}
