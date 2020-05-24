//
//  UIMenuChooserViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/3/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UIMenuChooserViewController: UIPageViewControllerPage {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    private var chooser = UIChooserViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chooser = UIChooserViewController()
        prepareForEntranceAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureChooserController()
        performEntranceAnimation()
    }
    
    private func configureChooserController() {
        chooser.delegate = self
        chooser.dataSource = self
        view.addSubview(chooser.view)
        view.sendSubviewToBack(chooser.view)
        chooser.view.frame = view.bounds
    }
    
    ///////////////////
    // MARK: Animations
    ///////////////////
    private func prepareForEntranceAnimation() {
        if (pageController as! UIMenuPageViewController).getInitialPage() == .chooser {
            for subview in view.subviews {
                subview.prepareForEntranceAnimation()
            }
        }
    }
    
    private func performEntranceAnimation() {
        if (pageController as! UIMenuPageViewController).getInitialPage() == .chooser {
            for subview in view.subviews {
                subview.performEntranceAnimation()
            }
        }
    }

}

// MARK: - UIChooserViewControllerDelegate
extension UIMenuChooserViewController: UIChooserViewControllerDelegate {
    func chooser(_ controller: UIChooserViewController, stateDidChange state: UIChooserState) {
        switch state {
        case .noninteracting:
            (pageController as! UIMenuPageViewController).backButtonVisibility = true
            (pageController as! UIMenuPageViewController).closeButtonVisibility = true
            UIView.animate(withDuration: 0.2) {
                self.titleLabel.alpha = 1.0
                self.subtitleLabel.alpha = 1.0
            }
        case .interacting:
            (pageController as! UIMenuPageViewController).backButtonVisibility = false
            (pageController as! UIMenuPageViewController).closeButtonVisibility = false
            UIView.animate(withDuration: 0.2) {
                self.titleLabel.alpha = 0.0
                self.subtitleLabel.alpha = 0.0
            }
        case .finished:
            dismiss(animated: true)
        }
    }
    
    func chooser(_ controller: UIChooserViewController, didEndChoosingWithColors colors: [UIColor]) {
        
    }
}

// MARK: - UIChooserViewControllerDataSource
extension UIMenuChooserViewController: UIChooserViewControllerDataSource {
    func avalibleColors(for: UIChooserViewController) -> [UIColor] {
        return [.white]
    }
    
    func pulseDuration(for: UIChooserViewController) -> Double {
        return 0.8
    }
    
    func numberOfPulses(for: UIChooserViewController) -> Int {
        return 2
    }
}

