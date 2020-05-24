//
//  UserPreferences.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/10/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import Foundation
import UIKit

// The user preferences are used to store the settings the user sets.
struct UserPreferences {
    
    /****************************************/
    /*********** Global Variables ***********/
    /****************************************/

    // If the user owns premium they have access to many more features.
    static var ownsPremium: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Monetization.ProductID.CarbonPro)
                || UserDefaults.standard.bool(forKey: Monetization.ProductID.Old_Infinity)
                || UserDefaults.standard.bool(forKey: Monetization.ProductID.Old_ForeverPack)
                || UserDefaults.standard.bool(forKey: Monetization.ProductID.Old_ProPack)
                || UserDefaults.standard.bool(forKey: Monetization.ProductID.Old_SaveGames)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ownsPremium")
        }
    }
    
    /****************************************/
    /********** Settings - General **********/
    /****************************************/
    static var preventPopups: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "preventPopups")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "preventPopups")
        }
    }
    
    static var shouldRemoveCounters: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "shouldRemoveCounters")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "shouldRemoveCounters")
        }
    }
    
    static var shouldResetTimer: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "shouldResetTimer")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "shouldResetTimer")
        }
    }
    
    static var shouldKeepHistory: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "shouldKeepHistory")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "shouldKeepHistory")
        }
    }
    
    static var historyHidesCounters: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "historyHasCounters")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "historyHasCounters")
        }
    }
    
    /****************************************/
    /**** Settings - Theme & Appearance *****/
    /****************************************/
    
    // We have three different themes to account for.
    // Light = 0, Dark = 1, and True Black = 2.
    static var appTheme: Int {
        get {
            return UserDefaults.standard.integer(forKey: "appTheme")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "appTheme")
        }
    }
    
    static var trueBlackDarkTheme: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "trueBlackDarkTheme")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "trueBlackDarkTheme")
        }
    }
    
    static var shouldUseSystemLightDarkMode: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "shouldUseSystemLightDarkMode")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "shouldUseSystemLightDarkMode")
        }
    }
    
    // The players can have black text on a colored background or the inverse.
    static var invertedPlayerStyle: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "invertedPlayerStyle")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "invertedPlayerStyle")
        }
    }
    
    // The accent color is used throughout the application.
    static var accentColor: UIColor  {
        get {
            let indexOfColor = UserDefaults.standard.integer(forKey: "accentColor")
            return UIColor.accentColors[indexOfColor]
        }
        set {
            let indexOfColor = UIColor.accentColors.firstIndex(of: newValue)
            UserDefaults.standard.set(indexOfColor, forKey: "accentColor")
        }
    }
    
 
    /****************************************/
    /********* Settings - Gestures **********/
    /****************************************/
    
    // The shake gesture can be used to quick access any of the in game options
    // menu things.
    static var shakeGesture: Int {
        get {
            return UserDefaults.standard.integer(forKey: "shakeGesture")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "shakeGesture")
        }
    }
    
    // The two finger tap gesture can increase or decrease a counter by amounts
    // more than 1.
    static var twoFingerTapGesture: Int {
        get {
            return UserDefaults.standard.integer(forKey: "twoFingerTapGesture")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "twoFingerTapGesture")
        }
    }
    
    // The tap and hold gesture changes how fast the numbers on a counter change
    // when held.
    static var oneFingerHold: Int {
        get {
            if UserDefaults.standard.object(forKey: "oneFingerHold") != nil {
                return UserDefaults.standard.integer(forKey: "oneFingerHold")
            } else {
                return 1
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "oneFingerHold")
        }
    }
    
    // Used to store the selection of the two finger hold gesture.
    static var twoFingerHold: Int {
        get {
            return UserDefaults.standard.integer(forKey: "twoFingerHold")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "twoFingerHold")
        }
    }
    
    /****************************************/
    /********* Settings - Gestures **********/
    /****************************************/
    
    // The counters are represented by integers, so we save them in an array of
    // integers.
    static var defaultCounters: [Int] {
        get {
            return UserDefaults.standard.object(forKey: "defaultCounters") as? [Int] ?? [0]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "defaultCounters")
        }
    }
    
    /****************************************/
    /********* Helpers & Utilities **********/
    /****************************************/
    
    // Toggles the default counter for the given parameter. If the counter is
    // a default counter after toggling, this returns true. Otherwise false.
    static func toggleDefaultCounter(_ counter: Int) {

        if defaultCounters.contains(counter) {
            defaultCounters = defaultCounters.filter({$0 != counter})
        } else {
            defaultCounters.append(counter)
        }
        
        defaultCounters.sort()
    }
    
    public static func stringRepresentation() -> String {
        var settings = ""
        settings += "ownsPremium: " + UserPreferences.ownsPremium.description + "\n"
        settings += "preventPopups: " + UserPreferences.preventPopups.description + "\n"
        settings += "shouldRemoveCounters: " + UserPreferences.shouldRemoveCounters.description + "\n"
        settings += "shouldResetTimer: " + UserPreferences.shouldResetTimer.description + "\n"
        settings += "shouldKeepHistory: " + UserPreferences.shouldKeepHistory.description + "\n"
        settings += "appTheme: " + UserPreferences.appTheme.description + "\n"
        settings += "invertedPlayerStyle: " + UserPreferences.invertedPlayerStyle.description + "\n"
        settings += "accentColor: " + UserPreferences.accentColor.description + "\n"
        settings += "shakeGesture: " + UserPreferences.shakeGesture.description + "\n"
        settings += "twoFingerTapGesture: " + UserPreferences.twoFingerTapGesture.description + "\n"
        settings += "oneFingerHold: " + UserPreferences.oneFingerHold.description + "\n"
        settings += "twoFingerHold: " + UserPreferences.twoFingerHold.description + "\n"
        settings += "defaultCounters: " + UserPreferences.defaultCounters.description + "\n"
        return settings
    }
    
}

