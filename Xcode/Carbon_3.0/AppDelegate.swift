//
//  AppDelegate.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 4/28/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit
import CoreData

  
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Global Variables
    static var delegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    static var window: UIWindow? {
        return delegate.window
    }
    static var rootController: UIViewController {
        return window!.rootViewController!
    }
    static var rootView: UIView {
        return rootController.view!
    }
    static var topPadding: CGFloat {
        return rootView.safeAreaInsets.top
    }
    static var leftPadding: CGFloat {
        return rootView.safeAreaInsets.left
    }
    static var rightPadding: CGFloat {
        return rootView.safeAreaInsets.right
    }
    static var bottomPadding: CGFloat {
        return rootView.safeAreaInsets.bottom
    }
    
    var setup: UISetupPageViewController!
    var game: UIGameViewController!

    // MARK: - Application Lifecycle
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.isIdleTimerDisabled = true
        window = UIWindow(frame: UIScreen.main.bounds)
        Setup.setInitialWindow()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Carbon_3_0")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    

}

