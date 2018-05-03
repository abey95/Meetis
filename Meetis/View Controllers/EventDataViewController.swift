//
//  EventDataViewController.swift
//  Meetis
//
//  Created by Kyle Thompson on 4/11/18.
//  Copyright © 2018 Abey Yoseph. All rights reserved.
//

import UIKit
/*
 ---------------------------------
 MARK: Protocol Method Declaration
 ---------------------------------
 */
protocol EventDataViewControllerProtocol {
    
    func eventDataViewController(_ controller: EventDataViewController, didFinishWithSave save: Bool)
}
class EventDataViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var timeTextField: UITextField!
    @IBOutlet var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet var sundayButton: UIButton!
    @IBOutlet var mondayButton: UIButton!
    @IBOutlet var tuesdayButton: UIButton!
    @IBOutlet var wednesdayButton: UIButton!
    @IBOutlet var thursdayButton: UIButton!
    @IBOutlet var fridayButton: UIButton!
    @IBOutlet var saturdayButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    var buttonArray : [UIButton]!
    
     var delegate: EventDataViewControllerProtocol?
    
    
    @IBOutlet var editSaveButton: UIBarButtonItem!
    
    var isEdit: Bool!
    
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    var eventDataPassed: Event?

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonArray = [sundayButton, mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton]
        for but in buttonArray {
            but.isEnabled = false
        }
        
        isEdit = true

        let navigationBarWidth = self.navigationController?.navigationBar.frame.width
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height
        let labelRect = CGRect(x: 0, y: 0, width: navigationBarWidth!, height: navigationBarHeight!)
        let titleLabel = UILabel(frame: labelRect)
        
        titleLabel.text = eventDataPassed?.title
        
        titleLabel.font = titleLabel.font.withSize(17)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        self.navigationItem.titleView = titleLabel
        
        
        switch eventDataPassed!.category {
        case .school:
            imageView!.image = UIImage(named: "school.png")
            break
        case .family:
            imageView!.image = UIImage(named: "family.png")
        case .personal:
            imageView!.image = UIImage(named: "person.png")
        case .travel:
            imageView!.image = UIImage(named: "travel.png")
        default:
            imageView!.image = UIImage(named: "work.png")
            
        }
        
        categoryLabel.text = eventDataPassed!.category.rawValue
        timeTextField.text = eventDataPassed?.time
        
        if eventDataPassed?.priority == "low" {
            prioritySegmentedControl.selectedSegmentIndex = 0
        }
        else if eventDataPassed?.priority == "medium" {
            prioritySegmentedControl.selectedSegmentIndex = 1
        }
        else {
            prioritySegmentedControl.selectedSegmentIndex = 2
        }
        
        for i in 0 ..< eventDataPassed!.days.count {
            if eventDataPassed!.days[i] {
                buttonArray[i].setBackgroundImage(UIImage(named: "blue_circle.png"), for: UIControlState.normal)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func editSaveTapped(_ sender: UIBarButtonItem) {
        
        if isEdit {
            
            editSaveButton.title = "Save"

            for but in buttonArray {
                but.isEnabled = true
            }
            deleteButton.isHidden = false
            timeTextField.isEnabled = true
            prioritySegmentedControl.isEnabled = true
            
        }
        else {
            eventDataPassed?.time = timeTextField.text
            
            if prioritySegmentedControl.selectedSegmentIndex == 0 {
                eventDataPassed?.priority = "low"
            }
            else if prioritySegmentedControl.selectedSegmentIndex == 1 {
                eventDataPassed?.priority = "medium"
            }
            else {
                eventDataPassed?.priority = "high"
                
            }
            
            
            delegate!.eventDataViewController(self, didFinishWithSave:true)
            
        }
        isEdit = !isEdit
    }
    
    
    // The weekButtonTapped method is invoked when the user taps the Add button created in viewDidLoad() above.
    @IBAction func weekButtonTapped(_ sender: UIButton) {
        
        eventDataPassed?.days[sender.tag] = !(eventDataPassed?.days[sender.tag])!
        
        if eventDataPassed?.days[sender.tag] == true {
            sender.setBackgroundImage(UIImage(named: "blue_circle.png"), for: UIControlState.normal)
        }
        else {
            sender.setBackgroundImage(nil, for: UIControlState.normal)
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Delete", message: "Are You Sure You Want To Delete This Event? ", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
            self.eventDataPassed?.active = false;
            self.delegate!.eventDataViewController(self, didFinishWithSave:true)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            
            refreshAlert.dismiss(animated: true, completion: nil)
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        

    }
    
    
    /*
     ------------------------
     MARK: - IBAction Methods
     ------------------------
     */
    @IBAction func keyboardDone(_ sender: UITextField) {
        
        // When the Text Field resigns as first responder, the keyboard is automatically removed.
        sender.resignFirstResponder()
    }
    
    @IBAction func backgroundTouch(_ sender: UIControl) {
        /*
         "This method looks at the current view and its subview hierarchy for the text field that is
         currently the first responder. If it finds one, it asks that text field to resign as first responder.
         If the force parameter is set to true, the text field is never even asked; it is forced to resign." [Apple]
         
         When the Text Field resigns as first responder, the keyboard is automatically removed.
         */
        view.endEditing(true)
    }
    
    /*
     -----------------------------
     MARK: - Validate input
     -----------------------------
     */
    func inputValid() -> Bool{
        if timeTextField.text!.isEmpty{
            showAlertMessage(messageHeader: "No Time Entered!", messageBody: "Please enter the time for the event. Example: 12:15")
            return false
        } else {
            let min_hr = timeTextField.text!.split(separator: ":")
            if min_hr.count != 2 {
                showAlertMessage(messageHeader: "Time Read Error!", messageBody: "Please enter a time in the format hh:mm")
                return false
            }
            if Int(min_hr[0]) == nil {
                showAlertMessage(messageHeader: "Hours Read Error!", messageBody: "Please enter a time in the format hh:mm")
                return false
            }
            if Int(min_hr[1]) == nil {
                showAlertMessage(messageHeader: "Minutes Read Error!", messageBody: "Please enter a time in the format hh:mm")
                return false
            }
        }
        
        for check in eventDataPassed!.days {
            if check {
                return true;
            }
        }
        showAlertMessage(messageHeader: "Missing Selected Days!", messageBody: "Please select the days for the event")
        return false
    }
    
    /*
     -----------------------------
     MARK: - Display Alert Message
     -----------------------------
     */
    func showAlertMessage(messageHeader header: String, messageBody body: String) {
        
        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: header, message: body, preferredStyle: UIAlertControllerStyle.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
}

