//
//  NewNoteViewController.swift
//  Meetis
//
//  Created by CS3714 on 4/11/18.
//  Copyright © 2018 Abey Yoseph. All rights reserved.
//

import UIKit
import AVFoundation


class NewNoteViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var canvasView: CanvasView!
    @IBOutlet var leftArrowImageView: UIImageView!
    @IBOutlet var horizontalScrollView: UIScrollView!
    @IBOutlet var rightArrowImageView: UIImageView!
    
    // data passed from upstream
    var startingState:CanvasState!
    var isMicActive:Bool!
    var event: Event!
    var filename: String!
    
    // audio recording variables
    var recordingSession: AVAudioSession?
    var audioRecorder: AVAudioRecorder!
    
    // variable for the background images
    var imagePicker = UIImagePickerController()
    //var backgroundImage: UIImageView!
    
    // contains all the views for each of the note pages
    var views = [UIView]()
    var pageNum = 0
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    
    // variables used for the scroll view
    var previousButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let kScrollMenuHeight: CGFloat = 75.0
    let backgroundColorToUse = UIColor.white
    
    let buttonNames = ["Black", "Blue", "Red", "Highlight", "Erase", "Clear", "Camera", "Import", "New_Page"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // add scroll view buttons
        populateScrollView()
        
        // disable swipe to pop-off for editting purposes
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        
        imagePicker.delegate = self
        
        
        // if starting state is import or camera automatically go to that view
        if startingState == CanvasState.Import {
            openPhotoLibraryButton()
        } else if startingState == CanvasState.Pic {
            openCameraButton()
        }
        
        
        // Create a Save button on the right of the navigation bar to call the "save:" method when tapped
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(NewNoteViewController.saveButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = saveButton
        
        //set up recording
        if isMicActive {
            recordingSession = AVAudioSession.sharedInstance()
            setUpRecorder()
        } else {
            recordingSession = nil
        }
           
    }
    
    /*
     -------------------
     MARK: - Save Method
     -------------------
     */
    // This method is invoked when the user taps the Save button
    @objc func saveButtonTapped(_ sender: AnyObject) {
        //stop recording
        if isMicActive {
            audioRecorder.stop()
        }
        
        //add current view to views array
        newPageSelected()
        
        // save all views to document directory as .png
        for i in 1...views.count {
            let image = UIImage(view: views[i - 1])
            
            if let data = UIImagePNGRepresentation(image) {
                let filename = getDocumentsDirectory().appendingPathComponent("\(self.filename!)_\(i).png")
                print(filename)
                try? data.write(to: filename)
            }
            
        }
        
        // add needed information to event in order to retrieve file information
        event.apppendToNotes(filename: filename!)
        
        //  update the dictionaries
        applicationDelegate.dict_Events.setValue(event.toDict(), forKeyPath: event.title)
        let noteData: [AnyObject] = ["placeholder" as AnyObject, views.count as AnyObject]
        applicationDelegate.dict_Notes.setValue(noteData, forKey: filename!)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func populateScrollView() {
        horizontalScrollView.delegate = self
        
        //set background color
        self.view.backgroundColor = backgroundColorToUse
        leftArrowImageView.backgroundColor = backgroundColorToUse
        rightArrowImageView.backgroundColor = backgroundColorToUse
        horizontalScrollView.backgroundColor = backgroundColorToUse
        
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
            let resizedImage = resizeImage(image: buttonImage!, withSize: CGSize(width: 50, height: 50))
            
            // Set the button frame at origin at (x, y) = (0, 0) with
            // button width  =  image width + 20 points padding for each side
            // button height = kScrollMenuHeight points
            scrollMenuButton.frame = CGRect(x: 0.0, y: 0.0, width: resizedImage.size.width + 20.0, height: 50)
            
            // Set the button image to be the designated button action ico
            scrollMenuButton.setImage(resizedImage, for: UIControlState())
            
            // The button width and height in points will depend on its font style and size
            let buttonTitleFont = UIFont(name: "Helvetica", size: 12.0)
            
            // Set the font of the button title label text
            scrollMenuButton.titleLabel?.font = buttonTitleFont
            
            // Compute the size of the button title in points
            let buttonTitleSize: CGSize = (name as NSString).size(withAttributes: [NSAttributedStringKey.font:buttonTitleFont!])
            
            let titleTextWidth = buttonTitleSize.width
            let logoImageWidth = resizedImage.size.width
            
            var buttonWidth: CGFloat = 0.0
            
            // Set the button width to be the largest width + 20 pixels of padding
            if titleTextWidth > logoImageWidth {
                buttonWidth = titleTextWidth + 20.0
            } else {
                buttonWidth = logoImageWidth + 20.0
            }
            
            // Set the button frame with width=buttonWidth height=kScrollMenuHeight points with origin at (x, y) = (0, 0)
            scrollMenuButton.frame = CGRect(x: 0.0, y: 0.0, width: buttonWidth, height: 75 )
            
            // Set the button title to the selection's name
            scrollMenuButton.setTitle(buttonNames[i], for: UIControlState())
            
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
        
        var sumOfButtonWidths: CGFloat = 0.0

        for j in 0 ..< listOfMenuButtons.count {
            
            // Obtain the obj ref to the jth button in the listOfMenuButtons array
            let button: UIButton = listOfMenuButtons[j]
            
            // Set the button's frame to buttonRect
            var buttonRect: CGRect = button.frame
            
            // Set the buttonRect's y coordinate value to sumOfButtonHeights
            buttonRect.origin.x = sumOfButtonWidths
            
            // Set the button's frame to the newly specified buttonRect
            button.frame = buttonRect
            
            // Add the button to the vertically scrollable menu
            horizontalScrollView.addSubview(button)
            
            // Add the height of the button to the total height
            sumOfButtonWidths += button.frame.size.width
            
        }
        
        horizontalScrollView.contentSize = CGSize(width: sumOfButtonWidths, height: kScrollMenuHeight)
        
        // Hide left arrow
        leftArrowImageView.isHidden = true
    }
    /*
     -----------------------------------
     MARK: - Method to Handle Button Tap
     -----------------------------------
     */
    // This method is invoked when the user taps a button in the horizontally scrollable menu
    @objc func buttonPressed(_ sender: UIButton) {
        
        let selectedButton: UIButton = sender
        

        switch selectedButton.tag {
        case 0:
            updateToBlackPen()
            break
        case 1:
            updateToBluePen()
            break
        case 2:
            updateToRedPen()
            break
        case 3:
            updateToHighlight()
            break
        case 4:
            updateToErase()
            break
        case 5 :
            canvasView.clearCanvas()
            break
        case 6:
            openCameraButton()
            break
        case 7:
            openPhotoLibraryButton()
            break
        default:
            newPageSelected()
        }
        
        // check if this is a canvas state update i.e. pen change
        if selectedButton.tag < 5 {
            
        
            // Indicate that the button is selected
            selectedButton.isSelected = true
            
            if previousButton != selectedButton {
                // Selecting the selected button again should not change its title color
                previousButton.isSelected = false
            }
            
            previousButton = selectedButton
            
        }
        
    }
    
    
    
    func updateToBlackPen() {
        canvasView.lineColor = UIColor.black
        canvasView.lineOpacity = 1
    }
    
    func updateToBluePen() {
        canvasView.lineColor = UIColor.blue
        canvasView.lineOpacity = 1
    }
    
    func updateToRedPen() {
        canvasView.lineColor = UIColor.red
        canvasView.lineOpacity = 1
    }
    
    func updateToErase() {
        canvasView.lineColor = UIColor.clear
        canvasView.lineOpacity = 1
    }
    
    func updateToHighlight () {
        canvasView.lineColor = UIColor.yellow
        canvasView.lineOpacity = 0.25
    }
    
    
    // add snapshot of canvasview to views array of note images
    func newPageSelected() {
        
        // add to end
        if pageNum == views.count || views.isEmpty {
            views.append(canvasView.snapshotView(afterScreenUpdates: true)!)
        } else { //update that view
            views[pageNum] = canvasView.snapshotView(afterScreenUpdates: true)!
        }
        canvasView.clearCanvas()
        pageNum = pageNum + 1
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
         Content Height = sum of all button heights, sumOfButtonHeights
         Content Width  = kScrollMenuWidth points
         Origin         = (x, y) values of the bottom left corner of the scroll view or content
         Sy             = Scroll View's origin y value
         Cy             = Content's origin y value
         contentOffset  = Cy - Sy
         
         Interpretation of the Arrows:
         
         IF scrolled all the way to the RIGHT then show only LEFT arrow: indicating that the data (content) is
         on the lower side and therefore, the user must *** scroll DOWN *** to see the content.
         
         IF scrolled all the way to the LEFT then show only RIGHT arrow: indicating that the data (content) is
         on the upper side and therefore, the user must *** scroll RIGHT *** to see the content.
         
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
    
    /*
     -----------------------------
     MARK: - Display Alert Message
     -----------------------------
     */
    func showAlertMessage(messageHeader header: String, messageBody body: String) {
        
        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: header, message: body, preferredStyle: UIAlertControllerStyle.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    

}

// logic for the Photo Library Selection and the New Picture capture from the camera
extension NewNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func openPhotoLibraryButton() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openCameraButton() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {

            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
        image = resizeImage(image: image, withSize: canvasView.bounds.size)
        canvasView.addBackground(image: image)
        dismiss(animated:true, completion: nil)
    }

}

// logic for the voice recording
extension NewNoteViewController:  AVAudioRecorderDelegate {
    
    func setUpRecorder() {
        do {
            try recordingSession!.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession!.setActive(true)
            recordingSession!.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.startRecording()
                    } else {
                        self.showAlertMessage(messageHeader: "Permission Denied", messageBody: "In order to record, please allow microphone access in privact settings!")
                    }
                }
            }
        } catch {
            // failed to record!
            showAlertMessage(messageHeader: "Recording Failed", messageBody: "The voice recording failed")
        }
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(filename)_recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            showAlertMessage(messageHeader: "Recording Failed", messageBody: "The voice recording failed")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

// allows a view to be converted to a png
extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}


