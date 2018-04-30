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
    
    
    var eventDataPassed: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        if eventDataPassed?.priority == "low" {
            prioritySegmentedControl.selectedSegmentIndex = 0
        }
        else if eventDataPassed?.priority == "medium" {
            prioritySegmentedControl.selectedSegmentIndex = 1
        }
        else {
            prioritySegmentedControl.selectedSegmentIndex = 2
        }
        
        if (eventDataPassed?.days[0])! {
            sundayButton.backgroundColor = UIColor.blue
            sundayButton.titleLabel?.textColor = UIColor.white
        }
        if (eventDataPassed?.days[1])! {
            mondayButton.backgroundColor = UIColor.blue
            mondayButton.titleLabel?.textColor = UIColor.white
        }
        if (eventDataPassed?.days[2])! {
            tuesdayButton.backgroundColor = UIColor.blue
            tuesdayButton.titleLabel?.textColor = UIColor.white
        }
        if (eventDataPassed?.days[3])! {
            wednesdayButton.backgroundColor = UIColor.blue
            wednesdayButton.titleLabel?.textColor = UIColor.white
        }
        if (eventDataPassed?.days[4])! {
            thursdayButton.backgroundColor = UIColor.blue
            thursdayButton.titleLabel?.textColor = UIColor.white
        }
        if (eventDataPassed?.days[5])! {
            fridayButton.backgroundColor = UIColor.blue
            fridayButton.titleLabel?.textColor = UIColor.white
        }
        if (eventDataPassed?.days[6])! {
            saturdayButton.backgroundColor = UIColor.blue
            saturdayButton.titleLabel?.textColor = UIColor.white
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    


}
