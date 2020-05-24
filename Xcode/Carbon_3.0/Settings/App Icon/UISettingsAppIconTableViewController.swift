//
//  UISettingsAppIconTableViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/27/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UISettingsAppIconTableViewController: UITableViewController {

    @IBOutlet var iconButtons: [UIButton]!
    
    private var iconNames = [
        "DefaultLight", "DefaultDark", "DefaultBlack",
        "NeonLight", "NeonDark", "NeonBlack",
        "LithiumLight", "LithiumDark", "LithiumBlack",
        "HeliumLight", "HeliumDark", "HeliumBlack",
        "IronLight", "IronDark", "IronBlack",
        "OxygenLight", "OxygenDark", "OxygenBlack",
        "BariumLight", "BariumDark", "BariumBlack",
        "ChlorineLight", "ChlorineDark", "ChlorineBlack",
        "PhosphorusLight", "PhosphorusDark", "PhosphorusBlack",
        "SiliconLight", "SiliconDark", "SiliconBlack",
        "ZincLight", "ZincDark", "ZincBlack",
        "NitrogenLight", "NitrogenDark", "NitrogenBlack"
    ]
    
    private var selectionIndicatorView = UIView()
    
    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = .clear
        tableView.separatorStyle = .none
        configureNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSelectionIndicator()
    }
    
    /*****************************/
    /******* Configuration *******/
    /*****************************/
    private func configureNavigationBar() {
        self.title = "App Icon"
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
        cell.backgroundColor = .clear
        
        for subview in cell.contentView.subviews {
            if let button = subview as? UIButton {
                
                if UserPreferences.appTheme == 0 {
                    button.layer.borderColor = UIColor.lightSeparator.cgColor
                } else if UserPreferences.appTheme == 1 {
                    button.layer.borderColor = UIColor.darkSeparator.cgColor
                } else if UserPreferences.appTheme == 2 {
                    button.layer.borderColor = UIColor.blackSeparator.cgColor
                }
                
                button.layer.borderWidth = 0.5

            }
        }
    }
    

    /*****************************/
    /******* Button Actions ******/
    /*****************************/
    @IBAction func iconButtonPressed(_ sender: UIButton) {
        if UserPreferences.ownsPremium || (sender.tag < 3) {
            setIcon(iconNames[sender.tag])
            updateSelectionIndicator()
        } else {
            Monetization.promptWithPremium(over: self)
        }
    }
    
    @objc func doneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*****************************/
    /**** Helpers & Utilities ****/
    /*****************************/
    private func setIcon(_ name: String) {
        UIApplication.shared.setAlternateIconName(name) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Success!")
            }
        }
    }
    
    private func updateSelectionIndicator() {
        if let currentIcon = UIApplication.shared.alternateIconName {
            if let index = iconNames.firstIndex(of: currentIcon) {
                moveSelectionIndicatorToButton(iconButtons[index])
            }
        } else {
            moveSelectionIndicatorToButton(iconButtons[2])
        }
    }
    
    private func moveSelectionIndicatorToButton(_ button: UIButton) {
        selectionIndicatorView.removeFromSuperview()
        let size: CGFloat = 22
        let x = button.frame.origin.x - size/2
        let y = button.frame.origin.y - size/2
        let w = button.frame.width + size
        let h = button.frame.height + size
        selectionIndicatorView.frame.origin = CGPoint(x: x, y: y)
        selectionIndicatorView.frame.size = CGSize(width: w, height: h)
        selectionIndicatorView.backgroundColor = UserPreferences.accentColor
        selectionIndicatorView.layer.cornerRadius = 22
        button.superview?.addSubview(selectionIndicatorView)
        button.superview?.sendSubviewToBack(selectionIndicatorView)
    }
}
