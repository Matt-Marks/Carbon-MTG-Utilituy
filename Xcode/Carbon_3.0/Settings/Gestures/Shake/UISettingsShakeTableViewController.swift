//
//  UISettingsShakeTableViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/11/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UISettingsShakeTableViewController: UITableViewController {

    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSelectedRow()
    }
    
    /*****************************/
    /******* Configuration *******/
    /*****************************/
    private func configureNavigationBar() {
        self.title = "Shake Device"
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
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        if UserPreferences.ownsPremium {
            
            if indexPath.section == 1 && indexPath.row == 2 {
                let alert = UIWonderfulAlert(title: "Oh No!",
                                             message: "We are still working on the player names feature. Check back soon!")
                present(alert, animated: false)
            } else {
                UserPreferences.shakeGesture = indexPath.section + indexPath.row
                updateSelectedRow()
                updateSelectedRow()
            }
            
            
        } else {
            Monetization.promptWithPremium(over: self)
        }
        
    }
    
    /*****************************/
    /******* Button Actions ******/
    /*****************************/
    @objc func doneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*****************************/
    /**** Helpers & Utilities ****/
    /*****************************/
    private func updateSelectedRow() {
        
        // First, we set all the rows to unchecked.
        updateCell(at: IndexPath(row: 0, section: 0), selected: false)
        updateCell(at: IndexPath(row: 0, section: 1), selected: false)
        updateCell(at: IndexPath(row: 1, section: 1), selected: false)
        updateCell(at: IndexPath(row: 2, section: 1), selected: false)
        updateCell(at: IndexPath(row: 3, section: 1), selected: false)
        updateCell(at: IndexPath(row: 4, section: 1), selected: false)
        updateCell(at: IndexPath(row: 5, section: 1), selected: false)
        
        // Then we check the row that should be selected.
        switch UserPreferences.shakeGesture {
        case 0: updateCell(at: IndexPath(row: 0, section: 0), selected: true)
        case 1: updateCell(at: IndexPath(row: 0, section: 1), selected: true)
        case 2: updateCell(at: IndexPath(row: 1, section: 1), selected: true)
        case 3: updateCell(at: IndexPath(row: 2, section: 1), selected: true)
        case 4: updateCell(at: IndexPath(row: 3, section: 1), selected: true)
        case 5: updateCell(at: IndexPath(row: 4, section: 1), selected: true)
        default: ()
        }
    }
    
    private func updateCell(at indexPath: IndexPath, selected: Bool) {
        let cell = tableView.cellForRow(at: indexPath)!
        cell.accessoryType = selected ? .checkmark : .none
    }
    
}
