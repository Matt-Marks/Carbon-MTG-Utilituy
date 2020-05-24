//
//  UISettingsThemeAndAppearanceTableViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/10/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UISettingsThemeAndAppearanceTableViewController: UITableViewController {

    
    
    
    /*****************************/
    /********* Constants *********/
    /*****************************/
    private let accentColors: [UIColor] = [
        .sapphire, .neon, .lithium, .helium, .iron, .oxygen, .barium, .chlorine,
        .phosphorus, .silicon, .zinc, .nitrogen
    ]
    
    /*****************************/
    /***** Interface Outlets *****/
    /*****************************/
    @IBOutlet weak var invertedPlayersToggle: UIThemeableSwitch!
    @IBOutlet weak var trueBlackDarkThemeToggle: UIThemeableSwitch!
    @IBOutlet weak var systemLightDarkModeToggle: UIThemeableSwitch!
    
    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        invertedPlayersToggle.isOn = UserPreferences.invertedPlayerStyle
        trueBlackDarkThemeToggle.isOn = UserPreferences.trueBlackDarkTheme
        systemLightDarkModeToggle.isOn = UserPreferences.shouldUseSystemLightDarkMode
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
                tableView.reloadData()
            }
        }
    }
    
    /*****************************/
    /******* Configuration *******/
    /*****************************/
    
    // Sets the title at the top of the navigation bar.
    // Adds a done button to the top right of the navigation bar.
    private func configureNavigationBar() {
        self.title = "Theme & Appearance"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(doneButtonPressed))
        self.navigationItem.setRightBarButton(doneButton, animated: true)
    }
    
    

    /*****************************/
    /***** Interface Actions *****/
    /*****************************/
    
    // Closes the settings menu and returns to the home setup screen.
    @objc func doneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func trueBlackDarkThemeToggled(_ sender: UIThemeableSwitch) {
        if UserPreferences.ownsPremium {
            UserPreferences.trueBlackDarkTheme = sender.isOn
            if UserPreferences.appTheme == 1 && UserPreferences.trueBlackDarkTheme {
                UserPreferences.appTheme = 2
                
            }
            
            if UserPreferences.appTheme == 2 && !UserPreferences.trueBlackDarkTheme {
                UserPreferences.appTheme = 1
            }
            
            NotificationCenter.default.post(name: .AppearanceDidChange, object: nil)
        } else {
            Monetization.promptWithPremium(over: self)
            sender.isOn = false
        }
    }
    
    @IBAction func systemLightDarkModeToggled(_ sender: UIThemeableSwitch) {
        if UserPreferences.ownsPremium {
            UserPreferences.shouldUseSystemLightDarkMode = sender.isOn
            if #available(iOS 12.0, *) {
                if traitCollection.userInterfaceStyle == .dark && UserPreferences.shouldUseSystemLightDarkMode {
                    UserPreferences.appTheme = UserPreferences.trueBlackDarkTheme ? 2 : 1
                }
            }
            if #available(iOS 12.0, *) {
                if traitCollection.userInterfaceStyle == .light && UserPreferences.shouldUseSystemLightDarkMode {
                    UserPreferences.appTheme = 0
                }
            }
            NotificationCenter.default.post(name: .AppearanceDidChange, object: nil)
            tableView.reloadData()
        } else {
            Monetization.promptWithPremium(over: self)
            sender.isOn = false
        }
    }
    
    @IBAction func invertedPlayersToggled(_ sender: UIThemeableSwitch) {
        if UserPreferences.ownsPremium {
            UserPreferences.invertedPlayerStyle = sender.isOn
        } else {
            Monetization.promptWithPremium(over: self)
            sender.isOn = false
        }
    }
    
    /*****************************/
    /**** UITableViewDelegate ****/
    /*****************************/
    
    // Called right before cells are drawn on the screen. This configures the
    // sells to show which theme the user has chosen as well as enables and
    // diables selection of cells where need be.
    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        
        // The set selection style is a custom method so we need to cast the
        // cell so we can use it.
        let cell = cell as! UIThemeableTableViewCell
        
        // Variables so code is more readable.
        let section = indexPath.section
        let row     = indexPath.row
        let theme   = UserPreferences.appTheme
        
        // The only section that has selectable cells is the accent color section.
        cell.setSelectionStyle(indexPath.section == 2 ? .default : .none)
        
        // When the cells are draws a check mark appears next to the selected
        // theme.
        if section == 0 && row == 0 && theme == 0 {
            cell.accessoryType = .checkmark
        } else if section == 0 && row == 1 && theme > 0 {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        if section == 4 {
            if UserPreferences.accentColor.isEqual(accentColors[indexPath.row]) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }

    }
    
    // Called when a user selects a cell.
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if UserPreferences.ownsPremium || (indexPath.row == 0) {
            // A user can select an app theme.
            if indexPath.section == 0 {
                
                if indexPath.row == 0 {
                    UserPreferences.appTheme = 0
                    if #available(iOS 12.0, *) {
                        if traitCollection.userInterfaceStyle != .light && UserPreferences.shouldUseSystemLightDarkMode{
                            UserPreferences.shouldUseSystemLightDarkMode = false
                            systemLightDarkModeToggle.isOn = false
                        }
                    }
                } else {
                    if UserPreferences.trueBlackDarkTheme {
                        UserPreferences.appTheme = 2
                    } else {
                        UserPreferences.appTheme = 1
                    }
                    if #available(iOS 12.0, *) {
                        if traitCollection.userInterfaceStyle != .dark && UserPreferences.shouldUseSystemLightDarkMode{
                            UserPreferences.shouldUseSystemLightDarkMode = false
                            systemLightDarkModeToggle.isOn = false
                        }
                    }
                }
                                
                // The checkmarks are updated
                for i in 0...1 {
                    let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))
                    cell?.accessoryType = i == indexPath.row ? .checkmark : .none
                }
            }
            
            // A user can also select an accent color.
            if indexPath.section == 4 {
                UserPreferences.accentColor = accentColors[indexPath.row]
                
                // The checkmarks are updated
                for i in 0...11 {
                    let cell = tableView.cellForRow(at: IndexPath(row: i, section: 4))
                    cell?.accessoryType = i == indexPath.row ? .checkmark : .none
                }
            }
            
            // Tells all the loaded components to update their appearance.
            NotificationCenter.default.post(name: .AppearanceDidChange, object: nil)
        } else {
            Monetization.promptWithPremium(over: self)
        }
    }

}

