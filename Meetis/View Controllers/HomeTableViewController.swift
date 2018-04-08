//
//  HomeTableViewController.swift
//  Meetis
//
//  Created by CS3714 on 4/8/18.
//  Copyright © 2018 Abey Yoseph. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    // Instance variable holding the object reference of the UITableView UI object created in the Storyboard
    @IBOutlet var eventsTableView: UITableView!
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let tableViewRowHeight: CGFloat = 70.0
    
       
    //---------- Create and Initialize the Arrays -----------------------
    
    var eventTitles = [String]()
    
    // companyDataToPass is the data object to pass to the downstream view controller
    var eventDataToPass = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Set up the Edit button on the left of the navigation bar to enable editing of the table view rows
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Set up the Add button on the right of the navigation bar to call the addCompany method when tapped
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                         action: #selector(HomeTableViewController.addCompany(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        /*
         allKeys returns a new array containing the dictionary’s keys as of type AnyObject.
         Therefore, typecast the AnyObject type keys to be of type String.
         The keys in the array are *unordered*; therefore, they need to be sorted.
         */
        eventTitles = applicationDelegate.dict_MyEvents_EventData.allKeys as! [String]
        
        // Sort the stock symbols within itself in alphabetical order
        eventTitles.sort { $0 < $1 }
    }

    /*
     ---------------------------
     MARK: - Add New Company
     ---------------------------
     */
    
    // The addCity method is invoked when the user taps the Add button created in viewDidLoad() above.
    @objc func addCompany(_ sender: AnyObject) {
        
        // Perform the segue
        performSegue(withIdentifier: "Add Event", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    

}
