//
//  NoteDataViewController.swift
//  Meetis
//
//  Created by Kyle Thompson on 4/11/18.
//  Copyright © 2018 Abey Yoseph. All rights reserved.
//

import UIKit

class NoteDataViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet var leftArrowImageView: UIImageView!
    @IBOutlet var rightArrowImageView: UIImageView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //filename data passed downstream
    var passedNoteFilename: String!
    var passedEvent: Event!
    
    // Other properties (instance variables) and their initializations
    let kScrollMenuHeight: CGFloat = 135.0
    var selectedView: Int!
    var previousButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    let backgroundColorToUse = UIColor(red: 0.6, green: 0.8, blue: 1.0, alpha: 1.0)
    let imageWidth = 75
    let imageHeight = 100
    
    var views = [UIImage]()
    //var audio:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        // get notes from dict given filename
        let noteData = applicationDelegate.dict_Notes[passedNoteFilename] as! [AnyObject]
        let notetext = noteData[0] as! String
        let numberOfNotes = noteData[1] as! Int
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        // load in images given file name + number
        for i in 1...numberOfNotes {
            
            let imageFilePathInDocumentDirectory = documentDirectoryPath + "/\(passedNoteFilename!)_\(i).png"
            
            let imageFromFile: UIImage? = UIImage(contentsOfFile: imageFilePathInDocumentDirectory)

            if let obtainedImage = imageFromFile {
                views.append(obtainedImage)
            }
        }
        
        // load in av session
        
        // transcribe
        
        // populate scroll view with notes images
        
        /**********************
         * Set Background Colors
         **********************/
        
        self.view.backgroundColor = UIColor.white
        leftArrowImageView.backgroundColor = backgroundColorToUse
        rightArrowImageView.backgroundColor = backgroundColorToUse
        scrollView.backgroundColor = backgroundColorToUse
        
        /***********************************************************************
         * Instantiate and setup the buttons for the horizontally scrollable menu
         ***********************************************************************/
        
        // Instantiate a mutable array to hold the menu buttons to be created
        var listOfMenuButtons = [UIButton]()
        
        for i in 0 ..< views.count {
            
            // Instantiate a button to be placed within the horizontally scrollable menu
            let scrollMenuButton = UIButton(type: UIButtonType.custom)
            
            // Obtain the auto manufacturer's logo image
            let noteImage = resizeImage(image: views[i], withSize: CGSize(width: imageWidth, height: imageHeight))
            
            // Set the button frame at origin at (x, y) = (0, 0) with
            // button width  = genre image width + 10 points padding for each side
            // button height = kScrollMenuHeight points
            scrollMenuButton.frame = CGRect(x: 0.0, y: 0.0, width: noteImage.size.width + 20.0, height: kScrollMenuHeight)
            
            // Set the button image to be the note image
            scrollMenuButton.setImage(noteImage, for: UIControlState())
            
            // Obtain the titl to be displayed on the button
            let buttonTitle = "Note \(i)"
            
            // The button width and height in points will depend on its font style and size
            let buttonTitleFont = UIFont(name: "Helvetica", size: 14.0)
            
            // Set the font of the button title label text
            scrollMenuButton.titleLabel?.font = buttonTitleFont
            
            // Compute the size of the button title in points
            let buttonTitleSize: CGSize = (buttonTitle as NSString).size(withAttributes: [NSAttributedStringKey.font:buttonTitleFont!])
            
            let titleTextWidth = buttonTitleSize.width
            let logoImageWidth = noteImage.size.width
            
            var buttonWidth: CGFloat = 0.0
            
            // Set the button width to be the largest width + 20 pixels of padding
            if titleTextWidth > logoImageWidth {
                buttonWidth = titleTextWidth + 20.0
            } else {
                buttonWidth = logoImageWidth + 20.0
            }
            
            // Set the button frame with width=buttonWidth height=kScrollMenuHeight points with origin at (x, y) = (0, 0)
            scrollMenuButton.frame = CGRect(x: 0.0, y: 0.0, width: buttonWidth, height: kScrollMenuHeight)
            
            // Set the button title to the genre's title
            scrollMenuButton.setTitle(buttonTitle, for: UIControlState())
            
            // Set the button title color to black when the button is not selected
            scrollMenuButton.setTitleColor(UIColor.black, for: UIControlState())
            
            // Set the button title color to red when the button is selected
            scrollMenuButton.setTitleColor(UIColor.red, for: UIControlState.selected)
            
            // Specify the Inset values for top, left, bottom, and right edges for the title
            scrollMenuButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, -noteImage.size.width, -(noteImage.size.height + 5), 0.0)
            
            // Specify the Inset values for top, left, bottom, and right edges for the genreLogo
            scrollMenuButton.imageEdgeInsets = UIEdgeInsetsMake(-(buttonTitleSize.height + 5), 0.0, 0.0, -buttonTitleSize.width)
            
            // Set the button to invoke the buttonPressed: method when the user taps it
            scrollMenuButton.addTarget(self, action: #selector(NoteDataViewController.buttonPressed(_:)), for: .touchUpInside)
            
            // Add the constructed button to the list of buttons
            listOfMenuButtons.append(scrollMenuButton)
        }
        
        /*********************************************************************************************
         * Compute the sumOfButtonWidths = sum of the widths of all buttons to be displayed in the menu
         *********************************************************************************************/
        
        var sumOfButtonWidths: CGFloat = 0.0
        
        for j in 0 ..< listOfMenuButtons.count {
            
            // Obtain the obj ref to the jth button in the listOfMenuButtons array
            let button: UIButton = listOfMenuButtons[j]
            
            // Set the button's frame to buttonRect
            var buttonRect: CGRect = button.frame
            
            // Set the buttonRect's x coordinate value to sumOfButtonWidths
            buttonRect.origin.x = sumOfButtonWidths
            
            // Set the button's frame to the newly specified buttonRect
            button.frame = buttonRect
            
            // Add the button to the horizontally scrollable menu
            scrollView.addSubview(button)
            
            // Add the width of the button to the total width
            sumOfButtonWidths += button.frame.size.width
        }
        
        // Horizontally scrollable menu's content width size = the sum of the widths of all of the buttons
        // Horizontally scrollable menu's content height size = kScrollMenuHeight points
        scrollView.contentSize = CGSize(width: sumOfButtonWidths, height: kScrollMenuHeight)
        
        /*******************************************************
         * Select and show the default genre upon app launch
         *******************************************************/
        
        // Hide left arrow
        leftArrowImageView.isHidden = true
        
        // The first auto maker on the list is the default one to display
        let defaultButton: UIButton = listOfMenuButtons[0]
        
        // Indicate that the button is selected
        defaultButton.isSelected = true
        
        previousButton = defaultButton
        selectedView = 0

        
    }
    
    @IBAction func editTapped(_ sender: UIBarButtonItem) {
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     -----------------------------------
     MARK: - Scroll View Delegate Method
     -----------------------------------
     */
    
    // Tells the delegate when the user scrolls the content view within the receiver
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        /*
         Content        = concatenated list of buttons
         Content Width  = sum of all button widths, sumOfButtonWidths
         Content Height = kScrollMenuHeight points
         Origin         = (x, y) values of the bottom left corner of the scroll view or content
         Sx             = Scroll View's origin x value
         Cx             = Content's origin x value
         contentOffset  = Sx - Cx
         
         Interpretation of the Arrows:
         
         IF scrolled all the way to the RIGHT THEN show only RIGHT arrow: indicating that the data (content) is
         on the right hand side and therefore, the user must *** scroll to the left *** to see the content.
         
         IF scrolled all the way to the LEFT THEN show only LEFT arrow: indicating that the data (content) is
         on the left hand side and therefore, the user must *** scroll to the right *** to see the content.
         
         5 pixels used as padding
         */
        if scrollView.contentOffset.x <= 5 {
            // Scrolling is done all the way to the RIGHT
            leftArrowImageView.isHidden   = true      // Hide left arrow
            rightArrowImageView.isHidden  = false     // Show right arrow
        }
        else if scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width) - 5 {
            // Scrolling is done all the way to the LEFT
            leftArrowImageView.isHidden   = false     // Show left arrow
            rightArrowImageView.isHidden  = true      // Hide right arrow
        }
        else {
            // Scrolling is in between. Scrolling can be done in either direction.
            leftArrowImageView.isHidden   = false     // Show left arrow
            rightArrowImageView.isHidden  = false     // Show right arrow
        }
    }
    
    /*
     -----------------------------------
     MARK: - Method to Handle Button Tap
     -----------------------------------
     */
    // This method is invoked when the user taps a button in the horizontally scrollable menu
    @objc func buttonPressed(_ sender: UIButton) {
        
        let selectedButton: UIButton = sender
        
        // Indicate that the button is selected
        selectedButton.isSelected = true
        
        if previousButton != selectedButton {
            // Selecting the selected button again should not change its title color
            previousButton.isSelected = false
        }
        
        previousButton = selectedButton
        
        selectedView = selectedButton.tag

    }
    
    /*
     ------------------------------------
     MARK: - Resize Image Proportionately
     ------------------------------------
     */
    func resizeImage(image: UIImage, withSize: CGSize) -> UIImage {
        
        var actualHeight: CGFloat = image.size.height
        var actualWidth: CGFloat = image.size.width
        let maxHeight: CGFloat = withSize.width
        let maxWidth: CGFloat = withSize.height
        var imgRatio: CGFloat = actualWidth/actualHeight
        let maxRatio: CGFloat = maxWidth/maxHeight
        let compressionQuality = 1.0
        
        if (actualHeight > maxHeight || actualWidth > maxWidth) {
            if (imgRatio < maxRatio) {
                // Adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            } else if (imgRatio > maxRatio) {
                // Adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            } else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let image: UIImage  = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData = UIImageJPEGRepresentation(image, CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        let resizedImage = UIImage(data: imageData!)
        
        return resizedImage!
    }
    

    @IBAction func playButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "Edit Notes" {
            
            // Obtain the object reference of the destination view controller
            let newNoteViewController: NewNoteViewController = segue.destination as! NewNoteViewController
            newNoteViewController.startingState = CanvasState.Edit
            newNoteViewController.event = passedEvent
            newNoteViewController.images = views
            newNoteViewController.isMicActive = false
            
        }
    }
    
    
    
}
