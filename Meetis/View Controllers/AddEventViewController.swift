//
//  AddEventViewController.swift
//  Meetis
//
//  Created by CS3714 on 4/11/18.
//  Copyright © 2018 Abey Yoseph. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var pickerView: UIPickerView!
    
    
    var days = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        days = [Bool](repeating: false, count: 7)
        // Do any additional setup after loading the view.
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
    
}
