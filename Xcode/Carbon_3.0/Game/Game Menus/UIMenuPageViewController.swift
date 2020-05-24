//
//  UIMenuPageViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/3/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

class UIMenuPageViewController: UIPageViewController {

    /*****************************/
    /********* Constants *********/
    /*****************************/
    
    // These are the possible menu pages the user can navigate to.
    enum UIMenuPage: Int {
        case main, timer, names, chooser, history, dice
    }
    
    // The default size of the navigation buttons at the top of the setup screens.
    private let navigationButtonSize = CGSize(width: 40, height: 40)
    
    /*****************************/
    /********* Variables *********/
    /*****************************/
    
    // An array of objects representing the setup pages in order.
    private var pages: [UIPageViewControllerPage]!
    
    // The page the menu will open to.
    private var initialPage: UIMenuPage!
    
    // The current page being displayed.
    private var currentPage: UIMenuPage!
    
    // We seperate the navigaiton buttons into icons and buttons. This way we
    // can make the touchable area of the buttons massive while retaining
    // the look of the navigation buttons being in the corner.
    private var backButton, closeButton: UIButton!
    private var backIcon, closeIcon: UIImageView!
    
    
    /*****************************/
    /******* Initialization ******/
    /*****************************/
    convenience init(page: UIMenuPage) {
        self.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.pages = [
            UIMenuMainViewController(pageController: self),
            UIMenuTimerViewController(pageController: self),
            UIMenuNamesViewController(pageController: self),
            UIMenuChooserViewController(pageController: self),
            UIMenuHistoryViewController(pageController: self),
            UIMenuDiceViewController(pageController: self)
        ]
        self.initialPage = page
        self.currentPage = page
        self.backButton = UIButton()
        self.closeButton = UIButton()
        self.backIcon = UIImageView(image: .navigationBack)
        self.closeIcon = UIImageView(image: .navigationClose)
        self.initializeSubviewHierarchy()
        self.backButtonVisibility = false
    }
    
    // We use this method to add our subviews to out view during initialization.
    // however these subviews have not been configured yet. We are just placing
    // them in the correct order to make setup easier later.
    private func initializeSubviewHierarchy() {
        view.addSubview(backButton)
        view.addSubview(closeButton)
        view.addSubview(backIcon)
        view.addSubview(closeIcon)
    }
    
    /*****************************/
    /********* Lifecycle *********/
    /*****************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialViewController()
    }
    
    // Since the navigation buttons' location are dependant on the safe area
    // inserts of the screen we congifure them buttons in layout margins did
    // change.
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        configureBackNavigationButton()
        configureCloseNavigationButton()
        configureBackNavigationIcon()
        configureCloseNavigationIcon()
        backButtonVisibility = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addBlurryBackground()
    }
    
    // This method is called in view did load and sets the page to the given page.
    private func setInitialViewController() {
        setViewControllers([pages[initialPage.rawValue]],
                           direction: .forward,
                           animated: false)
    }
    
    /*****************************/
    /******* Configuration *******/
    /*****************************/
    
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
    // This invisble button is used as the close button. We add an icon over the
    // button later. We do this whole icon-over-button thing to make the hit box
    // of the navigation button way bigger.
    private func configureCloseNavigationButton() {
        let xOrigin = view.bounds.width - view.bounds.width/3
        let width = view.bounds.width/3
        let height = view.safeAreaInsets.top + 70
        let origin = CGPoint(x: xOrigin, y: 0)
        let size = CGSize(width: width, height: height)
        let action = #selector(closeButtonPressed)
        closeButton.frame = CGRect(origin: origin, size: size)
        closeButton.addTarget(self, action: action, for: .touchUpInside)
    }
    
    // This is the icon that is placed over the back button.
    private func configureBackNavigationIcon() {
        let xOrigin = 15 + view.safeAreaInsets.left + view.safeAreaInsets.top/3
        let yOrigin = 15 + view.safeAreaInsets.top
        let origin = CGPoint(x: xOrigin, y: yOrigin)
        backIcon.frame = CGRect(origin: origin, size: navigationButtonSize)
        backIcon.tintColor = .white
    }
    
    // This is the icon that is placed over the close button.
    private func configureCloseNavigationIcon() {
        let xOrigin = view.bounds.width - 55 - view.safeAreaInsets.right - view.safeAreaInsets.top/3
        let yOrigin = 15 + view.safeAreaInsets.top
        let origin = CGPoint(x: xOrigin, y: yOrigin)
        closeIcon.frame = CGRect(origin: origin, size: navigationButtonSize)
        closeIcon.tintColor = .white
    }
    
    /*****************************/
    /****** Public Variables *****/
    /*****************************/
    
    // When toggled back button fades either in or out. On the main page of the
    // menu the back button is hidden, while on every other screen it is visible.
    // The only exception to this is on the chooser menu - when choosing is
    // happening both the back button and the close buttons are hidden.
    public var backButtonVisibility: Bool! {
        didSet {
            if initialPage != .main {
                // If the shake gesture is used the initial page won't exist.
                // This means the back button should also not exist. 
                self.backIcon.alpha = 0.0
                self.backButton.isEnabled = false
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.backIcon.alpha = self.backButtonVisibility ? 1.0 : 0.0
                    self.backButton.isEnabled = self.backButtonVisibility
                }
            }
        }
    }
    
    // When toggled back close fades either in or out. The only time the close
    // button is hidden is during choosing on the chooser screen.
    public var closeButtonVisibility: Bool! {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.closeIcon.alpha = self.closeButtonVisibility ? 1.0 : 0.0
                self.closeButton.isEnabled = self.closeButtonVisibility
            }
        }
    }
    
    /*****************************/
    /***** Interface Actions *****/
    /*****************************/
    
    // The back button will always move back to the main page.
    @objc private func backButtonPressed() {
        moveToPage(.main)
    }
    
    // The close button always dismisses the menu.
    @objc private func closeButtonPressed() {
        dismiss(animated: true)
    }
    
    /*****************************/
    /****** Public Methods *******/
    /*****************************/
    
    // This is called by the navigation buttons and by the elements on the pages.
    // The current page is transitioned to the given page. Forward or backward
    // animation is applied.
    public func moveToPage(_ nextPage: UIMenuPage) {
        let curr = currentPage.rawValue
        let next = nextPage.rawValue
        let direction: NavigationDirection = curr < next ? .forward : .reverse
        setViewControllers([pages[next]], direction: direction, animated: true)
        backButtonVisibility = nextPage == .main ? false : true
        currentPage = nextPage
    }
    
    // Returns the initial page of the menu. This is used by each menu page to
    // tell itself if it should animate it's entrance or not. If a menu page
    // is the initial page it will animate, otherwise it wont. The initial page
    // only changes when the user enables the shake gesture.
    public func getInitialPage() -> UIMenuPage {
        return initialPage
    }
    
    /*****************************/
    /***** Blurry Backgorund *****/
    /*****************************/
    private func addBlurryBackground() {
        let blur = UIBlurryView()
        view.addSubview(blur)
        view.sendSubviewToBack(blur)
        blur.frame = view.bounds
        blur.fadeIn()
    }
    
}

