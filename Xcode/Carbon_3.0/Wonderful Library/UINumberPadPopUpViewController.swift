//
//  UINumberPadPopUpViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 1/10/19.
//  Copyright © 2019 Matt Marks. All rights reserved.
//

import UIKit

protocol UINumberPadPopUpViewControllerDataSource {
    func numberPadPopUpSetTextColor(_ numberPadPopUp: UINumberPadPopUpViewController) -> UIColor
    func numberPadPopUpSetNumberButtonColor(_ numberPadPopUp: UINumberPadPopUpViewController) -> UIColor
    func numberPadPopUpSetAcceptButtonColor(_ numberPadPopUp: UINumberPadPopUpViewController) -> UIColor
    func numberPadPopUpSetAcceptButtonTitle(_ numberPadPopUp: UINumberPadPopUpViewController) -> String
}

protocol UINumberPadPopUpViewControllerDelegate {
    func numberPadPopUp(_ numberPadPopUp: UINumberPadPopUpViewController, didDismissWithNumber number: Int)
}

class UINumberPadPopUpViewController: UIPopUpViewController {

    ///////////////////////////////
    // MARK: - Delegation Variables
    ///////////////////////////////
    public var dataSource: UINumberPadPopUpViewControllerDataSource!
    public var delegate: UINumberPadPopUpViewControllerDelegate?
    
    ///////////////////////////////
    // MARK: - Number Pad Variables
    ///////////////////////////////
    private let numberPadSize: CGSize = CGSize(width: 300, height: 460)
    private let numberPadMaxCharacterCount: Int = 10
    
    ////////////////////////////////
    // MARK: - Cursor View Variables
    ////////////////////////////////
    private var cursorView = UIView()
    private var cursorSize: CGSize = CGSize(width: 2, height: 45)
    private var cursorVisibleAlpha: CGFloat = 0.3
    private var cursorInvisibleAlpha: CGFloat = 0.0
    private var cursorYOrigin: CGFloat = 39
    
    /////////////////////////////////
    // MARK: - Number Label Variables
    /////////////////////////////////
    private let numberLabelFont: UIFont = .dense(size: 70)
    private let numberLabelTextAlignment: NSTextAlignment = .center
    private let numberLabelIsEmptyText: String = ""
    
    ///////////////////////////
    // MARK: - Button Variables
    ///////////////////////////
    private let buttonPadding: CGFloat = 10
    private let buttonHeight: CGFloat = 55
    private let buttonTitleColor: UIColor = .white
    
    //////////////////////////////////
    // MARK: - Number Button Variables
    //////////////////////////////////
    private var numberButtons = [UIButton(), UIButton(), UIButton(), UIButton(),
                                 UIButton(), UIButton(), UIButton(), UIButton(),
                                 UIButton(), UIButton()]
    private var numberLabel = UILabel()
    private let numberButtonTitleColor: UIColor = .white
    private let numberButtonFont: UIFont = .dense(size: 35)
    private let numberButtonCornerRadius: CGFloat = 15
    private let numberButtonAction: Selector = #selector(numberButtonPressed)
    
    //////////////////////////////////
    // MARK: - Delete Button Variables
    //////////////////////////////////
    private var deleteButton = UIButton()
    private let deleteButtonBackgroundColor: UIColor = .clear
    private let deleteButtonAction: Selector = #selector(deleteButtonPressed)
    private let deleteButtonImage: UIImage = .numPadDelete
    private var deleteButtonVisibleAlpha: CGFloat = 1.0
    private var deleteButtonInvisibleAlpha: CGFloat = 0.0
    
    //////////////////////////////////
    // MARK: - Accpet Button Variables
    //////////////////////////////////
    private var acceptButton  = UIButton()
    private let acceptButtonCornerRadius: CGFloat = 15
    private let acceptButtonFont: UIFont = .tondo(weight: .bold, size: 22)
    private var acceptButtonAction: Selector = #selector(acceptButtonPressed)
    private var acceptButtonDefaultTitle: String = "CANCEL"
    

    
    ////////////////////
    // MARK: - Lifecycle
    ////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 1.0,
                       options: [.autoreverse, .repeat, .curveEaseInOut],
                       animations: {
                        self.cursorView.backgroundColor = self.dataSource.numberPadPopUpSetTextColor(self)
        })
    }
    
    //////////////////////////////
    // MARK: - UIPopUpViewDelegate
    //////////////////////////////
    override func popUpViewSize(_ popUpView: UIView) -> CGSize {
        return numberPadSize
    }
    
    override func popUpView(_ popUpView: UIView, willDisplayWithSize size: CGSize) {
        addCursorView(toPopUpView: popUpView, popUpSize: size)
        addNumberLabel(toPopUpView: popUpView, popUpSize: size)
        addNumberButtons(toPopUpView: popUpView, popUpSize: size)
        addDeleteButton(toPopUpView: popUpView, popUpSize: size)
        addAcceptButton(toPopUpView: popUpView, popUpSize: size)
    }

    //////////////////////
    // MARK: - UI Elements
    //////////////////////
    private func addCursorView(toPopUpView popUpView: UIView, popUpSize size: CGSize) {
        let xOrigin = size.width/2 - cursorSize.width/2
        cursorView.backgroundColor = .clear
        cursorView.alpha           = cursorVisibleAlpha
        cursorView.frame.size      = cursorSize
        cursorView.frame.origin    = CGPoint(x: xOrigin, y: cursorYOrigin)
        popUpView.addSubview(cursorView)
    }
    
    private func addNumberLabel(toPopUpView popUpView: UIView, popUpSize size: CGSize) {
        let width  = size.width
        let height = size.height - buttonHeight*5 - buttonPadding*6
        numberLabel.textColor     = dataSource.numberPadPopUpSetTextColor(self)
        numberLabel.font          = numberLabelFont
        numberLabel.textAlignment = numberLabelTextAlignment
        numberLabel.text          = numberLabelIsEmptyText
        numberLabel.frame.size    = CGSize(width: width, height: height)
        popUpView.addSubview(numberLabel)
    }
    
    private func addNumberButtons(toPopUpView popUpView: UIView, popUpSize size: CGSize) {
        let w = (size.width - (4*buttonPadding))/3
        let h = buttonHeight
        let s = buttonPadding
        
        for (i, button) in numberButtons.enumerated() {
            var origin: CGPoint {
                switch i {
                case 1:  return CGPoint(x: 1*s + 0*w, y: size.height - 5*s - 5*h)
                case 2:  return CGPoint(x: 2*s + 1*w, y: size.height - 5*s - 5*h)
                case 3:  return CGPoint(x: 3*s + 2*w, y: size.height - 5*s - 5*h)
                case 4:  return CGPoint(x: 1*s + 0*w, y: size.height - 4*s - 4*h)
                case 5:  return CGPoint(x: 2*s + 1*w, y: size.height - 4*s - 4*h)
                case 6:  return CGPoint(x: 3*s + 2*w, y: size.height - 4*s - 4*h)
                case 7:  return CGPoint(x: 1*s + 0*w, y: size.height - 3*s - 3*h)
                case 8:  return CGPoint(x: 2*s + 1*w, y: size.height - 3*s - 3*h)
                case 9:  return CGPoint(x: 3*s + 2*w, y: size.height - 3*s - 3*h)
                default: return CGPoint(x: 2*s + 1*w, y: size.height - 2*h - 2*s)
                }
            }
            
            button.titleLabel?.font   = numberButtonFont
            button.backgroundColor    = dataSource.numberPadPopUpSetNumberButtonColor(self)
            button.layer.cornerRadius = numberButtonCornerRadius
            button.frame.size         = CGSize(width: w, height: h)
            button.frame.origin       = origin
            button.tag                = i
            button.setTitle(i.description, for: .normal)
            button.setTitleColor(numberButtonTitleColor, for: .normal)
            button.addTarget(self, action: numberButtonAction, for: .touchUpInside)
            popUpView.addSubview(button)
        }
    }
    
    private func addDeleteButton(toPopUpView popUpView: UIView, popUpSize size: CGSize) {
        let width   = (size.width - (4*buttonPadding))/3
        let xOrigin = 3*buttonPadding + 2*width
        let yOrigin = size.height - 2*buttonPadding - 2*buttonHeight
        deleteButton.backgroundColor = deleteButtonBackgroundColor
        deleteButton.tintColor       = dataSource.numberPadPopUpSetNumberButtonColor(self)
        deleteButton.frame.origin    = CGPoint(x: xOrigin, y: yOrigin)
        deleteButton.frame.size      = CGSize(width: width, height: buttonHeight)
        deleteButton.alpha           = deleteButtonInvisibleAlpha
        deleteButton.imageView?.contentMode = .scaleAspectFit
        deleteButton.setImage(deleteButtonImage, for: .normal)
        deleteButton.addTarget(self, action: deleteButtonAction, for: .touchUpInside)
        popUpView.addSubview(deleteButton)
    }
    
    private func addAcceptButton(toPopUpView popUpView: UIView, popUpSize size: CGSize) {
        let xOrigin = buttonPadding
        let yOrigin = size.height - buttonHeight - buttonPadding
        let width   = size.width - (2*buttonPadding)
        let height  = buttonHeight
        acceptButton.backgroundColor    = dataSource.numberPadPopUpSetNumberButtonColor(self)
        acceptButton.frame.origin       = CGPoint(x: xOrigin, y: yOrigin)
        acceptButton.frame.size         = CGSize(width: width, height: height)
        acceptButton.titleLabel?.font   = acceptButtonFont
        acceptButton.layer.cornerRadius = acceptButtonCornerRadius
        acceptButton.setTitle(acceptButtonDefaultTitle.uppercased(), for: .normal)
        acceptButton.setTitleColor(buttonTitleColor, for: .normal)
        acceptButton.addTarget(self, action: acceptButtonAction, for: .touchUpInside)
        popUpView.addSubview(acceptButton)
    }
    
    @objc func numberButtonPressed(_ sender: UIButton) {
        if canEnterANumber() {
            numberLabel.text?.append(sender.tag.description)
        }
        updateComponents()
    }
    
    @objc func deleteButtonPressed(_ sender: UIButton) {
        if userHasEnteredNumbers() {
            numberLabel.text?.removeLast()
        }
        updateComponents()
    }
    
    @objc func acceptButtonPressed(_ sender: UIButton) {
        if userHasEnteredNumbers() {
            let enteredNum = Int(self.numberLabel.text!)!
            dismiss(shouldBounce: true, finished: {
                self.delegate?.numberPadPopUp(self, didDismissWithNumber: enteredNum)
            })
            
        } else {
            dismiss(shouldBounce: false)
        }
    }
    
    //////////////////////////////
    // MARK: - Helpers & Utilities
    //////////////////////////////
    private func canEnterANumber() -> Bool {
        return numberLabel.text?.count ?? 0 < numberPadMaxCharacterCount
    }
    
    private func userHasEnteredNumbers() -> Bool {
        return numberLabel.text?.count ?? 0 > 0
    }
    
    private func updateComponents() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .beginFromCurrentState, animations: {
            if self.userHasEnteredNumbers() {
                self.cursorView.alpha = self.cursorInvisibleAlpha
                self.deleteButton.alpha = self.deleteButtonVisibleAlpha
                let title = self.dataSource.numberPadPopUpSetAcceptButtonTitle(self)
                self.acceptButton.setTitle(title.uppercased(), for: .normal)
                self.acceptButton.backgroundColor = self.dataSource.numberPadPopUpSetAcceptButtonColor(self)
            } else {
                self.cursorView.alpha = self.cursorVisibleAlpha
                self.deleteButton.alpha = self.deleteButtonInvisibleAlpha
                let title = self.acceptButtonDefaultTitle
                self.acceptButton.setTitle(title.uppercased(), for: .normal)
                self.acceptButton.backgroundColor = self.dataSource.numberPadPopUpSetNumberButtonColor(self)
            }
        })
    }
}

extension UINumberPadPopUpViewController: UINumberPadPopUpViewControllerDataSource {
    func numberPadPopUpSetTextColor(_ numberPadPopUp: UINumberPadPopUpViewController) -> UIColor {
        return .black
    }
    
    func numberPadPopUpSetNumberButtonColor(_ numberPadPopUp: UINumberPadPopUpViewController) -> UIColor {
        return UIColor.init(red: 0.56, green: 0.62, blue: 0.66, alpha: 1.0)
    }
    
    func numberPadPopUpSetAcceptButtonColor(_ numberPadPopUp: UINumberPadPopUpViewController) -> UIColor {
        return UIColor.init(red: 0.30, green: 0.62, blue: 0.85, alpha: 1.0)
    }
    
    func numberPadPopUpSetAcceptButtonTitle(_ numberPadPopUp: UINumberPadPopUpViewController) -> String {
        return "SET"
    }
}
