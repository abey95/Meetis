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
}

