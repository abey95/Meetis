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


class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {

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
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        
        //Need to create the arrays of event names and event categories

        //---------------------------------------------------
        //           Initialize the Table View List
        //---------------------------------------------------
        
        // Initialize the current table view rows to be the list of the university names
        
        createSearchResultsController()
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

}
