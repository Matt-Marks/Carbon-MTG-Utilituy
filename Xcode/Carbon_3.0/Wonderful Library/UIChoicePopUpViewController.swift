//
//  UIChoicePopUpViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 1/10/19.
//  Copyright © 2019 Matt Marks. All rights reserved.
//

import UIKit

protocol UIChoicePopUpViewControllerDataSource {
    func choicePopUpSetTitle(_ choicePopUp: UIChoicePopUpViewController) -> String
    func choicePopUpSetMessage(_ choicePopUp: UIChoicePopUpViewController) -> String
    func choicePopUpSetSize(_ choicePopUp: UIChoicePopUpViewController) -> CGSize
    func choicePopUpSetDismissButtonColor(_ choicePopUp: UIChoicePopUpViewController) -> UIColor
    func choicePopUpSetDismissButtonTitle(_ choicePopUp: UIChoicePopUpViewController) -> String
    func choicePopUpSetAcceptButtonColor(_ choicePopUp: UIChoicePopUpViewController) -> UIColor
    func choicePopUpSetAcceptButtonTitle(_ choicePopUp: UIChoicePopUpViewController) -> String
    func choicePopUpSetTextColor(_ alertPopUp: UIChoicePopUpViewController) -> UIColor
}

protocol UIChoicePopUpViewControllerDelegate {
    func alertPopUp(_ choicePopUp: UIChoicePopUpViewController, didDismissWithAcceptance accepted: Bool)
}


class UIChoicePopUpViewController: UIPopUpViewController {
    
    ///////////////////////////////
    // MARK: - Delegation Variables
    ///////////////////////////////
    public var dataSource: UIChoicePopUpViewControllerDataSource!
    public var delegate: UIChoicePopUpViewControllerDelegate?
    
    //////////////////////////
    // MARK: - Title Variables
    //////////////////////////
    private var titleLabel: UILabel  = UILabel()
    private var titleOffset: CGFloat = 18
    private var titleColor: UIColor  = .black
    private var titleFont: UIFont    = UIFont.tondo(weight: .bold, size: 24)
    
    ////////////////////////////
    // MARK: - Message Variables
    ////////////////////////////
    private var messageLabel: UILabel  = UILabel()
    private var messageColor: UIColor  = .black
    private var messageFont: UIFont    = UIFont.tondo(weight: .regular, size: 18)
    private var messageOffset: CGFloat = 20
    private var messageLines: Int      = 10
    
    ///////////////////////////
    // MARK: - Button Variables
    ///////////////////////////
    private var dismissButton: UIButton       = UIButton()
    private var acceptButton: UIButton        = UIButton()
    private var buttonHeight: CGFloat         = 55
    private var buttonPadding: CGFloat        = 10
    private var buttonCornerRadius: CGFloat   = 15
    private var buttonFont: UIFont            = UIFont.tondo(weight: .bold, size: 22)
    private var buttonTitleColor: UIColor     = .white
    private var dismissButtonAction: Selector = #selector(dismissButtonPressed)
    private var acceptButtonAction: Selector  = #selector(acceptButtonPressed)
    
    ////////////////////
    // MARK: - Lifecycle
    ////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
    }
    
    //////////////////////////////
    // MARK: - UIPopUpViewDelegate
    //////////////////////////////
    override func popUpViewSize(_ popUpView: UIView) -> CGSize {
        return dataSource.choicePopUpSetSize(self)
    }
    
    override func popUpView(_ popUpView: UIView, willDisplayWithSize size: CGSize) {
        addTitle(toPopUpView: popUpView, popUpSize: size)
        addMessage(toPopUpView: popUpView, popUpSize: size)
        addDismissButton(toPopUpView: popUpView, popUpSize: size)
        addAcceptButton(toPopUpView: popUpView, popUpSize: size)
    }
    
    ////////////////
    // MARK: - Title
    ////////////////
    private func addTitle(toPopUpView popUpView: UIView, popUpSize size: CGSize) {
        let height = titleFont.pointSize
        titleLabel.font          = titleFont
        titleLabel.textColor     = dataSource.choicePopUpSetTextColor(self)
        titleLabel.frame.origin  = CGPoint(x: 0, y: titleOffset)
        titleLabel.frame.size    = CGSize(width: size.width, height: height)
        titleLabel.textAlignment = .center
        titleLabel.text          = dataSource.choicePopUpSetTitle(self).uppercased()
        popUpView.addSubview(titleLabel)
    }
    
    //////////////////
    // MARK: - Message
    //////////////////
    private func addMessage(toPopUpView popUpView: UIView, popUpSize size: CGSize) {
        let xOrigin = messageOffset
        let yOrigin = titleLabel.frame.origin.y + titleLabel.frame.height
        let width   = size.width - (2*messageOffset)
        let height  = size.height - buttonHeight - buttonPadding - titleFont.pointSize - titleOffset
        messageLabel.font          = messageFont
        messageLabel.textColor     = dataSource.choicePopUpSetTextColor(self)
        messageLabel.frame.origin  = CGPoint(x: xOrigin, y: yOrigin)
        messageLabel.frame.size    = CGSize(width: width, height: height)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = messageLines
        messageLabel.text          = dataSource.choicePopUpSetMessage(self)
        popUpView.addSubview(messageLabel)
    }
    
    //////////////////
    // MARK: - Buttons
    //////////////////
    private func addDismissButton(toPopUpView popUpView: UIView, popUpSize size: CGSize) {
        let xOrigin = buttonPadding
        let yOrigin = size.height - buttonHeight - buttonPadding
        let width   = size.width/2 - (1.5*buttonPadding)
        let height  = buttonHeight
        let title   = dataSource.choicePopUpSetDismissButtonTitle(self)
        dismissButton.backgroundColor    = dataSource.choicePopUpSetDismissButtonColor(self)
        dismissButton.frame.origin       = CGPoint(x: xOrigin, y: yOrigin)
        dismissButton.frame.size         = CGSize(width: width, height: height)
        dismissButton.titleLabel?.font   = buttonFont
        dismissButton.layer.cornerRadius = buttonCornerRadius
        dismissButton.setTitle(title.uppercased(), for: .normal)
        dismissButton.setTitleColor(buttonTitleColor, for: .normal)
        dismissButton.addTarget(self, action: dismissButtonAction, for: .touchUpInside)
        popUpView.addSubview(dismissButton)
    }
    
    private func addAcceptButton(toPopUpView popUpView: UIView, popUpSize size: CGSize) {
        let xOrigin = size.width/2 + buttonPadding/2
        let yOrigin = size.height - buttonHeight - buttonPadding
        let width   = size.width/2 - (1.5*buttonPadding)
        let height  = buttonHeight
        let title   = dataSource.choicePopUpSetAcceptButtonTitle(self)
        acceptButton.backgroundColor    = dataSource.choicePopUpSetAcceptButtonColor(self)
        acceptButton.frame.origin       = CGPoint(x: xOrigin, y: yOrigin)
        acceptButton.frame.size         = CGSize(width: width, height: height)
        acceptButton.titleLabel?.font   = buttonFont
        acceptButton.layer.cornerRadius = buttonCornerRadius
        acceptButton.setTitle(title.uppercased(), for: .normal)
        acceptButton.setTitleColor(buttonTitleColor, for: .normal)
        acceptButton.addTarget(self, action: acceptButtonAction, for: .touchUpInside)
        popUpView.addSubview(acceptButton)
    }
    
    
    @objc func dismissButtonPressed(_ sender: UIButton) {
        dismiss(shouldBounce: false, finished: {
            self.delegate?.alertPopUp(self, didDismissWithAcceptance: false)
        })
    }
    
    @objc func acceptButtonPressed(_ sender: UIButton) {
        dismiss(shouldBounce: true, finished: {
            self.delegate?.alertPopUp(self, didDismissWithAcceptance: true)
        })
        
    }
 
}

extension UIChoicePopUpViewController: UIChoicePopUpViewControllerDataSource {
    func choicePopUpSetTitle(_ choicePopUp: UIChoicePopUpViewController) -> String {
        return "Alert Title"
    }
    
    func choicePopUpSetMessage(_ choicePopUp: UIChoicePopUpViewController) -> String {
        return "Lorem ipsum dolor sit amet, sollicitudin lacus vel fusce leo sed mauris, dolor magnis. Mi neque lacinia."
    }
    
    func choicePopUpSetSize(_ choicePopUp: UIChoicePopUpViewController) -> CGSize {
        return CGSize(width: 300, height: 280)
    }
    
    func choicePopUpSetDismissButtonColor(_ choicePopUp: UIChoicePopUpViewController) -> UIColor {
        return UIColor.init(red: 0.56, green: 0.62, blue: 0.66, alpha: 1.0)
    }
    
    func choicePopUpSetDismissButtonTitle(_ choicePopUp: UIChoicePopUpViewController) -> String {
        return "DISMISS"
    }
    
    func choicePopUpSetAcceptButtonColor(_ choicePopUp: UIChoicePopUpViewController) -> UIColor {
        return UIColor.init(red: 0.95, green: 0.30, blue: 0.29, alpha: 1.0)
    }
    
    func choicePopUpSetAcceptButtonTitle(_ choicePopUp: UIChoicePopUpViewController) -> String {
        return "ACCEPT"
    }
    
    func choicePopUpSetTextColor(_ alertPopUp: UIChoicePopUpViewController) -> UIColor {
        return .black
    }
}

