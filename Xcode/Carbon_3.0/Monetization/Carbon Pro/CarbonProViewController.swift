//
//  PremiumViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 1/16/19.
//  Copyright © 2019 Matt Marks. All rights reserved.
//

import UIKit
import StoreKit

class CarbonProViewController: UIViewController {
    
    private var products = [ProductIdentifier : SKProduct]()
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    private let cellNibName: String         = "CarbonProItemCell"
    private let cellIdentifier: String      = "CustomCellOne"
    private let estimatedRowHeight: CGFloat = 200
    private let rowHeight: CGFloat          = UITableView.automaticDimension
    private let contentInset: UIEdgeInsets  = UIEdgeInsets(top: 80,
                                                           left: 0,
                                                           bottom: 160,
                                                           right: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listenForNotification()
        configureContentTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
        Monetization.proStore.requestProducts{ [weak self] success, products in
            guard let self = self else { return }
            if success {
                products!.forEach({self.products[$0.productIdentifier] = $0})
                self.updatePurchaseButton()
            }
        }
    }
    
    private func listenForNotification() {
        let selector = #selector(handlePurchaseNotification)
        NotificationCenter.default.addObserver(self,
                                               selector: selector,
                                               name: .PurchaseNotification,
                                               object: nil)

    }

    private func configureContentTableView() {
        let nib = UINib(nibName: cellNibName, bundle: nil)
        contentTableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        contentTableView.rowHeight          = rowHeight
        contentTableView.dataSource         = self
        contentTableView.contentInset       = contentInset
        contentTableView.estimatedRowHeight = estimatedRowHeight
        contentTableView.showsVerticalScrollIndicator   = false
        contentTableView.showsHorizontalScrollIndicator = false
    }

    private func updatePurchaseButton() {
        if InAppPurchaseHelper.canMakePayments() {
            enableButtons()
        } else {
            disableButtons()
        }
    }
    
    private func enableButtons() {
        //buyButton.isEnabled     = true
        //restoreButton.isEnabled = true
        let product     = products[Monetization.ProductID.CarbonPro]!
        let priceString = InAppPurchaseHelper.priceString(product)
        //buyButton.setTitle("Buy  |  " + priceString!, for: .normal)
        //restoreButton.setTitle("Restore Purchase", for: .normal)
        
        DispatchQueue.main.async {
            self.buyButton.isEnabled     = true
            self.restoreButton.isEnabled = true
            self.buyButton.setTitle("Buy  |  " + priceString!, for: .normal)
            self.restoreButton.setTitle("Restore Purchase", for: .normal)
        }
    }
    
    private func disableButtons() {
        buyButton.isEnabled     = false
        restoreButton.isEnabled = false
        buyButton.setTitle("Not Available", for: .normal)
        restoreButton.setTitle("Not Available", for: .normal)
    }
    
    @IBAction func purchaseButtonPressed(_ sender: UIButton) {
        Monetization.proStore.buyProduct(products[Monetization.ProductID.CarbonPro]!)
    }
    
    @IBAction func restoreButtonPressed(_ sender: UIButton) {
        Monetization.proStore.restorePurchases()
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @objc func handlePurchaseNotification(_ notification: Notification) {
        dismiss(animated: true, completion: nil)
    }

}


// MARK: - UITableViewDataSource
extension CarbonProViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CarbonProItemCell
        
        switch indexPath.row {
        case 0:
            cell.setIcon(.grayscaleSun)
            cell.setTitle("Themes")
            cell.setBody("Choose between three themes: light, dark, and true black.")
            cell.setStatus(.updated)
        case 1:
            cell.setIcon(.grayscaleHand)
            cell.setTitle("Custom Gestures")
            cell.setBody("Set the shake gesture to a shortcut of your choice. Set one and two finger taps and holds to modify counters however you like.")
            cell.setStatus(.new)
        case 2:
            cell.setIcon(.grayscaleBuildings)
            cell.setTitle("City's Blessing")
            cell.setBody("Add a city to the background of any player. It looks different every time!")
            cell.setStatus(.new)
        case 3:
            cell.setIcon(.grayscaleCrown)
            cell.setTitle("Monarch")
            cell.setBody("Become monarch and the envy of the table.")
            cell.setStatus(.new)
        case 4:
            cell.setIcon(.grayscaleSkull)
            cell.setTitle("Kill Players")
            cell.setBody("Kill any player by adding a big fat skull blocking everything they do.")
            cell.setStatus(.new)
        case 5:
            cell.setIcon(.grayscaleColors)
            cell.setTitle("Accent Color")
            cell.setBody("Pick your favorite accent color for the Carbon UI")
            cell.setStatus(.new)
        case 6:
            cell.setIcon(.grayscalePlayers)
            cell.setTitle("Inverted Players")
            cell.setBody("Instead of black text on a colored background, choose players with colored text on a black background.")
            cell.setStatus(.updated)
        case 7:
            cell.setIcon(.grayscaleApp)
            cell.setTitle("30 App Icons")
            cell.setBody("Choose an app icon that exactly matches your theme and accent color.")
            cell.setStatus(.new)
        case 8:
            cell.setIcon(.grayscaleSwitch)
            cell.setTitle("Default Counters")
            cell.setBody("Select counters that every player will always start with.")
            cell.setStatus(.new)
        case 9:
            cell.setIcon(.grayscaleText)
            cell.setTitle("Player Names")
            cell.setBody("Jog your memory by adding names for players.")
            cell.setStatus(.comingSoon)
        default: ()
        }
        
        return cell
    }
    
}
