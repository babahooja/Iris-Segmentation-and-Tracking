//
//  BoundingBox.swift
//  V100
//
//  Created by Himanshu Ahuja on 03/07/18.
//  Copyright © 2018 Himanshu Ahuja. All rights reserved.
//

import Foundation
import UIKit

class BoundingBox: UIView{
    var lastPoint = CGPoint.zero
    var touch: UITouch!
//    var rect: CGRect = CGRect(x:0, y:0, width: 0, height: 0)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Hello")
        //Save original tap Point
        touch = touches.first! as UITouch
        lastPoint = touch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = touches.first! as UITouch
        let currentPoint = touch.location(in: self)
        self.frame = makeRectangle(fromPoint: lastPoint, toPoint: currentPoint)
            // do something with your currentPoint
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(self.frame.width)
        ///////////////////// use this frame overlay ////////////////////////////////
        //        applyFilterToSelectedArea(overlay.frame)
        
        //        overlay.frame = CGRect.zero //reset overlay for next tap
        
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//        let rectangle = CGRect(x: 0, y: 100, width: 320, height: 100)
        ctx.stroke(rect)
    }
    
    private func makeRectangle(fromPoint: CGPoint, toPoint: CGPoint) -> (CGRect){
        let rect = CGRect(x: min(fromPoint.x, toPoint.x), y: min(fromPoint.y, toPoint.y), width: fabs(fromPoint.x - toPoint.x), height: fabs(fromPoint.y - toPoint.y));
        return rect
    }
    
    
    
}
