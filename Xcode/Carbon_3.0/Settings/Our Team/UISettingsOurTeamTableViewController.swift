//
//  UISettingsOurTeamTableViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 2/9/19.
//  Copyright © 2019 Matt Marks. All rights reserved.
//

import UIKit

class UISettingsOurTeamTableViewController: UITableViewController {

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
        self.title = "Our Team"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(doneButtonPressed))
        self.navigationItem.setRightBarButton(doneButton, animated: true)
    }

    /***************************************/
    /******* UITableView Data Source *******/
    /***************************************/
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            openTwitter("Matt__Marks")
        }
        
        if indexPath.section == 1 && indexPath.row == 1 {
            openTwitter("JonathanLockw13")
        }
    }
    
    private func openTwitter(_ account: String) {
        let appURL = NSURL(string: "twitter://user?screen_name=\(account)")!
        let webURL = NSURL(string: "https://twitter.com/\(account)")!
        
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            application.open(webURL as URL)
        }
    }

    
    /*****************************/
    /********** Actions **********/
    /*****************************/
    @objc func doneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
