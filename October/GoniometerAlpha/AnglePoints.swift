//
//  AnglePoints.swift
//  GoniometerAlpha
//
//  Created by Keshav Patel on 6/5/16.
//  Copyright © 2016 Keshav Patel. All rights reserved.
//

import UIKit

class AnglePoints: UIView {

    override func drawRect(rect: CGRect) {
        let aPath = UIBezierPath()
        
        aPath.moveToPoint(CGPoint(x: 10, y: 10))
        
        aPath.addLineToPoint(CGPoint(x:50, y:50))
        
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        
        aPath.closePath()
        
        //If you want to stroke it with a red color
        UIColor.cyanColor().set()
        aPath.stroke()
        //If you want to fill it as well 
        aPath.fill()
        
    }

}
