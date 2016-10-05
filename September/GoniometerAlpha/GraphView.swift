//
//  GraphView.swift
//  GoniometerAlpha
//
//  Created by Keshav Patel on 6/12/16.
//  Copyright © 2016 Keshav Patel. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView
{
    
    var graphPoints: [Double] = []
    var timePoints: [NSDate] = []
    var appNumber: [UILabel] = []
    var yAxis: [UILabel] = []
    var maxTimeIndex: Int = 0
    var minTimeIndex: Int = 0
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.

    func sortByTime() -> [Int]
    {
        var out: [Int] = [0]
        for i in 1..<timePoints.count
        {
            var inserted = false
            for k in 0..<out.count
            {
                if timePoints[i].timeIntervalSinceDate(timePoints[out[k]]) < 0
                {
                    out.insert(i, atIndex: k)
                    inserted = true
                    break
                }
            }
            if !inserted
            {
                out.append(i)
            }
        }
        return out
    }
    
    func columnXPoint(column: Int, width: CGFloat, margin: CGFloat) -> CGFloat
    {
        
        var maxTimeGap = CGFloat(timePoints[minTimeIndex].timeIntervalSinceDate(timePoints[maxTimeIndex]))
        let maxDistGap = width - margin*2 - 4
        
        var x:CGFloat = maxDistGap / maxTimeGap
        x = x * CGFloat(self.timePoints[minTimeIndex].timeIntervalSinceDate(self.timePoints[column])) + margin - 2

        return x
    }
 
    
    func columnYPoint(graphPoint:Double, graphHeight: CGFloat, maxValue: Double, topBorder: CGFloat) -> CGFloat
    {
        var y:CGFloat = CGFloat(graphPoint) /
        CGFloat(maxValue) * graphHeight
        y = graphHeight + topBorder - y // Flip the graph
        return y
    }
    
    override func drawRect(rect: CGRect)
    {
        // Drawing code
        if graphPoints.count > 1
        {
            let timeOrder = sortByTime()
            minTimeIndex = timeOrder[0]
            maxTimeIndex = timeOrder[timeOrder.count-1]
            
            while appNumber.count > 0
            {
                appNumber[0].removeFromSuperview()
                appNumber.removeAtIndex(0)
            }
            while yAxis.count > 0
            {
                yAxis[0].removeFromSuperview()
                yAxis.removeAtIndex(0)
            }
            
            let width = rect.width
            let height = rect.height
            
            let margin:CGFloat = 60.0

            
            let topBorder:CGFloat = 50
            let bottomBorder:CGFloat = 100
            let graphHeight = height - topBorder - bottomBorder
            let maxValue = graphPoints.maxElement()!
            
            // draw the line graph
            
            UIColor.whiteColor().setFill()
            UIColor.whiteColor().setStroke()
            
            
            
            //set up the points line
            let graphPath = UIBezierPath()
            //go to start of line
            graphPath.moveToPoint(CGPoint(x:columnXPoint(0, width: width, margin: margin),
                y:columnYPoint(graphPoints[0], graphHeight: graphHeight, maxValue: maxValue, topBorder: topBorder)))
            
            //add points for each item in the graphPoints array
            //at the correct (x, y) for the point
            for i in timeOrder
            {
                let nextPoint = CGPoint(x:columnXPoint(i, width: width, margin: margin),
                                        y:columnYPoint(graphPoints[i], graphHeight: graphHeight, maxValue: maxValue, topBorder: topBorder))
                graphPath.addLineToPoint(nextPoint)
            }
            
            
            
            for i in 0..<graphPoints.count
            {
                var point = CGPointMake(columnXPoint(i, width: width, margin: margin), columnYPoint(graphPoints[i], graphHeight: graphHeight, maxValue: maxValue, topBorder: topBorder))
                point.x -= 5.0/2
                point.y -= 5.0/2
                /*
                let xLabelFrame = CGRectMake(point.x, height - bottomBorder + 20, 20, 20)
                var overlaps = false
                for j in 0..<appNumber.count
                {
                    if CGRectIntersectsRect(xLabelFrame, appNumber[j].frame)
                    {
                        overlaps = true
                    }
                }
                if !overlaps
                {
                    let xLabel = UILabel(frame: CGRectMake(point.x, height - bottomBorder + 20, 20, 20))
                    xLabel.text = String(i+1)
                    addSubview(xLabel)
                    appNumber.append(xLabel)
                }
                */
                
                let circle = UIBezierPath(ovalInRect:
                    CGRect(origin: point,
                        size: CGSize(width: 5.0, height: 5.0)))
                circle.fill()
            }
            
            let xLabelFrame1 = CGRectMake(margin-25, height - bottomBorder + 20, 100, 20)
            let xLabel1 = UILabel(frame: xLabelFrame1)
            let minTimeString = String(timePoints[minTimeIndex])
            let minDateString1 = minTimeString.substringToIndex(minTimeString.startIndex.advancedBy(10))
            let minDateString = minDateString1.substringFromIndex(minDateString1.startIndex.advancedBy(5))
            xLabel1.text = String(minDateString)
            addSubview(xLabel1)
            appNumber.append(xLabel1)
            
            let xLabelFrame2 = CGRectMake(width-margin-25, height - bottomBorder + 20, 100, 20)
            let xLabel2 = UILabel(frame: xLabelFrame2)
            let maxTimeString = String(timePoints[maxTimeIndex])
            let maxDateString1 = maxTimeString.substringToIndex(maxTimeString.startIndex.advancedBy(10))
            let maxDateString = maxDateString1.substringFromIndex(maxDateString1.startIndex.advancedBy(5))
            minTimeString
            xLabel2.text = String(maxDateString)
            addSubview(xLabel2)
            appNumber.append(xLabel2)
            
            let xLabelFrame3 = CGRectMake(margin-25, height - bottomBorder + 40, 100, 20)
            let xLabel3 = UILabel(frame: xLabelFrame3)
            let minYearString = minTimeString.substringToIndex(minTimeString.startIndex.advancedBy(4))
            xLabel3.text = String(minYearString)
            addSubview(xLabel3)
            appNumber.append(xLabel3)
            
            let xLabelFrame4 = CGRectMake(width-margin-25, height - bottomBorder + 40, 100, 20)
            let xLabel4 = UILabel(frame: xLabelFrame4)
            let maxYearString = maxTimeString.substringToIndex(maxTimeString.startIndex.advancedBy(4))
            xLabel4.text = String(maxYearString)
            addSubview(xLabel4)
            appNumber.append(xLabel4)
            
            
            //Draw horizontal graph lines on the top of everything
            let linePath = UIBezierPath()
            
            //top line
            linePath.moveToPoint(CGPoint(x:margin, y: topBorder))
            linePath.addLineToPoint(CGPoint(x: width - margin,
                y:topBorder))
            
            let yLabel1 = UILabel(frame: CGRectMake(0, topBorder-5, 100, 20))
            yLabel1.text = String(graphPoints.maxElement()!)
            //yLabel1.center = CGPointMake(200, topBorder)
            addSubview(yLabel1)
            yAxis.append(yLabel1)
            
            //center line
            linePath.moveToPoint(CGPoint(x:margin,
                y: graphHeight/2 + topBorder))
            linePath.addLineToPoint(CGPoint(x:width - margin,
                y:graphHeight/2 + topBorder))
            
            
            
            let yLabel2 = UILabel(frame: CGRectMake(0, graphHeight/2 + topBorder-5, 100, 20))
            yLabel2.text = String(graphPoints.maxElement()!/2)
            //yLabel2.center = CGPointMake(200, graphHeight/2 + topBorder)
            addSubview(yLabel2)
            yAxis.append(yLabel2)
            
            
            
            //bottom line
            linePath.moveToPoint(CGPoint(x:margin,
                y:height - bottomBorder))
            linePath.addLineToPoint(CGPoint(x:width - margin,
                y:height - bottomBorder))
            let color = UIColor(white: 1.0, alpha: 0.3)
            color.setStroke()
            
            let yLabel3 = UILabel(frame: CGRectMake(0, height - bottomBorder-5, 100, 20))
            yLabel3.text = String(0.0)
            //yLabel3.center = CGPointMake(200, height - bottomBorder)
            addSubview(yLabel3)
            yAxis.append(yLabel3)
            
            linePath.lineWidth = 1.0
            linePath.stroke()
            
            graphPath.stroke()
            
        }
    }
    
    
}
