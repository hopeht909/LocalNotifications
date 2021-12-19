//
//  ViewController.swift
//  LocalNotifications
//
//  Created by admin on 17/12/2021.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var timerSet: UILabel!
    @IBOutlet weak var cancelSetLabel: UILabel!
    @IBOutlet weak var workUntilLabel: UILabel!
    var bookmark: [String] = []
    
    let timerPicker = ["5 minutes", "10 minutes", "20 minutes", "30 minutes"]
    let time = [5, 10, 20, 30]
    
    var timerInterval: TimeInterval = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newDay()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return timerPicker[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return timerPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        return NSAttributedString(string: timerPicker[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        timerInterval = TimeInterval(time[row])
    }
    
    @IBAction func addTimer(_ sender: UIBarButtonItem) {
        showAlertAddTimer()
    }
    
    @IBAction func cancelTimerClicked(_ sender: UIBarButtonItem) {
        showAlertCancel()
    }
    
    @IBAction func bookmarkHistoryClicked(_ sender: UIBarButtonItem) {
        saveTheHistoryOfChanges()
    }
    
    @IBAction func startTimerClicked(_ sender: UIButton) {
        showAlertCountdown()
    }
    
    //Start the Timer alert
    func showAlertCountdown() {
        let alertVC = UIAlertController.init(title: "\(Int(timerInterval)) min Countdown", message: "After \(Int(timerInterval)), you'll be notified\n turn you ringer on", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .cancel) { action in
            self.startTimer()
        }
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //Start a new Timer, alert
    func showAlertAddTimer() {
        let alertVC = UIAlertController.init(title: "Are you sure it's a new day?", message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        let action = UIAlertAction.init(title: "New Day", style: .destructive) { action in
            self.newDay()
        }
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //Cancel alert
    func showAlertCancel() {
        let alertVC = UIAlertController.init(title: "Cancel current timer?", message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: "Back", style: .cancel, handler: nil))
        
        let action = UIAlertAction.init(title: "Cancel", style: .destructive) { action in
            self.cancel()
        }
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
    
     //After running The Timer update The Labels and Variable to The New ones
     func setValues() {
         
        let minutes: TimeInterval = timerInterval * 60
        let cuttentTime = Date()
        let newTime = Date() + minutes
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
        let date = dateFormatter.string(from: newTime)
        let current = dateFormatter.string(from: cuttentTime)
        
        workUntilLabel.isHidden = false
        cancelSetLabel.isHidden = false
        timerSet.isHidden = false
        timePicker.isHidden = false
        workUntilLabel.text =  "Work until: \(date)"
        cancelSetLabel.text = "\(Int(timerInterval)) Minute Timer Set"
        totalTimeLabel.text = "Total time: \(Int(timerInterval))"
        timerSet.text = "0 hours, \(Int(timerInterval)) min"
        let statement = "\(current) - \(date) \(Int(timerInterval)) Minute Timer"
        bookmark.append(statement)
    }
    
    //Save the User History
    func saveTheHistoryOfChanges() {
        
        totalTimeLabel.text = "Total time: \(Int(timerInterval))"
        timerSet.text = "0 hours, \(Int(timerInterval)) min"
        cancelSetLabel.isHidden = false
        workUntilLabel.isHidden = true
        timePicker.isHidden = true
        let string = bookmark.joined(separator: "\n")
        cancelSetLabel.text = string
    }
    
    //Start Notification Timer
    func startTimer(){
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Wake up!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Rise and shine! It's morning time!", arguments: nil)
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timerInterval) * 60, repeats: false)
        
        let request = UNNotificationRequest(identifier: "Reminder", content: content, trigger: trigger)
        
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        setValues()
    }
    //Set The Values to defalut
    func newDay(){
        totalTimeLabel.text = "Total time: 0"
        timerSet.isHidden = true
        cancelSetLabel.isHidden = true
        workUntilLabel.isHidden = true
        timePicker.isHidden = false
        
    }
    //Cancel The timer
    func cancel(){
        totalTimeLabel.text = "Total time: 0"
        timerSet.text = "0 hours, 0 min"
        cancelSetLabel.text = "\(Int(timerInterval)) Minute Timer Cancelled"
        workUntilLabel.isHidden = true
        bookmark.append("\(Int(timerInterval)) Minute Timer Cancelled")
        timePicker.isHidden = false
    }
}
