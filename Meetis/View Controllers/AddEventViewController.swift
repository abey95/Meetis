//
//  AddEventViewController.swift
//  Meetis
//
//  Created by CS3714 on 4/11/18.
//  Copyright © 2018 Abey Yoseph. All rights reserved.
//

import UIKit


/*
 ---------------------------------
 MARK: Protocol Method Declaration
 ---------------------------------
 */
protocol AddEventViewControllerProtocol {
    
    func addEventViewController(_ controller: AddEventViewController, didFinishWithSave save: Bool)
}

class AddEventViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var prioritySegmentedControl: UISegmentedControl!
    
    @IBOutlet var timeTextField: UITextField!
    
    /*
     Whichever object wants to conform to our protocol declared above must store its unique ID into this
     instance variable named "delegate" and provide the implementation of the protocol method.
     */
    var delegate: AddEventViewControllerProtocol?
    
    var days = [Bool]()
    var selectedCategory: EventCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        days = [Bool](repeating: false, count: 7)
        
        
        // Create a Save button on the right of the navigation bar to call the "save:" method when tapped
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(AddEventViewController.saveButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = saveButton
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Obtain the number of the row in the middle of the university names list
        let numberOfRowToShow = Int(EventCategory.allValues.count / 2)
        
        // Show the picker view of the university names from the middle
        pickerView.selectRow(numberOfRowToShow, inComponent: 0, animated: false)
        
        super.viewWillAppear(animated)
        
        // Set the segmented control to show no selection before the view appears
        prioritySegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // Toggle the button that sent this action
    @IBAction func tapped(_ sender: UIButton) {
        
        // The tag numbers are given in the storyboard for the UIButton objects
        let currentTagNumber = sender.tag
        
        //flip active boolean
        days[currentTagNumber] = !days[currentTagNumber]
        
        if days[currentTagNumber] {
            sender.backgroundColor = UIColor.blue
            sender.titleLabel?.textColor = UIColor.white
        } else {
            sender.backgroundColor = UIColor.clear
            sender.titleLabel?.textColor = UIColor.blue
        }
        
    }
    
    /*
     -------------------
     MARK: - Save Method
     -------------------
     */
    
    // This method is invoked when the user taps the Save button
    @objc func saveButtonTapped(_ sender: AnyObject) {
        
        if (inputValid()) {
            // Ask the delegate object to invoke the protocol method
            delegate!.addEventViewController(self, didFinishWithSave:true)
        }
    }
    
    /*
     -----------------------------
     MARK: - Validate input
     -----------------------------
     */
    func inputValid() -> Bool{
        if titleTextField.text!.isEmpty {
            showAlertMessage(messageHeader: "Missing Event Title!", messageBody: "Please enter a name for the event")
        } else if prioritySegmentedControl.selectedSegmentIndex < 0 {
            showAlertMessage(messageHeader: "No Priority Selected!", messageBody: "Please select the priority for the event")
        } else {
            for check in days {
                if check {
                    return true;
                }
            }
            showAlertMessage(messageHeader: "Missing Selected Days!", messageBody: "Please select the days for the event")
        }
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
    
    
    /*
     --------------------------------------------
     MARK: - UIPickerViewDelegate Protocol Method
     --------------------------------------------
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        selectedCategory = EventCategory.allValues[row]
        return selectedCategory?.rawValue
    }
    
    /*
     -----------------------------------------------
     MARK: - UIPickerViewDataSource Protocol Methods
     -----------------------------------------------
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return EventCategory.allValues.count;
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
}
