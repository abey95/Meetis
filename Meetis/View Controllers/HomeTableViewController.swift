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
    let tableViewRowHeightOpen: CGFloat = 135.0
    
       
    //---------- Create and Initialize the Arrays -----------------------
    var categories = [String]()
    var events = [Event]()
    var lastCell:StackTableViewCell = StackTableViewCell()
    var t_count:Int = 0
    var last_button_tag:Int = -1

    let background_color = UIColor.init(red: 50/255, green: 54/255, blue: 64/255, alpha: 1)
    
    // eventToPass is the data object to pass to the downstream Event detail + New Note
    var eventToPass: Event?
    // filenameToPass is the data object to pass to the downstream Note Data
    var filenameToPass: String?
    
    //current open cell
    var cell: StackTableViewCell?
    
    // isCurrentlyVisible is needed because we only want pan gesture to be recognized when
    // on menu or home view controllers
    var isCurrentlyVisible = false
    
    /*
     This instance variable designates the object that adopts the HomeViewControllerDelegate protocol.
     ContainerViewController adopts this protocol and implements its two optional methods (see its code).
     */
    var delegate: HomeTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = background_color
        
        
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
        eventsTableView.separatorStyle = .none
        eventsTableView.allowsSelection = false
        eventsTableView.backgroundColor = background_color
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //t_count = 0
        applicationDelegate.loadAllEvents()
        isCurrentlyVisible = true
        events = applicationDelegate.chronEvents
        eventsTableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isCurrentlyVisible = false
        super.viewDidDisappear(animated)
    }
    
    
    /*
     ----------------------
     MARK: - Buttons Tapped
     ----------------------
     */
    @IBAction func menuButtonTapped(_ sender: UIBarButtonItem) {
        
        /*
         Tell the delegate (ContainerViewController) to execute its implementation of the
         HomeViewControllerDelegate protocol method toggleMenuView()
         */
        delegate?.toggleMenuView!()
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
        
        cell.index = rowNumber
        cell.cellExists = true
        cell.eventTitleLabel.text = currentEvent.title
        cell.eventTimeLabel.text = currentEvent.getDateString()
        cell.openButton.tag = rowNumber
        cell.openButton.addTarget(self, action: #selector(cellOpened(sender:)), for: .touchUpInside)
        
       switch currentEvent.category {
        case .school:
            cell.imageView!.image = UIImage(named: "school.png")
            break
        case .family:
            cell.imageView!.image = UIImage(named: "family.png")
        case .personal:
            cell.imageView!.image = UIImage(named: "person.png")
        case .travel:
            cell.imageView!.image = UIImage(named: "travel.png")
        default:
            cell.imageView!.image = UIImage(named: "work.png")
        
        }
        
        switch currentEvent.priority {
        case "high" :
            //red
            cell.openView.backgroundColor = UIColor(red: 255.0/255.0, green: 151.0/255.0, blue: 112.0/255.0, alpha: 1.0)
            break
        case "medium":
            // yellow
            cell.openView.backgroundColor = UIColor(red: 233.0/255.0, green: 255.0/255.0, blue: 112.0/255.0, alpha: 1.0)
            break
        default:
            //green
            cell.openView.backgroundColor = UIColor(red: 55.0/255.0, green: 214.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        }
        
        cell.cellExists = true
        cell.delegate = self

        UIView.animate(withDuration: 0) {
            cell.contentView.layoutIfNeeded()
        }
        return cell
    }
    
    
    @objc func cellOpened(sender:UIButton) {
        self.tableView.beginUpdates()
        
        let previousCellTag = last_button_tag
        
        if lastCell.cellExists {
            self.lastCell.animate(duration: 0.2, c: {
                self.view.layoutIfNeeded()
            })
        }
        
        if sender.tag == last_button_tag {
            last_button_tag = -1
            lastCell = StackTableViewCell()
        }
        
        else if sender.tag != previousCellTag {
            last_button_tag = sender.tag
            
            lastCell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! StackTableViewCell
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
        
        if indexPath.row == last_button_tag {
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
            newNoteViewController.isMicActive = cell!.micActive
            newNoteViewController.startingState = cell!.currState
            newNoteViewController.event = eventToPass!
            newNoteViewController.filename = eventToPass!.makeNewFilename()
            
        } else if segue.identifier == "Add Event" {
            let addEventViewController: AddEventViewController = segue.destination as! AddEventViewController
            addEventViewController.delegate = self
        } else if segue.identifier == "Event Data" {
            let eventDataViewController: EventDataViewController = segue.destination as! EventDataViewController
            eventDataViewController.eventDataPassed = eventToPass
            eventDataViewController.delegate = self
        } else if segue.identifier == "View Note Data" {
            let noteDataViewController: NoteDataViewController = segue.destination as! NoteDataViewController
            noteDataViewController.passedNoteFilename = filenameToPass
            noteDataViewController.passedEvent = eventToPass!
        }
    }
}

extension HomeTableViewController: StackCellDelegate {
    
    // go to new note view controller
    func didTapNote(sender: StackTableViewCell) {
        cell = sender
        eventToPass = events[sender.index]
        performSegue(withIdentifier: "New Note", sender: self)
    }
    
    //update event to be next date and update tablview
    func didTapIgnore(sender: StackTableViewCell) {
        events[last_button_tag].updateNextDate()
        events.sort { $0.nextDate < $1.nextDate}
        eventsTableView.reloadData();
    }
    //update event to be next date and update tablview
    func didTapDetail(sender: StackTableViewCell) {
        
        eventToPass = events[sender.index]
        
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
                priority = "low"
            case 1:
                priority = "medium"
            default:
                priority = "high"
            }
            
            
            let event = Event(title: controller.titleTextField.text!, days: controller.days, time: controller.timeTextField.text!, priority: priority!, category: controller.selectedCategory!, active: true  )
            
            
            //add the new event to the dictionary and refresh the tableview and app delegate arrays
            applicationDelegate.dict_Events.setValue(event.toDict(), forKey: event.title!)
            
            applicationDelegate.loadAllEvents()
            events = applicationDelegate.chronEvents
            events.sort(by: {$0.nextDate! < $1.nextDate!})
            eventsTableView.reloadData()
            self.navigationController!.popViewController(animated: true)
        }
        
    }
}

// Menu view's delegate protocol for viewing a note
extension HomeTableViewController: MenuViewControllerDelegate {
    
    
    func noteSelected(_ filename: String, _ event: Event) {
        /*
         Ask the navigation controller to pop all of the view controllers on the stack
         except the root view controller and update the display.
         */
        _ = self.navigationController?.popToRootViewController(animated: false)
        
        /*
         Tell the delegate (ContainerViewController) to execute its implementation of the
         HomeViewControllerDelegate protocol method collapseMenuView()
         */
        delegate?.collapseMenuView!()
        filenameToPass = filename
        eventToPass = event
        performSegue(withIdentifier: "View Note Data" , sender: self)
    }
}

extension HomeTableViewController: EventDataViewControllerProtocol {
    func eventDataViewController(_ controller: EventDataViewController, didFinishWithSave save: Bool) {
        if save {
            
            //add the new event to the dictionary and refresh the tableview and app delegate arrays
            applicationDelegate.dict_Events.setValue(controller.eventDataPassed!.toDict(), forKey: controller.eventDataPassed!.title!)
            
            applicationDelegate.loadAllEvents()
            events = applicationDelegate.chronEvents
            events.sort(by: {$0.nextDate! < $1.nextDate!})
            eventsTableView.reloadData()
            self.navigationController!.popViewController(animated: true)
        }
    }
}
