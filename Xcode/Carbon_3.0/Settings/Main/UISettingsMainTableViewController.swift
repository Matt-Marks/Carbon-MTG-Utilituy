//
//  UISettingsMainTableViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/10/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

class UISettingsMainTableViewController: UITableViewController {
    
    let carbonProBanner = CarbonProBanner()
    
    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        listenForNotification()
        if !UserPreferences.ownsPremium {
            toggleCarbonProBanner(true)
        }
        
    }
    
    private func listenForNotification() {
        let selector = #selector(handlePurchaseNotification)
        NotificationCenter.default.addObserver(self,
                                               selector: selector,
                                               name: .PurchaseNotification,
                                               object: nil)
    }
    
    /*****************************/
    /******* Configuration *******/
    /*****************************/
    private func configureNavigationBar() {
        self.title = "Settings"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(doneButtonPressed))
        self.navigationItem.setRightBarButton(doneButton, animated: true)
    }
    
    
    
    /*****************************/
    /******* Button Actions ******/
    /*****************************/
    @objc func doneButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    

    /*****************************/
    /**** UITableViewDelegate ****/
    /*****************************/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0: submitFeedbackSelected()
            case 1: writeReviewSelected()
            case 2: twitterSelected()
            default: ()
            }
        }
        if indexPath.section == 2 {
            openChooser()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! UIThemeableTableViewCell).setSelectionStyle(.default)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 40 : 30
    }
    
    //////////////////
    // MARK: - Contact
    //////////////////
    private func submitFeedbackSelected() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["feedback@nanotubeapps.com"])
            mail.setSubject("Carbon Feedback")
            
            let build = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "N/A")
            let version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A")
            
            var log = ""
            log += "User Settings: \n"
            log += UserPreferences.stringRepresentation()
            log += "\n"
            log += "Other: \n"
            log += "Device: " + UIDevice.current.model + "\n"
            log += "Build: " + build + "\n"
            log += "Version: " + version + "\n"
            
            if let fileData = log.data(using: .utf8) {
                mail.addAttachmentData(fileData as Data,
                                       mimeType: "text/txt",
                                       fileName: "log.txt")
                
            }
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    private func writeReviewSelected() {

        let appID = "1209153225"

        let urlStr = "https://itunes.apple.com/us/app/id\(appID)?mt=8&action=write-review"
            
        if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    private func twitterSelected() {
        let screenName =  "Carbon_MTG"
        let appURL = NSURL(string: "twitter://user?screen_name=\(screenName)")!
        let webURL = NSURL(string: "https://twitter.com/\(screenName)")!
        
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            application.open(webURL as URL)
        }
    }
    
    /////////////////////
    // MARK: - Other Apps
    /////////////////////
    private func openChooser() {
        let appID = "1275945156"
        
        let urlStr = "https://itunes.apple.com/us/app/id\(appID)?mt=8"
        
        if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    /////////////////////
    // MARK: - Pro Banner
    /////////////////////
    @objc func handlePurchaseNotification(_ notification: Notification) {
        toggleCarbonProBanner(false)
    }
    
    private func toggleCarbonProBanner(_ visible: Bool) {
        if visible {
            carbonProBanner.delegate = self
            tableView.tableHeaderView = carbonProBanner.view
            tableView.tableHeaderView?.frame = CGRect(x: 0,
                                                      y: 0,
                                                      width: view.bounds.width,
                                                      height: 110)
        } else {
            tableView.tableHeaderView?.frame = .zero
            tableView.tableHeaderView = nil
            tableView.reloadData()
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension UISettingsMainTableViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
    
        
        controller.dismiss(animated: true) {
            if !UserPreferences.preventPopups {
                if result == .sent {
                    let thanks = UIWonderfulAlert(title: "THANKS!",
                                                  message: "If needed, we will get back to you as soon as possible. ")
 
                    self.present(thanks, animated: false)
                }
            }
        }
        
    }
    
}

