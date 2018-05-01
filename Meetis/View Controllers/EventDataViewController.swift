//
//  EventDataViewController.swift
//  Meetis
//
//  Created by Kyle Thompson on 4/11/18.
//  Copyright © 2018 Abey Yoseph. All rights reserved.
//

import UIKit

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
    
    
    @IBOutlet var editSaveButton: UIBarButtonItem!
    
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    var eventDataPassed: Event?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sundayButton.isEnabled = false
        mondayButton.isEnabled = false
        tuesdayButton.isEnabled = false
        wednesdayButton.isEnabled = false
        thursdayButton.isEnabled = false
        fridayButton.isEnabled = false
        saturdayButton.isEnabled = false

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
            imageView!.image = UIImage(named: "personal.png")
        case .travel:
            imageView!.image = UIImage(named: "travel.png")
        default:
            imageView!.image = UIImage(named: "work.png")
            
        }
        
        categoryLabel.text = eventDataPassed!.category.rawValue
        timeTextField.text = eventDataPassed?.time
        
        if eventDataPassed?.priority == "Low" {
            prioritySegmentedControl.selectedSegmentIndex = 0
        }
        else if eventDataPassed?.priority == "Medium" {
            prioritySegmentedControl.selectedSegmentIndex = 1
        }
        else {
            prioritySegmentedControl.selectedSegmentIndex = 2
        }
        
        if (eventDataPassed?.days[0])! {
            sundayButton.setBackgroundImage(UIImage(named: "blue_circle.png"), for: UIControlState.normal)
        }
        if (eventDataPassed?.days[1])! {
            mondayButton.setBackgroundImage(UIImage(named: "blue_circle.png"), for: UIControlState.normal)
        }
        if (eventDataPassed?.days[2])! {
            tuesdayButton.setBackgroundImage(UIImage(named: "blue_circle.png"), for: UIControlState.selected)
        }
        if (eventDataPassed?.days[3])! {
            wednesdayButton.setBackgroundImage(UIImage(named: "blue_circle.png"), for: UIControlState.selected)
        }
        if (eventDataPassed?.days[4])! {
            thursdayButton.setBackgroundImage(UIImage(named: "blue_circle.png"), for: UIControlState.selected)
        }
        if (eventDataPassed?.days[5])! {
            fridayButton.setBackgroundImage(UIImage(named: "blue_circle.png"), for: UIControlState.selected)
        }
        if (eventDataPassed?.days[6])! {
            saturdayButton.setBackgroundImage(UIImage(named: "blue_circle.png"), for: UIControlState.selected)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var isEdit = true;
    
    @IBAction func editSaveTapped(_ sender: UIBarButtonItem) {
        
        if isEdit {
            
            editSaveButton.title = "Save"

            sundayButton.isEnabled = true
            mondayButton.isEnabled = true
            tuesdayButton.isEnabled = true
            wednesdayButton.isEnabled = true
            thursdayButton.isEnabled = true
            fridayButton.isEnabled = true
            saturdayButton.isEnabled = true
            
        }
        else {
            eventDataPassed?.time = timeTextField.text
            
            if prioritySegmentedControl.selectedSegmentIndex == 0 {
                eventDataPassed?.priority = "Low"
            }
            else if prioritySegmentedControl.selectedSegmentIndex == 1 {
                eventDataPassed?.priority = "Med"
            }
            else {
                eventDataPassed?.priority = "High"
                
            }
            
            applicationDelegate.dict_Events.setValue(eventDataPassed?.toDict(), forKey: (eventDataPassed?.title)!)

            editSaveButton.title = "Edit"
            
            sundayButton.isEnabled = false
            mondayButton.isEnabled = false
            tuesdayButton.isEnabled = false
            wednesdayButton.isEnabled = false
            thursdayButton.isEnabled = false
            fridayButton.isEnabled = false
            saturdayButton.isEnabled = false
            
        }
        isEdit = !isEdit
    }
    
    
    // The weekButtonTapped method is invoked when the user taps the Add button created in viewDidLoad() above.
    @IBAction func weekButtonTapped(_ sender: UIButton) {
        
        // Perform the segue
        eventDataPassed?.days[sender.tag] = !(eventDataPassed?.days[sender.tag])!
        
        if eventDataPassed?.days[sender.tag] == true {
            sender.setBackgroundImage(UIImage(named: "blue_circle.png"), for: UIControlState.normal)
        }
        else {
            sender.setBackgroundImage(nil, for: UIControlState.normal)
        }
    }
}

