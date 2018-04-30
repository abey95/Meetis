//
//  HomeTableViewController.swift
//  Meetis
//
//  Created by CS3714 on 4/8/18.
//  Copyright © 2018 Abey Yoseph. All rights reserved.
//

import UIKit

@objc

// Define HomeViewControllerDelegate as a protocol with two optional methods
protocol HomeTableViewControllerDelegate {
    
    @objc optional func toggleMenuView()
    @objc optional func collapseMenuView()
}

class HomeTableViewController: UITableViewController {

    // Instance variable holding the object reference of the UITableView UI object created in the Storyboard
    @IBOutlet var eventsTableView: UITableView!
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let tableViewRowHeightClosed: CGFloat = 70.0
    let tableViewRowHeightOpen: CGFloat = 130.0
    
       
    //---------- Create and Initialize the Arrays -----------------------
    var categories = [String]()
    var events = [Event]()
    var lastCell:StackTableViewCell = StackTableViewCell()
    var t_count:Int = 0
    var button_tag:Int = -1

    let background_color = UIColor.init(red: 50/255, green: 54/255, blue: 64/255, alpha: 1)
    
    // companyDataToPass is the data object to pass to the downstream view controller
    var eventToPass: Event?
    
    /*
     This instance variable designates the object that adopts the HomeViewControllerDelegate protocol.
     ContainerViewController adopts this protocol and implements its two optional methods (see its code).
     */
    var delegate: HomeTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = background_color
        
        // Set up the Edit button on the left of the navigation bar to enable editing of the table view rows
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Set up the Add button on the right of the navigation bar to call the addCompany method when tapped
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                         action: #selector(HomeTableViewController.addEvent(_:)))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        self.setToolbarItems([flexSpace], animated: true)
        self.navigationItem.rightBarButtonItem = addButton
        
        events = applicationDelegate.chronEvents
        
        eventsTableView.register(UINib(nibName: "StackTableViewCell", bundle: nil), forCellReuseIdentifier: "StackCell")
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        
        eventsTableView.allowsSelection = false
        eventsTableView.backgroundColor = background_color
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
    // deleting a row only makes the event inactive - the notes are still available in the menu
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
//        if editingStyle == .delete {   // Handle the Delete action
//
//            // Obtain the name of the event to be deleted
//            let eventName = eventTitles[(indexPath as NSIndexPath).section]
//
//            //create new dicitionary of all movies and updated preferences minus the movie to remove
//            let newDict = NSMutableDictionary()
//
//
//            if newDict.count == 0 {
//                // If no genre remains in the array after deletion, then we need to also delete the country
//                applicationDelegate.dict_Genres_MovieData.removeObject(forKey: genreOfMovieToDelete)
//
//                // Since the dictionary has been changed, obtain the genre names again
//                genres = applicationDelegate.dict_Genres_MovieData.allKeys as! [String]
//
//                // Sort the genres names within itself in alphabetical order
//                genres.sort { $0 < $1 }
//            }
//            else {
//                // At least one more movie remains in the array; therefore, the genre stays.
//
//                // Update the new list of movies for the genre in the NSMutableDictionary
//                applicationDelegate.dict_Genres_MovieData.setValue(newDict, forKey: genreOfMovieToDelete)
//            }
//
//            // Reload the rows and sections of the Table View moviesTableView
//            moviesTableView.reloadData()
//        }
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
        return events.count
    }

    //-------------------------------------
    // Prepare and Return a Table View Cell
    //-------------------------------------
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowNumber = (indexPath as NSIndexPath).row
        
        // Obtain the object reference of a reusable table view cell object instantiated under the identifier
        // Company Cell, which was specified in the storyboard
        let cell: StackTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StackCell") as! StackTableViewCell
        
        // Typecast the AnyObject to Swift array of String objects
        let currentEvent = events[rowNumber]
        
        if !cell.cellExists {
            cell.index = rowNumber
            cell.cellExists = true
            cell.eventTitleLabel.text = currentEvent.title
            cell.eventTimeLabel.text = currentEvent.getDateString()
            
            cell.openButton.tag = t_count
            
            cell.openButton.addTarget(self, action: #selector(cellOpened(sender:)), for: .touchUpInside)
            
           switch currentEvent.category {
            case .school:
                cell.imageView!.image = UIImage(named: "school.png")
                break
            case .family:
                cell.imageView!.image = UIImage(named: "family.png")
            case .personal:
                cell.imageView!.image = UIImage(named: "personal.png")
            case .travel:
                cell.imageView!.image = UIImage(named: "travel.png")
            default:
                cell.imageView!.image = UIImage(named: "work.png")
                
            }
            t_count = t_count + 1
            cell.cellExists = true
            cell.delegate = self
        }

        UIView.animate(withDuration: 0) {
            cell.contentView.layoutIfNeeded()
        }
        return cell
    }
    
    @objc func cellOpened(sender:UIButton) {
        self.tableView.beginUpdates()
        
        let previousCellTag = button_tag
        
        if lastCell.cellExists {
            self.lastCell.animate(duration: 0.2, c: {
                self.view.layoutIfNeeded()
            })
            
            if sender.tag == button_tag {
                button_tag = -1
                lastCell = StackTableViewCell()
            }
        }
        
        if sender.tag != previousCellTag {
            button_tag = sender.tag
            
            lastCell = tableView.cellForRow(at: IndexPath(row: button_tag, section: 0)) as! StackTableViewCell
            self.lastCell.animate(duration: 0.2, c: {
                self.view.layoutIfNeeded()
            })
            
        }
        self.tableView.endUpdates()
    }
    
    /*
     -----------------------------------
     MARK: - Table View Delegate Methods
     -----------------------------------
     */
    
    // Asks the table view delegate to return the height of a given row.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == button_tag {
            return tableViewRowHeightOpen
        } else {
            return tableViewRowHeightClosed
        }
    }
    
    
    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "New Note" {
            // Obtain the object reference of the destination view controller
            let newNoteViewController: NewNoteViewController = segue.destination as! NewNoteViewController
        } else if segue.identifier == "Pic Tapped" {
            // Obtain the object reference of the destination view controller
            let newNoteViewController: NewNoteViewController = segue.destination as! NewNoteViewController
        } else if segue.identifier == "Import Tapped" {
            let newNoteViewController: NewNoteViewController = segue.destination as! NewNoteViewController
        } else if segue.identifier == "Add Event" {
            let addEventViewController: AddEventViewController = segue.destination as! AddEventViewController
            addEventViewController.delegate = self
        } else if segue.identifier == "Event Data" {
            let eventDataViewController: EventDataViewController = segue.destination as! EventDataViewController
            eventDataViewController.eventDataPassed = eventToPass
        }
    }   
}

extension HomeTableViewController: StackCellDelegate {
    
    //go to blank canvas
    func didTapPen(title: String) {
        performSegue(withIdentifier: "New Note", sender: self)
    }
    
    // go to camera
    func didTapPic(title: String) {
        performSegue(withIdentifier: "Pic Tapped", sender: self)
    }
    
    // go to import picture view
    func didTapImport(title: String) {
        performSegue(withIdentifier: "Import Tapped", sender: self)
    }
    
    //update event to be next date and update tablview
    func didTapIgnore(title: String) {
        
        eventsTableView.reloadData();
    }
    //update event to be next date and update tablview
    func didTapDetail(title: String, cellNum: Int) {
        
        eventToPass = events[cellNum]
        
        performSegue(withIdentifier: "Event Data", sender: self)
    }
    
}

extension HomeTableViewController: AddEventViewControllerProtocol {
    func addEventViewController(_ controller: AddEventViewController, didFinishWithSave save: Bool) {
        //get fields from add event view controller and create a new event object
        if save {
            let priority: String?
            switch controller.prioritySegmentedControl.selectedSegmentIndex {
            case 0:
                priority = "high"
            case 1:
                priority = "medium"
            default:
                priority = "low"
            }
            
            
            let event = Event(title: controller.titleTextField.text!, days: controller.days, time: controller.timeTextField.text!, priority: priority!, category: controller.selectedCategory!, active: true  )
            
            
            //add the new event to the dictionary and refresh the tableview and app delegate arrays
            applicationDelegate.dict_Events.setValue(event.toDict(), forKey: event.title!)
            
            applicationDelegate.loadAllEvents()
            events = applicationDelegate.chronEvents
            events.sort(by: {$0.nextDate! < $1.nextDate!})
            eventsTableView.reloadData()
        }
        
        
        self.navigationController!.popViewController(animated: true)
    }
    
    
}
