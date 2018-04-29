//
//  NewNoteViewController.swift
//  Meetis
//
//  Created by CS3714 on 4/11/18.
//  Copyright © 2018 Abey Yoseph. All rights reserved.
//

import UIKit

class NewNoteViewController: UIViewController {

    @IBOutlet var canvasView: CanvasView!
    @IBOutlet var leftArrowImageView: UIImageView!
    @IBOutlet var horizontalScrollView: UIScrollView!
    @IBOutlet var rightArrowImageView: UIImageView!
    
    // instance of the current note that will hold all the note data
    var note: Note!
    
    var previousButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let kScrollMenuHeight: CGFloat = 100.0
    
    var dataPassed: [String]?
    
    var buttonNames = ["Black", "Blue", "Red", "Highlight", "Erase", "Clear", "Text", "Camera", "New_Page"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()



        /***********************************************************************
         * Instantiate and setup the buttons for the horizontally scrollable menu
         ***********************************************************************/

        // Instantiate a mutable array to hold the menu buttons to be created
        var listOfMenuButtons = [UIButton]()

        for i in 0 ..< buttonNames.count {

            // Instantiate a button to be placed within the horizontally scrollable menu
            let scrollMenuButton = UIButton(type: UIButtonType.custom)

            // Obtain the dictionary of the genre
            let name = buttonNames[i].replacingOccurrences(of: "_", with: " ")

            // Obtain the auto manufacturer's logo image
            let buttonImage = UIImage(named: "\(buttonNames[i].lowercased()).png")

            // Set the button frame at origin at (x, y) = (0, 0) with
            // button width  =  image width + 10 points padding for each side
            // button height = kScrollMenuHeight points
            scrollMenuButton.frame = CGRect(x: 0.0, y: 0.0, width: buttonImage!.size.width + 20.0, height: kScrollMenuHeight)

            // Set the button image to be the auto maker's logo
            scrollMenuButton.setImage(buttonImage, for: UIControlState())

            // The button width and height in points will depend on its font style and size
            let buttonTitleFont = UIFont(name: "Helvetica", size: 12.0)

            // Set the font of the button title label text
            scrollMenuButton.titleLabel?.font = buttonTitleFont

            // Compute the size of the button title in points
            let buttonTitleSize: CGSize = (name as NSString).size(withAttributes: [NSAttributedStringKey.font:buttonTitleFont!])

            let titleTextWidth = buttonTitleSize.width
            let logoImageWidth = buttonImage!.size.width

            var buttonWidth: CGFloat = 0.0

            // Set the button width to be the largest width + 20 pixels of padding
            if titleTextWidth > logoImageWidth {
                buttonWidth = titleTextWidth + 20.0
            } else {
                buttonWidth = logoImageWidth + 20.0
            }

            // Set the button frame with width=buttonWidth height=kScrollMenuHeight points with origin at (x, y) = (0, 0)
            scrollMenuButton.frame = CGRect(x: 0.0, y: 0.0, width: buttonWidth, height: kScrollMenuHeight)

            // Set the button title to the automobile manufacturer's name
            scrollMenuButton.setTitle(name, for: UIControlState())

            // Set the button title color to black when the button is not selected
            scrollMenuButton.setTitleColor(UIColor.black, for: UIControlState())

            // Set the button title color to red when the button is selected
            scrollMenuButton.setTitleColor(UIColor.red, for: UIControlState.selected)

            // Specify the Inset values for top, left, bottom, and right edges for the title
            scrollMenuButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, -buttonImage!.size.width, -(buttonImage!.size.height + 5), 0.0)

            // Specify the Inset values for top, left, bottom, and right edges for the auto logo image
            scrollMenuButton.imageEdgeInsets = UIEdgeInsetsMake(-(buttonTitleSize.height + 5), 0.0, 0.0, -buttonTitleSize.width)

            // Set the button to invoke the buttonPressed: method when the user taps it
            scrollMenuButton.addTarget(self, action: #selector(NewNoteViewController.buttonPressed(_:)), for: .touchUpInside)

            scrollMenuButton.tag = i
            
            // Add the constructed button to the list of buttons
            listOfMenuButtons.append(scrollMenuButton)

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
        
        // check if this is a canvas state update
        if selectedButton.tag < 5 {
            
        }
        
        // Indicate that the button is selected
        selectedButton.isSelected = true
        
        if previousButton != selectedButton {
            // Selecting the selected button again should not change its title color
            previousButton.isSelected = false
        }
        
        previousButton = selectedButton
        
    }
    
    
    func updateToBlackPen() {
        canvasView.isErase = false
        canvasView.lineColor = UIColor.black
    }
    
    func updateToBluePen() {
        canvasView.isErase = false
        canvasView.lineColor = UIColor.blue
    }
    
    func updateToRedPen() {
        canvasView.isErase = false
        canvasView.lineColor = UIColor.red
    }
    
    func updateToErase() {
        canvasView.isErase = true
        canvasView.lineColor = UIColor.clear
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

