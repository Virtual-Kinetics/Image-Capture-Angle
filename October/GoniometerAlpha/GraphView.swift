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
    var timePoints: [Date] = []
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
                if timePoints[i].timeIntervalSince(timePoints[out[k]]) < 0
                {
                    out.insert(i, at: k)
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
    
    func columnXPoint(_ column: Int, width: CGFloat, margin: CGFloat) -> CGFloat
    {
        
        let maxTimeGap = CGFloat(timePoints[minTimeIndex].timeIntervalSince(timePoints[maxTimeIndex]))
        let maxDistGap = width - margin*2 - 4
        
        var x:CGFloat = maxDistGap / maxTimeGap
        x = x * CGFloat(self.timePoints[minTimeIndex].timeIntervalSince(self.timePoints[column])) + margin - 2

        return x
    }
 
    
    func columnYPoint(_ graphPoint:Double, graphHeight: CGFloat, maxValue: Double, topBorder: CGFloat) -> CGFloat
    {
        var y:CGFloat = CGFloat(graphPoint) /
        CGFloat(maxValue) * graphHeight
        y = graphHeight + topBorder - y // Flip the graph
        return y
    }
    
    override func draw(_ rect: CGRect)
    {
        //print("graph")
        backgroundColor = UIColor.gray
        // Drawing code
        if graphPoints.count > 1
        {
            let timeOrder = sortByTime()
            minTimeIndex = timeOrder[0]
            maxTimeIndex = timeOrder[timeOrder.count-1]
            
            while appNumber.count > 0
            {
                appNumber[0].removeFromSuperview()
                appNumber.remove(at: 0)
            }
            while yAxis.count > 0
            {
                yAxis[0].removeFromSuperview()
                yAxis.remove(at: 0)
            }
            
            let width = rect.width
            let height = rect.height
            
            let margin:CGFloat = 80.0

            
            let topBorder:CGFloat = 50
            let bottomBorder:CGFloat = 100
            let graphHeight = height - topBorder - bottomBorder
            let maxValue = graphPoints.max()!
            
            // draw the line graph
            
            UIColor.white.setFill()
            UIColor.white.setStroke()
            
            
            
            //set up the points line
            let graphPath = UIBezierPath()
            //go to start of line
            graphPath.move(to: CGPoint(x:columnXPoint(0, width: width, margin: margin),
                y:columnYPoint(graphPoints[0], graphHeight: graphHeight, maxValue: maxValue, topBorder: topBorder)))
            
            //add points for each item in the graphPoints array
            //at the correct (x, y) for the point
            for i in timeOrder
            {
                let nextPoint = CGPoint(x:columnXPoint(i, width: width, margin: margin),
                                        y:columnYPoint(graphPoints[i], graphHeight: graphHeight, maxValue: maxValue, topBorder: topBorder))
                graphPath.addLine(to: nextPoint)
            }
            
            
            
            for i in 0..<graphPoints.count
            {
                var point = CGPoint(x: columnXPoint(i, width: width, margin: margin), y: columnYPoint(graphPoints[i], graphHeight: graphHeight, maxValue: maxValue, topBorder: topBorder))
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
                
                let circle = UIBezierPath(ovalIn:
                    CGRect(origin: point,
                        size: CGSize(width: 5.0, height: 5.0)))
                circle.fill()
            }
            
            let xLabelFrame1 = CGRect(x: margin-25, y: height - bottomBorder + 20, width: 100, height: 20)
            let xLabel1 = UILabel(frame: xLabelFrame1)
            let minTimeString = String(describing: timePoints[minTimeIndex])
            let minDateString1 = minTimeString.substring(to: minTimeString.characters.index(minTimeString.startIndex, offsetBy: 10))
            let minDateString = minDateString1.substring(from: minDateString1.characters.index(minDateString1.startIndex, offsetBy: 5))
            xLabel1.text = String(minDateString)
            addSubview(xLabel1)
            appNumber.append(xLabel1)
            
            let xLabelFrame2 = CGRect(x: width-margin-25, y: height - bottomBorder + 20, width: 100, height: 20)
            let xLabel2 = UILabel(frame: xLabelFrame2)
            let maxTimeString = String(describing: timePoints[maxTimeIndex])
            let maxDateString1 = maxTimeString.substring(to: maxTimeString.characters.index(maxTimeString.startIndex, offsetBy: 10))
            let maxDateString = maxDateString1.substring(from: maxDateString1.characters.index(maxDateString1.startIndex, offsetBy: 5))
            minTimeString
            xLabel2.text = String(maxDateString)
            addSubview(xLabel2)
            appNumber.append(xLabel2)
            
            let xLabelFrame3 = CGRect(x: margin-25, y: height - bottomBorder + 40, width: 100, height: 20)
            let xLabel3 = UILabel(frame: xLabelFrame3)
            let minYearString = minTimeString.substring(to: minTimeString.characters.index(minTimeString.startIndex, offsetBy: 4))
            xLabel3.text = String(minYearString)
            addSubview(xLabel3)
            appNumber.append(xLabel3)
            
            let xLabelFrame4 = CGRect(x: width-margin-25, y: height - bottomBorder + 40, width: 100, height: 20)
            let xLabel4 = UILabel(frame: xLabelFrame4)
            let maxYearString = maxTimeString.substring(to: maxTimeString.characters.index(maxTimeString.startIndex, offsetBy: 4))
            xLabel4.text = String(maxYearString)
            addSubview(xLabel4)
            appNumber.append(xLabel4)
            
            
            //Draw horizontal graph lines on the top of everything
            let linePath = UIBezierPath()
            
            //top line
            linePath.move(to: CGPoint(x:margin, y: topBorder))
            linePath.addLine(to: CGPoint(x: width - margin,
                y:topBorder))
            
            let yLabel1 = UILabel(frame: CGRect(x: margin-50, y: topBorder-7, width: 100, height: 20))
            yLabel1.text = String(graphPoints.max()!)
            //yLabel1.center = CGPointMake(200, topBorder)
            addSubview(yLabel1)
            yAxis.append(yLabel1)
            
            //center line
            linePath.move(to: CGPoint(x:margin,
                y: graphHeight/2 + topBorder))
            linePath.addLine(to: CGPoint(x:width - margin,
                y:graphHeight/2 + topBorder))
            
            
            
            let yLabel2 = UILabel(frame: CGRect(x: margin-50, y: graphHeight/2 + topBorder-7, width: 100, height: 20))
            yLabel2.text = String(graphPoints.max()!/2)
            //yLabel2.center = CGPointMake(200, graphHeight/2 + topBorder)
            addSubview(yLabel2)
            yAxis.append(yLabel2)
            
            
            
            //bottom line
            linePath.move(to: CGPoint(x:margin,
                y:height - bottomBorder))
            linePath.addLine(to: CGPoint(x:width - margin,
                y:height - bottomBorder))
            let color = UIColor(white: 1.0, alpha: 0.3)
            color.setStroke()
            
            let yLabel3 = UILabel(frame: CGRect(x: margin-50, y: height - bottomBorder-7, width: 100, height: 20))
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
