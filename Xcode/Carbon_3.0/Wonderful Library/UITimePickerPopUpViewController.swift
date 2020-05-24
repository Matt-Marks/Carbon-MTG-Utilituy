//
//  UITimeSelectionPopUpViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 1/10/19.
//  Copyright © 2019 Matt Marks. All rights reserved.
//

import UIKit


protocol UITimePickerPopUpViewControllerDataSource {
    func timePickerPopUpSetInitialMins(_ numberPadPopUp: UITimePickerPopUpViewController) -> Int
    func timePickerPopUpSetInitialSecs(_ numberPadPopUp: UITimePickerPopUpViewController) -> Int
    func timePickerPopUpSetTextColor(_ numberPadPopUp: UITimePickerPopUpViewController) -> UIColor
    func timePickerPopUpSetSetButtonColor(_ numberPadPopUp: UITimePickerPopUpViewController) -> UIColor
    func timePickerPopUpSetSetButtonTitle(_ numberPadPopUp: UITimePickerPopUpViewController) -> String
}

protocol UITimePickerPopUpViewControllerDelegate {
    func timePickerPopUp(_ timePickerPopUp: UITimePickerPopUpViewController,
                         didDismissWithMins mins: Int, andSeconds secs: Int)
}

class UITimePickerPopUpViewController: UIPopUpViewController {

    
    ///////////////////////////////
    // MARK: - Delegation Variables
    ///////////////////////////////
    public var dataSource: UITimePickerPopUpViewControllerDataSource!
    public var delegate: UITimePickerPopUpViewControllerDelegate?
    
    ////////////////////////////////
    // MARK: - Time Picker Variables
    ////////////////////////////////
    private var timePickerView         = UIPickerView()
    private let timePickerSize: CGSize = CGSize(width: 300, height: 380)
    private let pickerComponents: Int  = 2
    private let minComponent: Int      = 0
    private let secComponent: Int      = 1
    private let minRows: Int           = 100
    private let secRows: Int           = 2400
    private let rowHeight: CGFloat     = 65
    private let pickerFont: UIFont     = .dense(size: 65)
    
    ////////////////////////////////
    // MARK: - Colon Label Variables
    ////////////////////////////////
    private var colonLabel: UILabel                      = UILabel()
    private var colonLabelTextAlignmant: NSTextAlignment = .center
    private var colonLabelText: String                   = ":"
    private var colonLabelFont: UIFont                   = .dense(size: 65)
    
    ///////////////////////////////
    // MARK: - Set Button Variables
    ///////////////////////////////
    private var setButton: UIButton            = UIButton()
    private var setButtonPadding: CGFloat      = 10
    private var setButtonCornerRadius: CGFloat = 15
    private var setButtonHeight: CGFloat       = 55
    private var setButtonFont: UIFont          = .tondo(weight: .bold, size: 22)
    private var setButtonAction: Selector      = #selector(setButtonPressed)
    private var setButtonTitleColor: UIColor   = .white
    private var setButtonTitle: String         = "SET"
    
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
        return timePickerSize
    }
    
    override func popUpView(_ popUpView: UIView, willDisplayWithSize size: CGSize) {
        addColonLabel(toPopUpView: popUpView, popUpSize: size)
        addTimePickerView(toPopUpView: popUpView, popUpSize: size)
        addSetButton(toPopUpView: popUpView, popUpSize: size)
    }
    
    //////////////////////
    // MARK: - UI Elements
    //////////////////////
    private func addColonLabel(toPopUpView popUpView: UIView, popUpSize size: CGSize) {
        let height = size.height - setButtonHeight - (2*setButtonPadding) - 15
        colonLabel.textAlignment = colonLabelTextAlignmant
        colonLabel.text          = colonLabelText
        colonLabel.textColor     = dataSource.timePickerPopUpSetTextColor(self)
        colonLabel.font          = colonLabelFont
        colonLabel.frame.origin  = CGPoint.zero
        colonLabel.frame.size    = CGSize(width: size.width, height: height)
        popUpView.addSubview(colonLabel)
    }
    
    private func addTimePickerView(toPopUpView popUpView: UIView, popUpSize size: CGSize) {
        let mins = dataSource.timePickerPopUpSetInitialMins(self)
        let secs = dataSource.timePickerPopUpSetInitialSecs(self)
        let height = size.height - setButtonHeight - (2*setButtonPadding)
        timePickerView.delegate     = self
        timePickerView.dataSource   = self
        timePickerView.frame.origin = CGPoint.zero
        timePickerView.frame.size   = CGSize(width: size.width, height: height)
        timePickerView.selectRow(mins, inComponent: minComponent, animated: false)
        timePickerView.selectRow(1200 + secs, inComponent: secComponent, animated: false)
        popUpView.addSubview(timePickerView)
        
        for subview in timePickerView.subviews {
            if subview.frame.height < 1 {
                let newIndicator = UIView(frame: subview.frame)
                newIndicator.backgroundColor = dataSource.timePickerPopUpSetTextColor(self)
                timePickerView.addSubview(newIndicator)
            }
        }
    }
    
    private func addSetButton(toPopUpView popUpView: UIView, popUpSize size: CGSize) {
        let xOrigin = setButtonPadding
        let yOrigin = size.height - setButtonPadding - setButtonHeight
        let width   = size.width - (2*setButtonPadding)
        let height  = setButtonHeight
        let title   = dataSource.timePickerPopUpSetSetButtonTitle(self)
        setButton.layer.cornerRadius = setButtonCornerRadius
        setButton.titleLabel?.font   = setButtonFont
        setButton.frame.origin       = CGPoint(x: xOrigin, y: yOrigin)
        setButton.frame.size         = CGSize(width: width, height: height)
        setButton.isEnabled          = true
        setButton.backgroundColor    = dataSource.timePickerPopUpSetSetButtonColor(self)
        setButton.setTitle(title.uppercased(), for: .normal)
        setButton.setTitleColor(setButtonTitleColor, for: .normal)
        setButton.addTarget(self, action: setButtonAction, for: .touchUpInside)
        popUpView.addSubview(setButton)
    }

    @objc func setButtonPressed(_ sender: UIButton) {
        let mins = timePickerView.selectedRow(inComponent: minComponent)
        let secs = timePickerView.selectedRow(inComponent: secComponent) % 60
        delegate?.timePickerPopUp(self, didDismissWithMins: mins, andSeconds: secs)
        dismiss(shouldBounce: true)
    }
    
}

extension UITimePickerPopUpViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView,
                    rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }
    
    // Instead of setting the text in each row of the UIPicker, we replace each
    // row with a UILabel. This allows us to cusomize the text's font, color,
    // size, etc.
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                    forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label: UITimePickerPopUpLabel!
        
        if component == minComponent {
            label = UITimePickerPopUpLabel(textAlignment: .right)
        } else {
            label = UITimePickerPopUpLabel(textAlignment: .left)
        }
        
        let num  = component == 0 ? row : row % 60
        let text = num.description
        label.text      = num < 10 ? "0" + text : text
        label.textColor = dataSource.timePickerPopUpSetTextColor(self)
        label.font      = pickerFont
        return label
    }
    
}

/////////////////////////////////
// MARK: - UIPickerViewDataSource
/////////////////////////////////
extension UITimePickerPopUpViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == minComponent ? minRows : secRows
    }
}

////////////////////////////////////////////////////
// MARK: - UITimePickerPopUpViewControllerDataSource
////////////////////////////////////////////////////
extension UITimePickerPopUpViewController: UITimePickerPopUpViewControllerDataSource {
    func timePickerPopUpSetInitialMins(_ numberPadPopUp: UITimePickerPopUpViewController) -> Int {
        return 50
    }
    func timePickerPopUpSetInitialSecs(_ numberPadPopUp: UITimePickerPopUpViewController) -> Int {
        return 0
    }
    
    func timePickerPopUpSetTextColor(_ numberPadPopUp: UITimePickerPopUpViewController) -> UIColor {
        return .black
    }
    
    func timePickerPopUpSetSetButtonColor(_ numberPadPopUp: UITimePickerPopUpViewController) -> UIColor {
        return UIColor.init(red: 0.30, green: 0.62, blue: 0.85, alpha: 1.0)
    }
    
    func timePickerPopUpSetSetButtonTitle(_ numberPadPopUp: UITimePickerPopUpViewController) -> String {
        return "SET"
    }
}

/////////////////////////////////
// MARK: - UITimePickerPopUpLabel
/////////////////////////////////

// The UIPIcker's rows are make of these labels. We have to make a new label
// class to make sure that out text padding is correct.
class UITimePickerPopUpLabel: UILabel {
    
    convenience init(textAlignment: NSTextAlignment) {
        self.init()
        self.textAlignment = textAlignment
    }
    
    override func drawText(in rect: CGRect) {
        let top: CGFloat    = 0
        let bottom: CGFloat = 0
        let left: CGFloat   = textAlignment == .left ? 32 : 0
        let right: CGFloat  = textAlignment == .right ? 31 : 0
        let insets  = UIEdgeInsets.init(top: top, left: left, bottom: bottom, right: right)
        let newRect = rect.inset(by: insets)
        super.drawText(in: newRect)
    }
    
}
