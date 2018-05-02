//
//  CanvasView.swift
//  Meetis
//
//  Created by Kyle Thompson on 4/28/18.
//  Copyright © 2018 Abey Yoseph. All rights reserved.
//

import UIKit



/**
 This class is used for marking up notes
*/
class CanvasView: UIImageView {
    
    // mark-up variables
    var lineColor = UIColor.black
    var lineWidth: CGFloat = 4
    var lineOpacity: Float = 1
    var path:UIBezierPath!
    var touchPoint: CGPoint!
    var startingPoint: CGPoint!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.clipsToBounds = true
        self.isMultipleTouchEnabled = false
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // set the starting point as an initial reference
        let touch = touches.first
        startingPoint = touch?.location(in: self)
        
    }
    
    // called when putting finger on surface and moving finger
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // get the value and update touch point to its location
        let touch = touches.first
        touchPoint = touch?.location(in: self)
        
        // initialize a BezierPath and add a line from the starting point to the current point
        path = UIBezierPath()
        path.move(to: startingPoint)
        path.addLine(to: touchPoint)
        
        //update starting point to touch point when finger moved
        startingPoint = touchPoint
        
        //now draw the shape layer
        drawShapeLayer()
    }
    
    // create a shape over the path the was created
    func drawShapeLayer() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.opacity = lineOpacity
        
        //make line smoother
        shapeLayer.lineCap = kCALineCapRound
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(shapeLayer)
        self.setNeedsDisplay()
    }
    
    func clearCanvas() {
        if path != nil && !path.isEmpty {
            path.removeAllPoints()
            
            self.layer.sublayers = nil
            
            self.setNeedsDisplay()
        }
    }
    
    func addBackground(image: UIImage) {
        self.image = image
    }
    
    func removeBackground() {
        self.image = nil
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
