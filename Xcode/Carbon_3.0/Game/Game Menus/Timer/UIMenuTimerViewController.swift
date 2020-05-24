//
//  UIMenuTimerViewController.swift
//  Carbon_3.0
//
//  Created by Matt Marks on 11/3/18.
//  Copyright © 2018 Matt Marks. All rights reserved.
//

import UIKit

////////////////////////////////////
// MARK: - UIMenuTimerViewController
////////////////////////////////////
class UIMenuTimerViewController: UIPageViewControllerPage {

    //////////////////////////////////
    // MARK: Interface Builder Outlets
    //////////////////////////////////
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var editButton: UIAnimatableButton!
    @IBOutlet weak var resetButton: UIAnimatableButton!
    @IBOutlet weak var playPauseButton: UIAnimatableButton!
    @IBOutlet weak var alertAtEndSwitch: UIThemeableSwitch!
    @IBOutlet weak var alertAtFiveSwitch: UIThemeableSwitch!
    @IBOutlet weak var alertAtTenSwitch: UIThemeableSwitch!
    @IBOutlet weak var displayTimeSwitch: UIThemeableSwitch!
    
    ///////////////////////////
    // MARK: Computed Variables
    ///////////////////////////
    private var game: UIGameViewController {
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.window?.rootViewController as! UIGameViewController
    }
    
    //////////////////
    // MARK: Lifecycle
    //////////////////
    
    // When this is loaded into memory we tell the game object that we need
    // information about the timer. If the timer is running the game object
    // needs to push the current time to the time label. If the timer is
    // stopped the game needs to notify this view controller so we can change
    // the activeness of the buttons properly.
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForEntranceAnimation()
        
        // The game has a UIGameViewControllerTimeDelegate that it will
        //push info to about the timer.
        game.auxiliaryTimeMenu = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTimeLabel()
        updateButtonActiveness()
        updatePlayPauseButtonBackgroundImage()
        updateSwitchValues()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performEntranceAnimation()
    }
    
    /////////////////
    // MARK: Switches
    /////////////////
    
    // When the view appears we need to set the switched on/off values
    // to accurately reflect the chosen values.
    private func updateSwitchValues() {
        alertAtEndSwitch.isOn  = game.willAlertAtEnd()
        alertAtFiveSwitch.isOn = game.willAlertAtFive()
        alertAtTenSwitch.isOn  = game.willAlertAtTen()
        displayTimeSwitch.isOn = game.isDisplayingTime()
    }
    
    // The switches all have unique tags so we can chain them all to the same
    // IBAction. When toggled, the switch will update the users preference
    // in the game object.
    @IBAction func switchToggled(_ sender: UISwitch) {
        switch sender.tag {
        case 0: game.toggleAlertAtEnd()
        case 1: game.toggleAlertAtFive()
        case 2: game.toggleAlertAtTen()
        case 3: game.toggleDisplayTime()
        default: ()
        }
    }
    
    ////////////////
    // MARK: Buttons
    ////////////////
    
    // If the timer is running the user should not be able to edit its time.
    // If the timer is running the user should not be able to reset it.
    // This method is called whenever this view controller appears and also
    // whenever a button is pressed.
    private func updateButtonActiveness() {
        editButton.isEnabled = !game.isTimerRunning()
        resetButton.isEnabled = !game.isTimerRunning()
    }
    
    // If the timer is running the play/pause button should show a pause symbol.
    // otherwise it should show a play symbol. This method is called whenever
    // this view controller appears and also whenever a button is pressed.
    private func updatePlayPauseButtonBackgroundImage() {
        let image: UIImage = game.isTimerRunning() ? .pause : .play
        playPauseButton.setBackgroundImage(image, for: .normal)
    }
    
    // When the edit button is pressed a pop is presented that allows the user
    // to set a specified time. This can obly be pressed when the timer
    // is not running.
    @IBAction func editButtonPressed(_ sender: UIAnimatableButton) {
        let timePicker = UITimePickerPopUpViewController()
        timePicker.delegate = self
        timePicker.dataSource = self
        
        switch UserPreferences.appTheme {
        case 1: timePicker.setPopUpViewBackgroundColor(UIColor.darkForeground)
        case 2: timePicker.setPopUpViewBackgroundColor(UIColor.blackForeground)
        default: timePicker.setPopUpViewBackgroundColor(UIColor.lightForeground)
        }
        
        present(timePicker, animated: false)
    }
    
    // The reset button will stop the timer and set the time
    // to it's initial value.
    @IBAction func resetButtonPressed(_ sender: UIAnimatableButton) {
        game.cancelMatchTimer()
        updateButtonActiveness()
        updatePlayPauseButtonBackgroundImage()
        sender.performSpinAnimation()
    }
    
    // The play pause button will start and stop the timer. If time has passed,
    // it will resume the timer. Otherwise it starts the timer again from scratch.
    @IBAction func playPauseButtonPressed(_ sender: UIAnimatableButton) {
        if game.isTimerRunning() {
            game.pauseMatchTimer()
        } else if game.hasTimePassed() {
            game.resumeMatchTimer()
        } else {
            game.startMatchTimer()
        }
        updateButtonActiveness()
        updatePlayPauseButtonBackgroundImage()
    }

    
    ////////////////////////
    // MARK: Big Time Label
    ////////////////////////
    
    // The big time label will display the current time on the timer.
    private func updateTimeLabel() {
        let time    = game.getCurrentTime()
        let mins    = (time / 60)
        let secs    = (time % 60)
        let minText = mins < 10 ? ("0" + mins.description) : mins.description
        let secText = secs < 10 ? ("0" + secs.description) : secs.description
        timeLabel.text = minText + ":" + secText
    }
    
    ///////////////////
    // MARK: Animations
    ///////////////////
    private func prepareForEntranceAnimation() {
        if (pageController as! UIMenuPageViewController).getInitialPage() == .timer {
            for subview in view.subviews {
                subview.prepareForEntranceAnimation()
            }
        }
    }
    
    private func performEntranceAnimation() {
        if (pageController as! UIMenuPageViewController).getInitialPage() == .timer {
            for subview in view.subviews {
                subview.performEntranceAnimation()
            }
        }
    }

}


extension UIMenuTimerViewController: UITimePickerPopUpViewControllerDelegate {
    func timePickerPopUp(_ timePickerPopUp: UITimePickerPopUpViewController, didDismissWithMins mins: Int, andSeconds secs: Int) {
        game.setInitialTime((60 * mins) + secs)
        game.setCurrentTime((60 * mins) + secs)
    }
}

extension UIMenuTimerViewController: UITimePickerPopUpViewControllerDataSource {
    func timePickerPopUpSetInitialMins(_ numberPadPopUp: UITimePickerPopUpViewController) -> Int {
        return game.getCurrentTime() / 60
    }
    
    func timePickerPopUpSetInitialSecs(_ numberPadPopUp: UITimePickerPopUpViewController) -> Int {
        return game.getCurrentTime() % 60
    }
    
    func timePickerPopUpSetTextColor(_ numberPadPopUp: UITimePickerPopUpViewController) -> UIColor {
        switch UserPreferences.appTheme {
        case 1: return .white
        case 2: return .white
        default: return .black
        }
    }
    
    func timePickerPopUpSetSetButtonColor(_ numberPadPopUp: UITimePickerPopUpViewController) -> UIColor {
        return UserPreferences.accentColor
    }
    
    func timePickerPopUpSetSetButtonTitle(_ numberPadPopUp: UITimePickerPopUpViewController) -> String {
        return "SET"
    }
    
    
}

// MARK: - UIGameViewControllerTimeDelegate
extension UIMenuTimerViewController: UIGameViewControllerTimeDelegate {
    
    func timeDidChange(toTime time: Int) {
        updateTimeLabel()
    }
    
    func timerDidChange(toState running: Bool) {
        updateTimeLabel()
        updateButtonActiveness()
        updatePlayPauseButtonBackgroundImage()
    }
}
