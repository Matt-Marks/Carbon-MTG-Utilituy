//
//  UIWonderfulPopUpViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 1/10/19.
//  Copyright © 2019 Matt Marks. All rights reserved.
//

import UIKit

class UIPopUpViewController: UIViewController {
    
    private let backgroundColor: UIColor      = UIColor.init(white: 0.0, alpha: 0.3)
    private let popUpBackgroundColor: UIColor = .white
    private let popUpCornerRadius: CGFloat    = 25
    private let popUpShadowColor: UIColor     = .black
    private let popUpShadowOffset: CGSize     = CGSize(width: 0, height: 0)
    private let popUpShadowOpacity: Float     = 0.3
    private let popUpShadowRadius: CGFloat    = 10.0
    private let popUpBorderColor: UIColor     = UIColor.init(white: 1.0, alpha: 0.3)
    private let popUpBorderWidth: CGFloat     = 1
    private var visibleAlpha: CGFloat         = 1.0
    private var invisibleAlpha: CGFloat       = 0.0
    private var animationFadeTime: Double     = 0.25
    private var gravityDirection: CGVector    = CGVector(dx: 0.0, dy: 10.0)
    private var outOfBounds: CGFloat          = 110
    private var bounceKeyPath: String         = "transform.scale"
    private var bounceKeyTimes: [NSNumber]    = [0.0, 0.3, 1.0]
    private var bounceValues: [Double]        = [1.0, 1.1, 0.6]
    private var bounceDuration: Double        = 0.3
    private var spinMultiplier: CGFloat       = 4
    
    private var popUpView: UIView!
    private var animator: UIDynamicAnimator!
    private var backgroundButton: UIButton!
    private var panGesture: UIPanGestureRecognizer!
    
    /////////////////////////
    // MARK: - Initialization
    /////////////////////////
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overCurrentContext
        animator = UIDynamicAnimator(referenceView: view)
        initPopUp()
        initGestures()
    }
    
    private func initPopUp() {
        popUpView = UIView()
        backgroundButton = UIButton()
        setPopUpViewBackgroundColor(popUpBackgroundColor)
        setPopUpViewCornerRadius(popUpCornerRadius)
        setPopUpViewShadowColor(popUpShadowColor)
        setPopUpViewShadowOffset(popUpShadowOffset)
        setPopUpViewShadowOpacity(popUpShadowOpacity)
        setPopUpViewShadowRadius(popUpShadowRadius)
        setPopUpViewBorderColor(popUpBorderColor)
        setPopUpViewBorderWidth(popUpBorderWidth)
        configureBackgroundButton()
        view.addSubview(popUpView)
        view.addSubview(backgroundButton)
        view.sendSubviewToBack(backgroundButton)
    }
    
    private func initGestures() {
        let panAction = #selector(handlePan)
        panGesture    = UIPanGestureRecognizer(target: self, action: panAction)
        view.addGestureRecognizer(panGesture)
    }
    
    private func configureBackgroundButton() {
        let buttonAction = #selector(handleBackgroundButtonPressed)
        backgroundButton.frame = UIScreen.main.bounds
        backgroundButton.addTarget(self, action: buttonAction, for: .touchUpInside)
    }
    
    ////////////////////
    // MARK: - Lifecycle
    ////////////////////

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setPopUpViewSize(popUpViewSize(popUpView))
        
        let originX = view.bounds.midX - popUpView.bounds.midX
        let originY = view.bounds.height/6
        popUpView.frame.origin = CGPoint(x: originX, y: originY)
        popUpView.alpha = invisibleAlpha
        
        popUpView(popUpView, willDisplayWithSize: popUpView.frame.size)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        snap()
        UIView.animate(withDuration: animationFadeTime) {
            self.popUpView.alpha = self.visibleAlpha
            self.view.backgroundColor = self.backgroundColor
        }
    }
    
    /////////////////////////////
    // MARK: - General Animations
    /////////////////////////////
    private func snap() {
        let snapBehavior = UISnapBehavior(item: popUpView, snapTo: view.center)
        animator.removeAllBehaviors()
        animator.addBehavior(snapBehavior)
    }
    
    private func fall() {
        let gravityBehavior = UIGravityBehavior(items: [popUpView])
        gravityBehavior.gravityDirection = gravityDirection
        animator.addBehavior(gravityBehavior)
    }
    
    private func spin() {
        let transformA = Double(popUpView.transform.a)
        let transformB = Double(popUpView.transform.b)
        var currentRotation = CGFloat(atan2(transformB, transformA))
        let dynamicItemBehavior = UIDynamicItemBehavior(items: [popUpView])
        currentRotation += currentRotation > 0 ? 1 : -1
        dynamicItemBehavior.addAngularVelocity(spinMultiplier*currentRotation, for: popUpView)
        animator.addBehavior(dynamicItemBehavior)
    }
    
    private func bounce() {
        let bounce      = CAKeyframeAnimation()
        bounce.keyPath  = bounceKeyPath
        bounce.keyTimes = bounceKeyTimes
        bounce.values   = bounceValues
        bounce.duration = bounceDuration
        bounce.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        popUpView.layer.add(bounce, forKey: "bounce")
    }
    
    
    private func attatch(location: CGPoint, anchor: CGPoint) {
        let offsetX = location.x - popUpView.frame.size.width/2
        let offsetY = location.y - popUpView.frame.size.height/2
        let offset  = UIOffset.init(horizontal: offsetX, vertical: offsetY)
        let attachmentBehavior = UIAttachmentBehavior(item: popUpView,
                                                      offsetFromCenter: offset,
                                                      attachedToAnchor: anchor)
        animator.removeAllBehaviors()
        animator.addBehavior(attachmentBehavior)
    }
    
    private func attatch(anchor: CGPoint) {
        for behavior in animator.behaviors {
            if let attachmentBehavior = behavior as? UIAttachmentBehavior {
                attachmentBehavior.anchorPoint = anchor
            }
        }
    }
    
    private func endDrag(translation: CGPoint) {
        snap()
        if pointIsOutOfBounds(translation) {
            dismiss(shouldBounce: false)
        }
    }
    
    //////////////////////////////
    // MARK: - Gesture Recognizers
    //////////////////////////////
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let location    = sender.location(in: popUpView)
        let anchor      = sender.location(in: view)
        let translation = sender.translation(in: view)
        switch sender.state {
        case .began:     attatch(location: location, anchor: anchor)
        case .changed:   attatch(anchor: anchor)
        case .ended:     endDrag(translation: translation)
        case .cancelled: endDrag(translation: translation)
        default: ()
        }
    }
    
    @objc func handleBackgroundButtonPressed(sender: UITapGestureRecognizer) {
        dismiss(shouldBounce: false)
    }
    
    //////////////////////////////
    // MARK: - Helpers & Utilities
    //////////////////////////////
    private func pointIsOutOfBounds(_ point: CGPoint) -> Bool {
        return abs(point.y) > outOfBounds || abs(point.x) > outOfBounds
    }
    
    ////////////////////////////
    // MARK: - Getters & Setters
    ////////////////////////////
    public func setBackgroundColor(_ color: UIColor) {
        view.backgroundColor = color
    }
    
    public func setPopUpViewSize(_ size: CGSize) {
        popUpView.frame.size = size
    }
    
    public func setPopUpViewBackgroundColor(_ color: UIColor) {
        popUpView.backgroundColor = color
    }
    
    public func setPopUpViewCornerRadius(_ radius: CGFloat) {
        popUpView.layer.cornerRadius = radius
    }
    
    public func setPopUpViewShadowColor(_ color: UIColor) {
        popUpView.layer.shadowColor = color.cgColor
    }
    
    public func setPopUpViewShadowOffset(_ offset: CGSize) {
        popUpView.layer.shadowOffset = offset
    }
    
    public func setPopUpViewShadowOpacity(_ opacity: Float) {
        popUpView.layer.shadowOpacity = opacity
    }
    
    public func setPopUpViewShadowRadius(_ radius: CGFloat) {
        popUpView.layer.shadowRadius = radius
    }
    
    public func setPopUpViewBorderColor(_ color: UIColor) {
        popUpView.layer.borderColor = color.cgColor
    }
    
    public func setPopUpViewBorderWidth(_ width: CGFloat) {
        popUpView.layer.borderWidth = width
    }
    
    /////////////////////////////
    // MARK: - Dismiss Animations
    /////////////////////////////
    public func dismiss(shouldBounce: Bool, finished: (() -> Void)? = nil) {
        if shouldBounce {
            bounce()
        } else {
            animator.removeAllBehaviors()
            fall()
            spin()
        }
        UIView.animate(withDuration: animationFadeTime, animations: {
            self.view.backgroundColor = .clear
            self.popUpView.alpha = self.invisibleAlpha
        }, completion: { _ in
            self.dismiss(animated: false)
            finished?()
        })
    }

    //////////////////////////////
    // MARK: - Methods To Override
    //////////////////////////////
    func popUpViewSize(_ popUpView: UIView) -> CGSize {
        return CGSize(width: 300, height: 300)
    }
    
    func popUpView(_ popUpView: UIView, willDisplayWithSize size: CGSize) {
        // Nothing to do
    }


}

