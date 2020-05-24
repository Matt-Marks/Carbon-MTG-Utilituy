//
//  Setup.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/3/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import Foundation
import UIKit

// During the setup process we have to keep track of the parameters the user
// selects. We define static variables in this structure that are soley used
// to start a game with the selected parameters. These static variables are
// only chaged during the setup process.
struct Setup {
    
    // The amount of life each plkayer will start with.
    static var life: Int!
    
    // The amount of player playing.
    static var players: Int!
    
    // The way the player objects should build themselves on the screen.
    static var layout: CBLayout!
    
    // The colors the players will start with.
    static var colors: [UIColor]!
    
    // This is called in the AppDelegate upon startup. It just makes the app
    // alsways boot to the sertup sequence.
    static func setInitialWindow() {
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.rootViewController = UISetupPageViewController()
        app.window?.makeKeyAndVisible()
    }
    
    // This is called after the chooser is completed or the skip button in the
    // chooser is tapped. A new game is created and the app transitions it.
    static func transitionToGame() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let game = UIGameViewController()
        UIView.transition(from: app.window!.rootViewController!.view,
                          to: game.view,
                          duration: 0.2,
                          options: .transitionCrossDissolve) { _ in
                            app.window?.rootViewController = game
        }
    }
    
}
