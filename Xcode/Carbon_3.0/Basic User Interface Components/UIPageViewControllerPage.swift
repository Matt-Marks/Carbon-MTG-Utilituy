//
//  UIPageViewControllerPage.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/27/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

// Each Setup & Menu page is a child of this class. We just use this to
// clean up the code in those classes a bit. Each page needs a reference to
// the page controller it is contained in so things like the navigaiton buttons
// work. The page controller reference here will have to be casted.
class UIPageViewControllerPage: UIViewController {

    /*****************************/
    /********* Variables *********/
    /*****************************/
    
    // The page controller that holds the page.
    public var pageController: UIPageViewController!
    
    /*****************************/
    /******* Initialization ******/
    /*****************************/
    
    // Each page is initialized with a page controller.
    convenience init(pageController: UIPageViewController) {
        self.init()
        self.pageController = pageController
    }
    
}
