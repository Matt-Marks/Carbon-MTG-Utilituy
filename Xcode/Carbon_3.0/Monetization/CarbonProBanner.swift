//
//  CarbonProBanner.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 2/9/19.
//  Copyright © 2019 Matt Marks. All rights reserved.
//

import UIKit

class CarbonProBanner: UIViewController {
    
    public var delegate: UIViewController?

    @IBOutlet weak var roundedBackgroundView: UIView!
    @IBOutlet weak var viewButton: UIAnimatableButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundedBackgroundView.layer.borderWidth = 0.5
        roundedBackgroundView.layer.borderColor = UIColor.lightSeparator.cgColor
    }
    
    @IBAction func viewButtonPressed(_ sender: UIButton) {
        if let presentOverThisView = delegate {
            Monetization.promptWithPremium(over: presentOverThisView)
        }
    }
    
}
