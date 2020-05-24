//
//  UISetupPlayersViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/27/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UISetupPlayersViewController: UIPageViewControllerPage {

    /*****************************/
    /********* Constants *********/
    /*****************************/
    private let pipSize: CGFloat = 21
    
    enum PipPosition {
        case topLeft, topRight, bottomLeft, bottomRight, center, leftCenter, rightCenter
    }
    
    /*****************************/
    /***** Interface Outlets *****/
    /*****************************/
    @IBOutlet weak var onePlayerButton: UISquircleButton!
    @IBOutlet weak var twoPlayersButton: UISquircleButton!
    @IBOutlet weak var threePlayersButton: UISquircleButton!
    @IBOutlet weak var fourPlayersButton: UISquircleButton!
    @IBOutlet weak var fivePlayersButton: UISquircleButton!
    @IBOutlet weak var sixPlayersButton: UISquircleButton!
    
    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePips()
    }
    
    /*****************************/
    /******* Configuration *******/
    /*****************************/
    
    // Adds the correct amount pips to the correct locations for each dice.
    private func configurePips() {
        addPip(inPosition: .center,      inButton: onePlayerButton)
        
        addPip(inPosition: .topLeft,     inButton: twoPlayersButton)
        addPip(inPosition: .bottomRight, inButton: twoPlayersButton)
        
        addPip(inPosition: .topLeft,     inButton: threePlayersButton)
        addPip(inPosition: .center,      inButton: threePlayersButton)
        addPip(inPosition: .bottomRight, inButton: threePlayersButton)
        
        addPip(inPosition: .topLeft,     inButton: fourPlayersButton)
        addPip(inPosition: .topRight,    inButton: fourPlayersButton)
        addPip(inPosition: .bottomLeft,  inButton: fourPlayersButton)
        addPip(inPosition: .bottomRight, inButton: fourPlayersButton)
        
        addPip(inPosition: .topLeft,     inButton: fivePlayersButton)
        addPip(inPosition: .topRight,    inButton: fivePlayersButton)
        addPip(inPosition: .center,      inButton: fivePlayersButton)
        addPip(inPosition: .bottomLeft,  inButton: fivePlayersButton)
        addPip(inPosition: .bottomRight, inButton: fivePlayersButton)
        
        addPip(inPosition: .topLeft,     inButton: sixPlayersButton)
        addPip(inPosition: .leftCenter,  inButton: sixPlayersButton)
        addPip(inPosition: .bottomLeft,  inButton: sixPlayersButton)
        addPip(inPosition: .topRight,    inButton: sixPlayersButton)
        addPip(inPosition: .rightCenter, inButton: sixPlayersButton)
        addPip(inPosition: .bottomRight, inButton: sixPlayersButton)
    }
    
    /*****************************/
    /***** Interface Actions *****/
    /*****************************/
    
    // Sets the layout to 'one', the amount of players to 1, and advances to the
    // chooser page.
    @IBAction func onePlayerButtonPressed(_ sender: UISquircleButton) {
        (pageController as! UISetupPageViewController).moveToPage(.chooser)
        Setup.players = 1
        Setup.layout = .one
    }
    
    // Sets the amount of players to 2 and advances to layout selection.
    @IBAction func twoPlayersButtonPressed(_ sender: UISquircleButton) {
        (pageController as! UISetupPageViewController).moveToPage(.layout)
        Setup.players = 2
    }
    
    // Sets the layout to 'three', the amount of players to 3, and advances to the
    // chooser page.
    @IBAction func threePlayersButtonPressed(_ sender: UISquircleButton) {
        (pageController as! UISetupPageViewController).moveToPage(.chooser)
        Setup.players = 3
        Setup.layout = .three
    }
    
    // Sets the amount of players to 4 and advances to layout selection.
    @IBAction func fourPlayersButtonPressed(_ sender: UISquircleButton) {
        (pageController as! UISetupPageViewController).moveToPage(.layout)
        Setup.players = 4
    }
    
    // Sets the amount of players to 5 and advances to layout selection.
    @IBAction func fivePlayersButtonPressed(_ sender: UISquircleButton) {
        (pageController as! UISetupPageViewController).moveToPage(.layout)
        Setup.players = 5
    }
    
    // Sets the amount of players to 6 and advances to layout selection.
    @IBAction func sixPlayersButtonPressed(_ sender: UISquircleButton) {
        (pageController as! UISetupPageViewController).moveToPage(.layout)
        Setup.players = 6
    }
    
    /*****************************/
    /***** Dice Pip Creation *****/
    /*****************************/
    
    // Adds a pip to one of 7 positions in the given button.
    func addPip(inPosition pipPos: PipPosition, inButton button: UIButton) {
        let pip             = CALayer()
        pip.frame           = rect(forPipPosition: pipPos)
        pip.cornerRadius    = pipSize/2
        pip.backgroundColor = UIColor.white.cgColor
        button.layer.addSublayer(pip)
    }
    
    // The generates the frame for the given pip.
    private func rect(forPipPosition pipPos: PipPosition) -> CGRect {
        
        let width = onePlayerButton.bounds.width
        let height = onePlayerButton.bounds.height
        
        switch pipPos {
        case .topLeft:
            return CGRect(x: width/4 - pipSize/2, y: height/4 - pipSize/2,
                          width: pipSize, height: pipSize)
        case .topRight:
            return CGRect(x: width*3/4 - pipSize/2, y: height/4 - pipSize/2,
                          width: pipSize, height: pipSize)
        case .bottomLeft:
            return CGRect(x: width/4 - pipSize/2, y: height*3/4 - pipSize/2,
                          width: pipSize, height: pipSize)
        case .bottomRight:
            return CGRect(x: width*3/4 - pipSize/2, y: height*3/4 - pipSize/2,
                          width: pipSize, height: pipSize)
        case .center:
            return CGRect(x: width/2 - pipSize/2, y: height/2 - pipSize/2,
                          width: pipSize,height: pipSize)
        case .leftCenter:
            return CGRect(x: width/4 - pipSize/2, y: height/2 - pipSize/2,
                          width: pipSize, height: pipSize)
        case .rightCenter:
            return CGRect(x: width*3/4 - pipSize/2, y: height/2 - pipSize/2,
                          width: pipSize, height: pipSize)
        }
    }

}
