//
//  UserStatistics.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 2/6/19.
//  Copyright © 2019 Matt Marks. All rights reserved.
//

import Foundation

struct UserStatistics {
    
    // A running count of the amount of times a user has opened the
    // app since Feb 7th 2019.
    static var appLaunches: Int {
        get {
            return UserDefaults.standard.integer(forKey: "appLaunches")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "appLaunches")
        }
    }
    
}
