//
//  UIColorsViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/10/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UIColorsViewController: UIViewController {

    /*****************************/
    /********* Variables *********/
    /*****************************/
    private var player: UIPlayerViewController!
    private var blurryBackground = UIBlurryView()
    
    /*****************************/
    /****** Initialization *******/
    /*****************************/
    convenience init(player: UIPlayerViewController) {
        if abs(player.rotation()) == .pi/2 {
            self.init(nibName: "UIColorsHorizontalViewController", bundle: nil)
        } else {
            self.init(nibName: "UIColorsVerticalViewController", bundle: nil)
        }
        self.player = player
        view.transform = CGAffineTransform.init(rotationAngle: player.rotation())
        initializeSubviewHierarchy()
    }
    
    private func initializeSubviewHierarchy() {
        view.addSubview(blurryBackground)
        view.sendSubviewToBack(blurryBackground)
    }
    
    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureBlurryBackground()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blurryBackground.fadeIn()
    }
    
    /*****************************/
    /******* Configuration *******/
    /*****************************/
    
    // Sets the frame of the blurry background
    private func configureBlurryBackground() {
        blurryBackground.frame = view.bounds
    }
    
    
    /*****************************/
    /****** Interface Acions *****/
    /*****************************/
    @IBAction func colorButtonPressed(_ sender: UIAnimatableButton) {
        
        switch sender.tag {
        case 0:  player.setColor(.carbon)
        case 1:  player.setColor(.neon)
        case 2:  player.setColor(.lithium)
        case 3:  player.setColor(.helium)
        case 4:  player.setColor(.iron)
        case 5:  player.setColor(.oxygen)
        case 6:  player.setColor(.barium)
        case 7:  player.setColor(.chlorine)
        case 8:  player.setColor(.phosphorus)
        case 9:  player.setColor(.silicon)
        case 10: player.setColor(.zinc)
        case 11: player.setColor(.nitrogen)
        default: ()
        }
        
        dismiss(animated: true)
        player.animateSlideUp()
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UISquircleButton) {
        dismiss(animated: true)
        player.animateSlideUp()
    }
    
    
}
