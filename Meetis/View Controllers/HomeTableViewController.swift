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
    var categories = [String]()
    var eventTitles = [String]()
    
    // companyDataToPass is the data object to pass to the downstream view controller
    var eventDataToPass = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the Edit button on the left of the navigation bar to enable editing of the table view rows
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Set up the Add button on the right of the navigation bar to call the addCompany method when tapped
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                         action: #selector(HomeTableViewController.addEvent(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        
        
        eventsTableView.register(UINib(nibName: "StackCell", bundle: nil), forCellReuseIdentifier: "StackCell")
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
    }
    
    private func getEvents() {
        /*
         allKeys returns a new array containing the dictionary’s keys as of type AnyObject.
         Therefore, typecast the AnyObject type keys to be of type String.
         The keys in the array are *unordered*; therefore, they need to be sorted.
         */
        categories = applicationDelegate.dict_Events.allKeys as! [String]
        
        for category in categories {
            // Obtain the events of a specific category
            let events: AnyObject? = applicationDelegate.dict_Events.value(forKey: category) as AnyObject
            
            // Typecast the AnyObject to NSMutableDictionary
            let eventsOfGivenCategory = events! as! NSMutableDictionary
            
            //add all events of a category to our list of events
            let curEvents = eventsOfGivenCategory.allKeys as! [String]
            
            //get event and check if it still in use
            for eventName in curEvents {
                //get event from events dictionary
                let event: AnyObject? = eventsOfGivenCategory.value(forKey: eventName) as AnyObject
                
                // Typecast the AnyObject to NSMutableDictionary
                let eventData = event! as! NSMutableDictionary
            }
           
        }
        
        // Sort the stock symbols within itself in alphabetical order
        eventTitles.sort { $0 < $1 }
    }
    
    //-------------------------------
    // Allow Editing of Rows (Movies)
    //-------------------------------
    
    // We allow each row (movie) of the table view to be editable, i.e., deletable or movable
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    //---------------------
    // Delete Button Tapped
    //---------------------
    
    // This is the method invoked when the user taps the Delete button in the Edit mode
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {   // Handle the Delete action
            
            // Obtain the name of the event to be deleted
            let eventName = eventTitles[(indexPath as NSIndexPath).section]
            
            //create new dicitionary of all movies and updated preferences minus the movie to remove
            let newDict = NSMutableDictionary()

            
            if newDict.count == 0 {
                // If no genre remains in the array after deletion, then we need to also delete the country
                applicationDelegate.dict_Genres_MovieData.removeObject(forKey: genreOfMovieToDelete)
                
                // Since the dictionary has been changed, obtain the genre names again
                genres = applicationDelegate.dict_Genres_MovieData.allKeys as! [String]
                
                // Sort the genres names within itself in alphabetical order
                genres.sort { $0 < $1 }
            }
            else {
                // At least one more movie remains in the array; therefore, the genre stays.
                
                // Update the new list of movies for the genre in the NSMutableDictionary
                applicationDelegate.dict_Genres_MovieData.setValue(newDict, forKey: genreOfMovieToDelete)
            }
            
            // Reload the rows and sections of the Table View moviesTableView
            moviesTableView.reloadData()
        }
    }

    /*
     ---------------------------
     MARK: - Add New Event
     ---------------------------
     */
    
    // The addEvent method is invoked when the user taps the Add button created in viewDidLoad() above.
    @objc func addEvent(_ sender: AnyObject) {
        
        // Perform the segue
        performSegue(withIdentifier: "Add Event", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventTitles.count
    }

    

}
