//
//  UIMenuNamesViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/3/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UIMenuNamesViewController: UIPageViewControllerPage {

    //////////////////
    // MARK: Lifecycle
    //////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForEntranceAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performEntranceAnimation()
    }

    ///////////////////
    // MARK: Animations
    ///////////////////
    private func prepareForEntranceAnimation() {
        if (pageController as! UIMenuPageViewController).getInitialPage() == .names {
            for subview in view.subviews {
                subview.prepareForEntranceAnimation()
            }
        }
    }
    
    private func performEntranceAnimation() {
        if (pageController as! UIMenuPageViewController).getInitialPage() == .names {
            for subview in view.subviews {
                subview.performEntranceAnimation()
            }
        }
    }

}
