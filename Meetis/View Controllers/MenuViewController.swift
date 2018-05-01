//
//  MenuViewController.swift
//  Meetis
//
//  Created by CS3714 on 4/8/18.
//  Copyright © 2018 Abey Yoseph. All rights reserved.
//

import UIKit

@objc

// Define MenuViewControllerDelegate as a protocol with one required method
protocol MenuViewControllerDelegate {
    func noteSelected(_ filename: String)
}


class MenuViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var delegate: MenuViewControllerDelegate?

    // 2D array where top index is category and bottom is the event
    var events = [[Event]]()
    var eventNames     = [String]()
    var eventCategories     = EventCategory.rawValues
    var allNoteNames = [String]()
    
    
    
    // These two instance variables are used for Search Bar functionality
    var searchResults = [String]()
    var searchResultsController = UISearchController()
    
    @IBOutlet var eventsTableView: UITableView!

    var tableViewList = [String]()

    // Index Paths of the selected table view rows
    var selectedIndexPath: IndexPath = IndexPath()
    var selectedIndexPathPrevious: IndexPath = IndexPath()
    
    // Flags created and initialized
    var noteSelected: Bool = false
    var selectedRowNumber: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        applicationDelegate.loadAllEvents()
        
        events = applicationDelegate.events
        eventNames = applicationDelegate.dict_Events.allKeys as! [String]
       
        // Initialize the current table view rows to be the list of event Categories
        tableViewList = eventCategories
        
        
        // get all note names by iterating through events
        for i in 0..<eventCategories.count {
            for j in 0..<events[i].count {
                let curEvent = events[i][j]
                allNoteNames.append(contentsOf: curEvent.notes)
            }
        }
        

        createSearchResultsController()
    }

    // Prepare the view before it appears to the user
    override func viewWillAppear(_ animated: Bool) {
        
        if noteSelected {
            
            // Reload the table view data so that the selected sport name can be
            // colored in blue to indicate that it is the selected row.
            eventsTableView.reloadData()
        }
        
        super.viewWillAppear(animated)
    }
    
    // Scroll the selected sport name row towards the middle of the table view
    override func viewDidAppear(_ animated: Bool) {
        
        if noteSelected {
            
            // Scroll the selected row towards the middle of the table view
            eventsTableView.scrollToRow(at: selectedIndexPath,
                                           at: UITableViewScrollPosition.middle, animated: true)
        }
        
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
     ---------------------------------------------
     MARK: - Creation of Search Results Controller
     ---------------------------------------------
     */
    func createSearchResultsController() {
        /*
         Instantiate a UISearchController object and store its object reference into local variable: controller.
         Setting the parameter searchResultsController to nil implies that the search results will be displayed
         in the same view used for searching (under the same UITableViewController object).
         */
        let controller = UISearchController(searchResultsController: nil)
        
        /*
         We use the same table view controller (self) to also display the search results. Therefore,
         set self to be the object responsible for listing and updating the search results.
         Note that we made self to conform to UISearchResultsUpdating protocol.
         */
        controller.searchResultsUpdater = self
        
        /*
         The property dimsBackgroundDuringPresentation determines if the underlying content is dimmed during
         presentation. We set this property to false since we are presenting the search results in the same
         view that is used for searching. The "false" option displays the search results without dimming.
         */
        controller.dimsBackgroundDuringPresentation = false
        
        controller.searchBar.delegate = self
        controller.searchBar.placeholder = "Search Event Names"
        
        // Resize the search bar object based on screen size and device orientation.
        controller.searchBar.sizeToFit()
        
        /***************************************************************************
         No need to create the search bar in the Interface Builder (storyboard file).
         The statement below creates it at runtime.
         ***************************************************************************/
        
        // Set the tableHeaderView's accessory view displayed above the table view to display the search bar.
        self.eventsTableView.tableHeaderView = controller.searchBar
        
        /*
         Set self (Table View Controller) define the presentation context so that the Search Bar subview
         does not show up on top of the view (scene) displayed by a downstream view controller.
         */
        self.definesPresentationContext = true
        
        /*
         Set the object reference (controller) of the newly created and dressed up UISearchController
         object to be the value of the instance variable searchResultsController.
         */
        searchResultsController = controller
    }
    
    /*
     -----------------------------------------------
     MARK: - UISearchResultsUpdating Protocol Method
     -----------------------------------------------
     
     This UISearchResultsUpdating protocol required method is automatically called whenever the search
     bar becomes the first responder or changes are made to the text or scope of the search bar.
     You must perform all required filtering and updating operations inside this method.
     */
    func updateSearchResults(for searchController: UISearchController)
    {
        // Empty the instance variable searchResults array without keeping its capacity
        searchResults.removeAll(keepingCapacity: false)
        
        // Set searchPredicate to search for any character(s) the user enters into the search bar.
        // [c] indicates that the search is case insensitive.
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        
        // Obtain the event names that contain the character(s) the user types into the Search Bar.
        let listOfEventNamesFound = (eventNames as NSArray).filtered(using: searchPredicate)
        
        // Obtain the search results as an array of type String
        searchResults = listOfEventNamesFound as! [String]
        
        // Reload the table view to display the search results
        self.eventsTableView.reloadData()
    }
    

    /*
     ----------------------------------------------
     MARK: - UITableViewDataSource Protocol Methods
     ----------------------------------------------
     */
    
    // Asks the data source to return the number of sections in the table view
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    // Asks the data source to return the number of rows in a section, the number of which is given
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResultsController.isActive ? searchResults.count : tableViewList.count
    }
    
    //-------------------------------------------------------------
    //         Prepare and Return a Table View Cell
    //-------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowNumber: Int = (indexPath as NSIndexPath).row    // Identify the row number
        
        // Obtain the object reference of a reusable table view cell object instantiated under the identifier
        // TableViewCellReuseID, which was specified in the storyboard
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell") as UITableViewCell!
        
        // Obtain the name of the row from the table view list
        let rowName: String = searchResultsController.isActive ? searchResults[rowNumber] : tableViewList[rowNumber]
        
        // Set the label text of the cell to be the row name
        cell.textLabel!.text = rowName
        
        // Cell indentation width of 10.0 points is the default value
        cell.indentationWidth = 10.0
        
        if eventCategories.contains(rowName) {    // Rows decomposition level = 0
            
            // Row name is an event name
            cell.indentationLevel = 0;
            //cell.detailTextLabel!.text = "\()"
            //cell.imageView!.image = UIImage(named: rowName)
            
        } else if eventNames.contains(rowName) {           // Rows decomposition level = 1
            
            cell.indentationLevel = 1
//            cell.imageView!.image = UIImage(named:"MenSportIcon")
            
        } else {         // Rows decomposition level = 2
            
            // Row name is a note name
            cell.indentationLevel = 2
//            cell.imageView!.image = UIImage(named:"WomenSportIcon")
        }
        return cell
    }
    
    //---------------------------------------------------------------
    // Prepare the Table View Cell before it is displayed to the user
    //---------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // Set the number of lines to be displayed in each table view cell to 2
        cell.textLabel!.numberOfLines = 2
        
        // Set the text to wrap around on the next line
        cell.textLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        // Set the cell label text to use the System font of size 14 pts
        cell.textLabel!.font = UIFont(name: "System", size: 14.0)
        
        if noteSelected && (selectedRowNumber == (indexPath as NSIndexPath).row) {
            
            // Set the cell label text color to blue to indicate its selection
            cell.textLabel!.textColor = UIColor.blue
            
        } else {
            // Set the cell label text color to black otherwise
            cell.textLabel!.textColor = UIColor.black
        }
        
        switch cell.indentationLevel {
        case 0:
            // Set level 1 (University Name) row background color to Lavendar (#E6E6FA)
            cell.backgroundColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 250.0/255.0, alpha: 1.0)
            
        case 1:
            // Set level 2 (Sport Category Name) row background color to Ivory (#FFFFF0)
            cell.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            
        case 2:
            // Set level 3 (Sport Name) row background color to PeachPuff (#FFDAB9)
            cell.backgroundColor = UIColor(red: 255.0/255.0, green: 218.0/255.0, blue: 185.0/255.0, alpha: 1.0)
            
        default:
            print("Cell indentation level is out of range!")
            break
        }
        
        // If the cell label is a category or event name
        if eventNames.contains((cell.textLabel!.text!)) || eventCategories.contains((cell.textLabel!.text!)){
            // Then, show the Down Arrow image to indicate that the row has child rows
            cell.accessoryView = UIImageView(image: UIImage(named: "DownArrow"))
           
        } else {
            
            // Otherwise, show the Right Arrow image as Disclosure Indicator
            cell.accessoryView = UIImageView(image: UIImage(named: "RightArrow"))
        }
    }
    /*
     --------------------------------------------
     MARK: - UITableViewDelegate Protocol Methods
     --------------------------------------------
     */
    
    // Set the height of the table view row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    //----------------------------------------------------------------------------
    // Perform the necessary actions when the user selects a table view row (cell)
    //----------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Obtain the number of the selected row
        var rowNumber: Int = (indexPath as NSIndexPath).row
        
        // Set the class properties
        selectedIndexPath = indexPath
        selectedRowNumber = rowNumber
        
        // Check whether the table view is from the search display controller
        var selectedArray = searchResultsController.isActive ? searchResults : tableViewList
        
        // Obtain the name of the selected row
        let nameOfSelectedRow: String = selectedArray[rowNumber]
        
        // Identify the table view cell object for the selected row
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        
        // Obtain the indentation level of the selected row
        let indentationLevelOfSelectedCell: Int = selectedCell.indentationLevel
        
        switch indentationLevelOfSelectedCell {
            
            //-------------------------------------------------------------------------
            // Category Name is Selected: Expand the row to show its Events
            //-------------------------------------------------------------------------
            
        case 0:
            
            noteSelected = false
            
            // If the selected gategory name is the last row or
            // If the row below the selected category name is also a category name, implying that it is not expanded
            if rowNumber == (selectedArray.count) - 1 || eventCategories.contains(selectedArray[rowNumber+1]) {
                
                // Expand the selected category name row
                
                let curCategoryIndex = eventCategories.index(of: nameOfSelectedRow)!
                // Obtain an unordered list of events of selected category
                var eventsOfCategory = events[curCategoryIndex]
                
                // Sort the events within itself in alphabetical order based on title
                eventsOfCategory.sort { $0.title < $1.title }
                
                let numberOfEvents = eventsOfCategory.count
                
                // Equivalent to: for var i = 0; i < numberOfSportCategories; i++ {
                // The half-open range operator (a..<b) defines a range that runs from a to b, but does not include b.
                for i in 0..<numberOfEvents {
                    
                    // Insert the sport category names of the selected university
                    if self.searchResultsController.isActive {
                        rowNumber = rowNumber + 1
                        searchResults.insert(eventsOfCategory[i].title, at: rowNumber)
                    } else {
                        rowNumber = rowNumber + 1
                        tableViewList.insert(eventsOfCategory[i].title, at: rowNumber)
                    }
                }
                
            } else {    // Shrink the row: Hide the events under the selected category
                
                // As long as the next row is not a university name, delete the row from the table view list
                // add a cloure to return the right list
                while !self.eventCategories.contains({return ((self.searchResultsController.isActive) ? self.searchResults[rowNumber + 1] : self.tableViewList[rowNumber + 1])}()) {
                    
                    if self.searchResultsController.isActive {
                        searchResults.remove(at: rowNumber + 1)
                    } else {
                        tableViewList.remove(at: rowNumber + 1)
                    }
                    
                    // If the end of the table view list is reached, then break
                    // add clousure to make sure you return the count of the right array
                    if rowNumber + 1 > {return ((self.searchResultsController.isActive) ? self.searchResults.count : self.tableViewList.count)}() - 1 {
                        break
                    }
                }
            }
            
            // Reload the table view's rows since the table view list is changed
            tableView.reloadData()
            
            //------------------------------------------------------------------------
            // Event Name is Selected: Expand the row to show its Notes Names
            // -----------------------------------------------------------------------
            
        case 1:
            
            noteSelected = false
            
            // Special Case: Selected event is the last row of the table view content
            if rowNumber == selectedArray.count - 1 {
                
                // This loop goes from j=(rowNumber - 1) to j=0 with increments of 1
                for j in (0..<rowNumber).reversed() {
                    
                    let previousRowName = (self.searchResultsController.isActive) ? self.searchResults[j] : self.tableViewList[j]
                    
                    if self.eventCategories.contains(previousRowName) {
                        
                        
                        //---------- Events list -------------
                    
                        // Obtain an unordered list of events of selected category
                        let curCategoryIndex = eventCategories.index(of: previousRowName)!
                        var eventsOfCategory = events[curCategoryIndex]
                        
                        //---------- Notes of events -------------
                        
                        // Obtain an unordered list of notes of selected event
                        var curEvent : Event!
                        for i in  0..<eventsOfCategory.count{
                            if eventsOfCategory[i].title == nameOfSelectedRow {
                                curEvent = eventsOfCategory[i]
                            }
                        }
                        var notesOfSelectedEvent = curEvent.notes
                        
                        // Sort the note names of selected category within itself in alphabetical order
                        notesOfSelectedEvent.sort { $0 < $1 }
                        
                        let numberOfNotes = notesOfSelectedEvent.count
                        
                        for k in 0..<numberOfNotes {
                            
                            if self.searchResultsController.isActive {
                                rowNumber = rowNumber + 1
                                searchResults.insert(notesOfSelectedEvent[k], at: rowNumber)
                            } else {
                                rowNumber = rowNumber + 1
                                tableViewList.insert(notesOfSelectedEvent[k], at: rowNumber)
                            }
                        }
                        
                        tableView.reloadData()
                        break
                    }
                }
                /*
                 Note the Closure Expression: {return ((self.searchResultsController.active) ? self.searchResults[rowNumber+1] : self.tableViewList[rowNumber+1])}()
                 Use of "self." is required in a Closure.
                 */
            } else if self.allNoteNames.contains({return ((self.searchResultsController.isActive) ? self.searchResults[rowNumber+1] : self.tableViewList[rowNumber+1])}()) {
                
                // If the row after the selected Event Name is a note name, that means
                // it is already expanded; therefore, shrink the selected event row
                
                // get the event and remove the n next cells where n is the number of notes in the event
                var curEvent : Event!
                for i in  0..<eventCategories.count{
                    for j in 0..<events[i].count {
                        if events[i][j].title == nameOfSelectedRow {
                            curEvent = events[i][j]
                        }
                    }
                }
                
                for _ in 0..<curEvent.notes.count {
                    
                    if self.searchResultsController.isActive {
                        searchResults.remove(at: rowNumber + 1)
                    } else {
                        tableViewList.remove(at: rowNumber + 1)
                    }
                    
                    // If the end of the table view list is reached, then break
                    if rowNumber+1 > {return ((self.searchResultsController.isActive) ? self.searchResults.count : self.tableViewList.count)}() - 1 {
                        break
                    }
                }
                
                tableView.reloadData()
                break
                
            } else {   // Expand the selected event row
                
                // get the event and add each filename of the note to the table
                var curEvent : Event!
                for i in  0..<eventCategories.count{
                    for j in 0..<events[i].count {
                        if events[i][j].title == nameOfSelectedRow {
                            curEvent = events[i][j]
                        }
                    }
                }
                
                var notesOfSelectedEvent = curEvent.notes
                
                // Sort the notes within itself in alphabetical order
                notesOfSelectedEvent.sort { $0 < $1 }
                
                for k in 0..<notesOfSelectedEvent.count {
                    
                    if self.searchResultsController.isActive {
                        rowNumber = rowNumber + 1
                        searchResults.insert(notesOfSelectedEvent[k], at: rowNumber)
                    } else {
                        rowNumber = rowNumber + 1
                        tableViewList.insert(notesOfSelectedEvent[k], at: rowNumber)
                    }
                }
                
                tableView.reloadData()
                break
                
                
            }
            
            //-----------------------------------------------------------------
            // Sport Name is Selected: Show the sport's website in another view
            //-----------------------------------------------------------------
            
        case 2:
            
            noteSelected = true
            
            selectedIndexPathPrevious = selectedIndexPath
            selectedIndexPath = indexPath
            
    
            
            //----------------------- Related to Sliding View ------------------------
            
            /*
             Tell the delegate (HomeViewController) to execute its implementation of the
             MenuViewControllerDelegate protocol method noteSelected(filename: String)
             */
            delegate?.noteSelected(nameOfSelectedRow)
            
            //----------------------- Related to Sliding View ------------------------
            
            // Remove the keyboard for the search bar
            searchResultsController.searchBar.resignFirstResponder()
            
            tableView.reloadData()
            break
    
            
        default:
            print("Table View Cell Indentation Level is Out of Range!")
            break
        }
    }
    
    
    /*
     -----------------------------
     MARK: - Display Error Message
     -----------------------------
     */
    func showErrorMessageFor(_ fileName: String) {
        
        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: "Unable to Access the File: \(fileName)!",
            message: "The file does not reside in the application's main bundle (project folder)!",
            preferredStyle: UIAlertControllerStyle.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller by calling the presentViewController method
        present(alertController, animated: true, completion: nil)
    }
    
}
