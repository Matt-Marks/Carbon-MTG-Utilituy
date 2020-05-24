//
//  UISetupPageViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 10/23/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit
import StoreKit

class UISetupPageViewController: UIPageViewController {

    /*****************************/
    /********* Variables *********/
    /*****************************/
    
    // These are the possible setup pages the user can navigate to. (In Order)
    enum UISetupPage: Int {
        case home, life, players, layout, chooser
    }
    
    // An array of objects representing the setup pages in order.
    private var pages: [UIPageViewControllerPage]!
    
    // The current page being displayed.
    private var currentPage: UISetupPage!
    
    // We seperate the navigaiton buttons into icons and buttons. This way we
    // can make the touchable area of the buttons massive while retaining
    // the look of the navigation buttons being in the corner.
    private var backButton, homeButton: UIButton!
    private var backIcon, homeIcon: UIThemeableImageView!
    
    // The default size of the navigation buttons at the top of the setup screens.
    private let navigationButtonSize = CGSize(width: 40, height: 40)
    
    /*****************************/
    /******* Initialization ******/
    /*****************************/
    
    convenience init() {
        self.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.pages = [
            UISetupHomeViewController(pageController: self),
            UISetupLifeViewController(pageController: self),
            UISetupPlayersViewController(pageController: self),
            UISetupLayoutViewController(pageController: self),
            UISetupChooserViewController(pageController: self)
        ]
        self.currentPage = .home
        self.backButton = UIButton()
        self.homeButton = UIButton()
        self.backIcon = UIThemeableImageView(image: .navigationBack)
        self.homeIcon = UIThemeableImageView(image: .navigationHome)
        self.initializeSubviewHierarchy()
        self.nagivationVisibility = false
    }
    
    // We use this method to add our subviews to out view during initialization.
    // however these subviews have not been configured yet. We are just placing
    // them in the correct order to make setup easier later.
    private func initializeSubviewHierarchy() {
        view.addSubview(backButton)
        view.addSubview(homeButton)
        view.addSubview(backIcon)
        view.addSubview(homeIcon)
    }
    
    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UserStatistics.appLaunches = UserStatistics.appLaunches + 1
        
        if UserStatistics.appLaunches == 5 {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            } else {
                // Fallback on earlier versions
                // Try any other 3rd party or manual method here.
            }
        }
        
    }
    
    // Since the navigation buttons' location are dependant on the safe area
    // inserts of the screen we congifure them buttons in layout margins did
    // change.
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        configureBackNavigationButton()
        configureHomeNavigationButton()
        configureBackNavigationIcon()
        configureHomeNavigationIcon()
        toggleNavigationVisibility(false, animated: false)
    }
    
    // This method is called in view did load and sets the fitst page of the
    // setup menu to the home screen with the start and settings button.
    private func setInitialViewController() {
        setViewControllers([pages[0]], direction: .forward, animated: false)
    }
    
    /*****************************/
    /********* Navigation ********/
    /*****************************/
    
    public var nagivationVisibility: Bool! {
        didSet {
            toggleNavigationVisibility(nagivationVisibility, animated: true)
        }
    }
    
    private func toggleNavigationVisibility(_ visibility: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.backIcon.alpha = self.nagivationVisibility ? 1.0 : 0.0
                self.homeIcon.alpha = self.nagivationVisibility ? 1.0 : 0.0
                self.backButton.isEnabled = self.nagivationVisibility
                self.homeButton.isEnabled = self.nagivationVisibility
            }
        } else {
            self.backIcon.alpha = self.nagivationVisibility ? 1.0 : 0.0
            self.homeIcon.alpha = self.nagivationVisibility ? 1.0 : 0.0
            self.backButton.isEnabled = self.nagivationVisibility
            self.homeButton.isEnabled = self.nagivationVisibility
        }
    }
    
    // Adds an invisible button that takes up the top left corner of the screen.
    // This invisble button is used as the back button. We add an icon over the
    // button later. We do this whole icon-over-button thing to make the hit box
    // of the navigation button way bigger.
    private func configureBackNavigationButton() {
        let width = view.bounds.width/3
        let height = view.safeAreaInsets.top + 70
        let size = CGSize(width: width, height: height)
        let action = #selector(backButtonPressed)
        backButton.frame = CGRect(origin: .zero, size: size)
        backButton.addTarget(self, action: action, for: .touchUpInside)
    }
    
    // Adds an invisible button that takes up the top right corner of the screen.
    // This invisble button is used as the home button. We add an icon over the
    // button later. We do this whole icon-over-button thing to make the hit box
    // of the navigation button way bigger.
    private func configureHomeNavigationButton() {
        let xOrigin = view.bounds.width - view.bounds.width/3
        let width = view.bounds.width/3
        let height = view.safeAreaInsets.top + 70
        let origin = CGPoint(x: xOrigin, y: 0)
        let size = CGSize(width: width, height: height)
        let action = #selector(homeButtonPressed)
        homeButton.frame = CGRect(origin: origin, size: size)
        homeButton.addTarget(self, action: action, for: .touchUpInside)
    }
    
    // This is the icon that is placed over the back button.
    private func configureBackNavigationIcon() {
        let xOrigin = 15 + view.safeAreaInsets.left + view.safeAreaInsets.top/3
        let yOrigin = 15 + view.safeAreaInsets.top
        let origin = CGPoint(x: xOrigin, y: yOrigin)
        backIcon.frame = CGRect(origin: origin, size: navigationButtonSize)
    }
    
    // This is the icon that is placed over the home button.
    private func configureHomeNavigationIcon() {
        let xOrigin = view.bounds.width - 55 - view.safeAreaInsets.right - view.safeAreaInsets.top/3
        let yOrigin = 15 + view.safeAreaInsets.top
        let origin = CGPoint(x: xOrigin, y: yOrigin)
        homeIcon.frame = CGRect(origin: origin, size: navigationButtonSize)
    }
    
    // The back button will always move back a page unless the user is on the
    // chooser. Then the back button goes back to the players page. This is
    // because the user may not always see a layout page for the amount
    // of players they select.
    @objc private func backButtonPressed() {
        switch currentPage! {
        case .life: moveToPage(.home)
        case .players: moveToPage(.life)
        case .layout: moveToPage(.players)
        case .chooser: moveToPage(Setup.players ?? 1 % 2 == 0 ? .layout : .players)
        default: moveToPage(.home)
        }
    }
    
    // The home button always moves back to the home page.
    @objc private func homeButtonPressed() {
        moveToPage(.home)
    }
    
    // This is called by the navigation buttons and by the elements on the pages.
    // The current page is transitioned to the given page. Forward or backward
    // animation is applied.
    public func moveToPage(_ nextPage: UISetupPage) {
        let curr = currentPage.rawValue
        let next = nextPage.rawValue
        let direction: NavigationDirection = curr < next ? .forward : .reverse
        setViewControllers([pages[next]], direction: direction, animated: true)
        nagivationVisibility = nextPage == .home ? false : true
        currentPage = nextPage
    }
    
    
    
    
    
}
