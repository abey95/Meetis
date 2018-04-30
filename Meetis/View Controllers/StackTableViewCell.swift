//
//  StackTableViewCell.swift
//  Meetis
//
//  Created by Kyle Thompson on 4/9/18.
//  Copyright © 2018 Abey Yoseph. All rights reserved.
//

import UIKit

protocol StackCellDelegate {
    func didTapNote(sender: StackTableViewCell)
    func didTapIgnore(sender: StackTableViewCell)
    func didTapDetail(sender: StackTableViewCell)
    
}

enum CanvasState {
    case Blank, Pic, Import;
}

class StackTableViewCell: UITableViewCell {
    
    @IBOutlet var openView: UIView!
    @IBOutlet var stuffView: UIView! {
        didSet {
            stuffView?.isHidden = true
            stuffView?.alpha = 0
        }
    }
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var eventTitleLabel: UILabel!
    @IBOutlet var eventTimeLabel: UILabel!
    
    @IBOutlet var openButton: UIButton!
    @IBOutlet var micButton: UIButton!
    @IBOutlet var penButton: UIButton!
    @IBOutlet var picButton: UIButton!
    @IBOutlet var ignoreButton: UIButton!
    @IBOutlet var importButton: UIButton!
    
    // selected cell state
    var micActive = false
    var currState = CanvasState.Blank
    
    var index = -1 //row number for the cell
    var cellExists = false
    var delegate: StackCellDelegate?
    var micBackground = UIImageView()
    
    let background_color = UIColor.init(red: 50/255, green: 54/255, blue: 64/255, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = background_color
        
        micButton.layer.masksToBounds = true
        micButton.layer.cornerRadius = micButton.layer.frame.width/2
    }
    
    func animate(duration:Double, c: @escaping () -> Void) {
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration, animations: {
                
                self.stuffView.isHidden = !self.stuffView.isHidden
                if self.stuffView.alpha == 1 {
                    self.stuffView.alpha = 0.5
                } else {
                    self.stuffView.alpha = 1
                }
                
            })
        }, completion: {  (finished: Bool) in
            c()
        })
    }
    
    @IBAction func micTapped(_ sender: UIButton) {
        
        micActive = !micActive
        
        if micActive {
            micButton.backgroundColor = UIColor.red
        } else {
            micButton.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func penTapped(_ sender: UIButton) {
        currState = .Blank
        delegate?.didTapNote(sender: self)
    }
    
    @IBAction func picTapped(_ sender: UIButton) {
        currState = .Pic
       delegate?.didTapNote(sender: self)
    }
    
    @IBAction func importTapped(_ sender: UIButton) {
        currState = .Import
        delegate?.didTapNote(sender: self)
    }
    @IBAction func ignoreTapped(_ sender: UIButton) {
        delegate?.didTapIgnore(sender: self)
    }
    
    @IBAction func detailDisclosureTapped(_ sender: UIButton) {
        delegate?.didTapDetail(sender: self)
    }
}

