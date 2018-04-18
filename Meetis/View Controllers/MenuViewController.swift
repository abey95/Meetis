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
    func eventSelected(_ url: URL)
}


class MenuViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var delegate: MenuViewControllerDelegate?

    var events = [[Event]]()
    var eventNames     = [String]()
    var eventCategories     = EventCategory.allValues
    
    
    // These two instance variables are used for Search Bar functionality
    var searchResults = [String]()
    var searchResultsController = UISearchController()
    
    @IBOutlet var eventsTableView: UITableView!

    var tableViewList = [String]()

    // Index Paths of the selected table view rows
    var selectedIndexPath: IndexPath = IndexPath()
    var selectedIndexPathPrevious: IndexPath = IndexPath()
    
    // Flags created and initialized
    var eventNameSelected: Bool = false
    var selectedRowNumber: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        events = applicationDelegate.events
        eventNames = applicationDelegate.dict_Events.allKeys as! [String]
       
        // Initialize the current table view rows to be the list of the university names
        tableViewList = eventNames

        createSearchResultsController()
    }

    // Prepare the view before it appears to the user
    override func viewWillAppear(_ animated: Bool) {
        
        if eventNameSelected {
            
            // Reload the table view data so that the selected sport name can be
            // colored in blue to indicate that it is the selected row.
            eventsTableView.reloadData()
        }
        
        super.viewWillAppear(animated)
    }
    
    // Scroll the selected sport name row towards the middle of the table view
    override func viewDidAppear(_ animated: Bool) {
        
        if eventNameSelected {
            
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
     ---------------------------------------
     MARK: - Search Bar Cancel Button Tapped
     ---------------------------------------
     */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        // No sport should be shown as selected when the search bar Cancel button is tapped.
        eventNameSelected = false
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
        
        if eventNames.contains(rowName) {    // Rows decomposition level = 0
            
            // Row name is an event name
            cell.indentationLevel = 0;
            
            cell.imageView!.image = UIImage(named: rowName)
            
        } else if rowName == "Men's Sports" {           // Rows decomposition level = 1
            
            cell.indentationLevel = 1
            cell.imageView!.image = UIImage(named:"MenSportIcon")
            
        } else {         // Rows decomposition level = 2
            
            // Row name is a sport name
            cell.indentationLevel = 2
            cell.imageView!.image = UIImage(named:"WomenSportIcon")
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
        
        if eventNameSelected && (selectedRowNumber == (indexPath as NSIndexPath).row) {
            
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
        
        // If the cell label is a sport name
        if eventNames.contains((cell.textLabel!.text!)) {
            
            // Then, show the Right Arrow image as Disclosure Indicator
            cell.accessoryView = UIImageView(image: UIImage(named: "RightArrow"))
            
        } else {
            
            // Otherwise, show the Down Arrow image to indicate that the row has child rows
            cell.accessoryView = UIImageView(image: UIImage(named: "DownArrow"))
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
