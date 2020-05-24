//
//  UISettingsTipJarTableViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/10/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UISettingsTipJarTableViewController: UITableViewController {

    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    /*****************************/
    /******* Configuration *******/
    /*****************************/
    private func configureNavigationBar() {
        self.title = "Tip Jar"
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
    /******* Button Actions ******/
    /*****************************/
    @objc func doneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
