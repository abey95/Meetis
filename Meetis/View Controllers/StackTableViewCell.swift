//
//  StackTableViewCell.swift
//  Meetis
//
//  Created by Kyle Thompson on 4/9/18.
//  Copyright © 2018 Abey Yoseph. All rights reserved.
//

import UIKit

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
    @IBOutlet var uploadButton: UIButton!
    @IBOutlet var dismissButton: UIButton!
    
    
    
    
    var cellExists = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    
}
