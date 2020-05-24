//
//  UIWonderfulAlert.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 2/5/19.
//  Copyright © 2019 Matt Marks. All rights reserved.
//

import UIKit

class UIWonderfulAlert: UIViewController {
//    
//    
//    enum UIWonderfulAlertType {
//        case alert, choice, numberPad, timePicker, updateLog
//    }
    
    
    private var titleText: String
    private var messageText: String
    
    
    private var alert: UIView!
    private var animator: UIDynamicAnimator!
    private var backgroundButton: UIButton!
    private var panGesture: UIPanGestureRecognizer!
    
    private var attatchment: UIAttachmentBehavior?
    
    // MARK: - Initialization
    ////////////////////////////////////////////////////////////////////////////
    
    init(title: String, message: String) {
        self.titleText = title
        self.messageText = message
        super.init(nibName: nil, bundle: nil)
        initAlert()
        initAnimator()
        initPanGesture()
        initBackgroundButton()
        initSubviewHierarchy()
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviewHierarchy() {
        view.addSubview(alert)
        view.addSubview(backgroundButton)
        view.sendSubviewToBack(backgroundButton)
    }
    
    private func initAlert() {
        alert = UIView()
        alert.layer.cornerRadius  = 25
        alert.layer.shadowColor   = UIColor.black.cgColor
        alert.layer.shadowOffset  = .zero
        alert.layer.shadowOpacity = 0.3
        alert.layer.shadowRadius  = 10.0
        alert.layer.borderColor   = UIColor.gray.cgColor
        alert.layer.borderWidth   = 1
        alert.alpha               = 0.0
        alert.frame.size          = CGSize(width: 300,
                                           height: messageText.count + 180)
        alert.frame.origin = CGPoint(x: view.bounds.midX - alert.bounds.midX,
                                     y: view.bounds.height/6)
        
        switch UserPreferences.appTheme {
        case 0: alert.backgroundColor = .lightForeground
        case 1: alert.backgroundColor = .darkForeground
        case 2: alert.backgroundColor = .blackForeground
        default: ()
        }
    }
    
    private func initAnimator() {
        animator = UIDynamicAnimator(referenceView: view)
    }
    
    private func initBackgroundButton() {
        backgroundButton = UIButton()
        let buttonAction = #selector(handleBackgroundButtonPressed)
        backgroundButton.frame = UIScreen.main.bounds
        backgroundButton.addTarget(self, action: buttonAction, for: .touchUpInside)
    }
    
    private func initPanGesture() {
        let panAction = #selector(handlePan)
        panGesture = UIPanGestureRecognizer(target: self, action: panAction)
        view.addGestureRecognizer(panGesture)
    }
    
    
    // MARK: - Lifecycle
    ////////////////////////////////////////////////////////////////////////////
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addTitle()
        addMessage()
        addDismissButton()
        
        
        performSnapAnimation()
        UIView.animate(withDuration: 0.25) {
            self.alert.alpha = 1.0
            self.view.backgroundColor = UIColor.init(white: 0.0, alpha: 0.3)
        }
    }
    
    // When called the alert will dismiss wither by falling away or bouncing.
    // The fall is used when the user dismisses the alert and wants no action
    // to occur, while the bounce is used to confirm that they pressed something
    // in the alert. 
    public func dismiss(shouldBounce: Bool, finished: (() -> Void)? = nil) {
        if shouldBounce {
            performBounceAnimation()
        } else {
            animator.removeAllBehaviors()
            performFallAnimation()
            performSpinAnimation()
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.view.backgroundColor = .clear
            self.alert.alpha = 0.0
        }, completion: { _ in
            self.dismiss(animated: false)
            finished?()
        })
    }
    
    // MARK: - Animations
    ////////////////////////////////////////////////////////////////////////////
    
    // When called the alert snaps back to the center of the screen.
    private func performSnapAnimation() {
        let snapBehavior = UISnapBehavior(item: alert, snapTo: view.center)
        animator.removeAllBehaviors()
        animator.addBehavior(snapBehavior)
    }
    
    // When called the alert spontaneously finds itself in an enviroment with
    // gravity and falls off the screen downwards.
    private func performFallAnimation() {
        let gravityBehavior = UIGravityBehavior(items: [alert])
        gravityBehavior.gravityDirection = CGVector(dx: 0.0, dy: 10.0)
        animator.addBehavior(gravityBehavior)
    }
    
    // When called the alert will spin. The angular velocity of the spin
    // is directly proportional to the current angle of the alert. The angle of
    // the alert can change when the user drags the alert around. If the angle
    // is small it will be artificially magnified to make the spin velocity
    // larger.
    private func performSpinAnimation() {
        let transformA = Double(alert.transform.a)
        let transformB = Double(alert.transform.b)
        var rotation = CGFloat(atan2(transformB, transformA))
        let dynamicItemBehavior = UIDynamicItemBehavior(items: [alert])
        rotation += rotation > 0 ? 1 : -1
        let velocity = 4 * rotation
        dynamicItemBehavior.addAngularVelocity(velocity, for: alert)
        animator.addBehavior(dynamicItemBehavior)
    }
    
    // When the user tapps the dismiss button, this slight bounce animation
    // occurs prior to the alert being dismissed.
    private func performBounceAnimation() {
        let bounce      = CAKeyframeAnimation()
        bounce.keyPath  = "transform.scale"
        bounce.keyTimes = [0.0, 0.3, 1.0]
        bounce.values   = [1.0, 1.1, 0.6]
        bounce.duration = 0.3
        bounce.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        alert.layer.add(bounce, forKey: "bounce")
    }
    
    // MARK: - Gesture Handling
    ////////////////////////////////////////////////////////////////////////////
    
    // This is called when the state of the pan gesture changes. The state of
    // pan gesture changes when the user drags around the alert. Two things can
    // happen when the user drags around the alert. If they drag it too far the
    // alert will dismiss, if they don't drag it that far it will just snap
    // back to the center of the screen.
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let anchor      = sender.location(in: view)
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began:
            // When the user begins dragging the alert aroung we need
            // to attach the alert to the users touch point.
            let offsetX = sender.location(in: alert).x - alert.bounds.midX
            let offsetY = sender.location(in: alert).y - alert.bounds.midY
            let offset  = UIOffset.init(horizontal: offsetX, vertical: offsetY)
            attatchment = UIAttachmentBehavior(item: alert,
                                               offsetFromCenter: offset,
                                               attachedToAnchor: anchor)
            animator.removeAllBehaviors()
            animator.addBehavior(attatchment!)
        case .changed:
            // While the user is dragging the alert around the screen we need
            // to update its anchor point so the alert moves with the finger
            // of the user.
            attatchment?.anchorPoint = anchor
        case .ended, .cancelled:
            // If the user releases the alert after dragging it in either
            // the X or Y direction further than 110 dp, then the alert will
            // dismiss with a falling animation. Otherwise the alert just
            // snaps back to the center of the screen.
            performSnapAnimation()
            if abs(translation.y) > 110 || abs(translation.x) > 110 {
                dismiss(shouldBounce: false)
            }
        default: () // Nothing to do.
        }
    }
    
    // The user can dismiss the alert by just tapping the background.
    // The background has a large invisible button over it, when pressed this
    // function is called. The alert is dismissed.
    @objc func handleBackgroundButtonPressed(sender: UITapGestureRecognizer) {
        dismiss(shouldBounce: false)
    }
    
    
    
    // MARK: - Basic Alert Construction
    ////////////////////////////////////////////////////////////////////////////
    
    private func addTitle() {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.tondo(weight: .bold, size: 24)
        titleLabel.frame.origin = CGPoint(x: 0, y: 18)
        titleLabel.frame.size = CGSize(width: alert.bounds.width, height: 24)
        titleLabel.textAlignment = .center
        titleLabel.text = titleText.uppercased()
        
        switch UserPreferences.appTheme {
        case 0: titleLabel.textColor = .black
        case 1: titleLabel.textColor = .white
        case 2: titleLabel.textColor = .white
        default: ()
        }
        
        alert.addSubview(titleLabel)
    }
    
    private func addMessage() {
        let messageLabel = UILabel()
        messageLabel.font          = UIFont.tondo(weight: .regular, size: 18)
        messageLabel.frame.origin  = CGPoint(x: 20, y: 42)
        messageLabel.frame.size    = CGSize(width: alert.bounds.width - 40, height: alert.bounds.height - 107)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.text          = messageText
        switch UserPreferences.appTheme {
        case 0: messageLabel.textColor = .black
        case 1: messageLabel.textColor = .white
        case 2: messageLabel.textColor = .white
        default: ()
        }

        alert.addSubview(messageLabel)
    }
    
    private func addDismissButton() {
        let button = UIButton()
        button.backgroundColor    = .silver
        button.frame.origin       = CGPoint(x: 10,
                                            y: alert.bounds.height - 65)
        button.frame.size         = CGSize(width: alert.bounds.width - 20,
                                           height: 55)
        button.titleLabel?.font   = UIFont.tondo(weight: .bold, size: 22)
        button.layer.cornerRadius = 15
        button.setTitle("DISMISS", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(dismissButtonPressed),
                         for: .touchUpInside)
        alert.addSubview(button)
    }
    
    @objc func dismissButtonPressed(_ sender: UIButton) {
        dismiss(shouldBounce: true)
    }
    
}
