//
//  StackTableViewCell.swift
//  Meetis
//
//  Created by Kyle Thompson on 4/9/18.
//  Copyright © 2018 Abey Yoseph. All rights reserved.
//

import UIKit

protocol StackCellDelegate {
    func didTapPen(title: String)
    func didTapPic(title: String)
    func didTapImport(title: String)
    func didTapIgnore(title: String)
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
    
    
    var index = -1
    var cellExists = false
    var micActive = false
    var delegate: StackCellDelegate?
    
    let background_color = UIColor.init(red: 50/255, green: 54/255, blue: 64/255, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = background_color
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
            print("animation complete")
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
        delegate?.didTapPen(title: eventTimeLabel.text!)
    }
    
    @IBAction func picTapped(_ sender: UIButton) {
        delegate?.didTapPic(title: eventTimeLabel.text!)
    }
    
    @IBAction func importTapped(_ sender: UIButton) {
        delegate?.didTapImport(title: eventTimeLabel.text!)
    }
    @IBAction func ignoreTapped(_ sender: UIButton) {
        delegate?.didTapIgnore(title: eventTimeLabel.text!)
    }
    
}
