//
//  LinearRegression.swift
//  GoniometerAlpha
//
//  Created by Keshav Patel on 7/28/16.
//  Copyright © 2016 Keshav Patel. All rights reserved.
//

import Foundation
import UIKit
import Accelerate

class LinearRegression
{
    var cutoff: Double
    var edges: Double
    
    init(c: Double, e: Double)
    {
        cutoff = c
        edges = e
    }
    
    func processImage(_ pixels: [[[CGFloat]]]) -> [[UIColor]]
    {
        var processedItems: [[UIColor]] = []
        for _ in 1...Int(pixels.count)
        {
            var processedLine: [UIColor] = []
            for _ in 1...Int(pixels[0].count)
            {
                processedLine.append(UIColor.white)
            }
            processedItems.append(processedLine)
        }
        for h in 1...Int(pixels.count)-2
        {
            //var processedLine: [UIColor] = []
            for w in 1...Int(pixels[0].count)-2
            {
                if processedItems[h][w] == UIColor.black
                {
                    continue
                }
                let r1 = pixels[h][w][0]
                let g1 = pixels[h][w][1]
                let b1 = pixels[h][w][2]
                let brightness = Double(pow(pow(r1,2)+pow(g1,2)+pow(b1,2),0.5))
                if brightness < edges
                {
                    //processedLine.append(UIColor.whiteColor())
                    continue
                }
                if brightness > (1.0-edges)
                {
                    //processedLine.append(UIColor.whiteColor())
                    continue
                }
                var pixelProcessed = false
                for a in [-1, 0, 1]
                {
                    for b in [-1, 0, 1]
                    {
                        let neighbor = pixels[h+a][w+b]
                        if neighbor == [0.0, 0.0, 0.0] || neighbor == [1.0, 1.0, 1.0] || neighbor == pixels[h][w]
                        {
                            continue;
                        }
                        let r2 = neighbor[0]
                        let g2 = neighbor[1]
                        let b2 = neighbor[2]
                        let distance = Double(pow(pow(r1-r2,2)+pow(g1-g2,2)+pow(b1-b2,2),0.5))
                        if  distance > cutoff && (neighbor != [1.0, 1.0, 1.0] || neighbor != [0.0, 0.0, 0.0])
                        {
                            processedItems[h][w] = UIColor.black
                            processedItems[h+a][w+b] = UIColor.black
                            //processedLine.append(UIColor.blackColor())
                            pixelProcessed = true
                        }
                        if pixelProcessed
                        {
                            break
                        }
                    }
                    if pixelProcessed
                    {
                        break
                    }
                }
                /*
                 if !pixelProcessed
                 {
                 processedLine.append(UIColor.whiteColor())
                 }
                 */
            }
            //processedItems.append(processedLine)
        }
        return processedItems
    }
    
    func regressionData(_ BWImage: [[UIColor]]) -> [[CGPoint]]
    {
        var output1: [CGPoint] = []
        var output2: [CGPoint] = []
        
        for y in 1...BWImage.count-2
        {
            var output1X: Int? = nil
            var output1Y: Int? = nil
            for x in 1...BWImage[0].count-2
            {
                let previousXColor = BWImage[y][x-1]
                let futureXColor = BWImage[y][x+1]
                let currentColor = BWImage[y][x]
                if currentColor == UIColor.white
                {
                    continue
                }
                if(output1X == nil && currentColor == UIColor.black && previousXColor != UIColor.black)
                {
                    output1X = x
                    output1Y = y
                }
                else if(output1X != nil && output1Y == y && currentColor == UIColor.black && previousXColor != UIColor.black)
                {
                    output1.append(CGPoint(x: round(CGFloat(output1X! + x)/2), y: CGFloat(output1Y!)))
                    output1X = x
                    output1Y = y
                    //output1X = nil
                    //output1Y = nil
                }
            }
        }
        
        for x in 1...BWImage[0].count-2
        {
            var output2X: Int? = nil
            var output2Y: Int? = nil
            for y in 1...BWImage.count-2
            {
                let previousYColor = BWImage[y-1][x]
                let futureYColor = BWImage[y+1][x]
                let currentColor = BWImage[y][x]
                if currentColor == UIColor.white
                {
                    continue
                }
                if(output2Y == nil && currentColor == UIColor.black && previousYColor != UIColor.black)
                {
                    output2Y = y
                    output2X = x
                }
                else if(output2Y != nil && output2X == x && currentColor == UIColor.black && previousYColor != UIColor.black)
                {
                    output2.append(CGPoint(x: CGFloat(output2X!), y: round(CGFloat(output2Y! + y)/2)))
                    output2X = x
                    output2Y = y
                    //output2X = nil
                    //output2Y = nil
                }
            }
        }
        
        return [output1, output2]
    }
    
    
    
    
    func longLine(_ output1:[CGPoint])->[CGPoint]
    {
        var longRed: [[CGPoint]] = []
        var maxlen=0
        var maxin = 0
        
        longRed.append([output1[0]])
        
        for i in 1...Int(output1.count)-1
        {
            let currentPoint = output1[i]
            var isNotInExisting = false
            for a in [-1, 0, 1]
            {
                for b in [-1, 0, 1]
                {
                    let point = CGPoint(x: currentPoint.x+CGFloat(a),y: currentPoint.y+CGFloat(b))
                    
                    if output1.contains(point)
                    {
                        for i in 0...Int(longRed.count)-1
                        {
                            if longRed[i].contains(point) && !isNotInExisting
                            {
                                longRed[i].append(currentPoint)
                                isNotInExisting=true
                                break
                            }
                        }
                    }
                    if isNotInExisting
                    {
                        break;
                    }
                }
                if isNotInExisting
                {
                    break;
                }
            }
            if !isNotInExisting
            {
                longRed.append([currentPoint])
            }
        }
        for i in 0...Int(longRed.count)-1
        {
            let curlen=longRed[i].count
            if curlen>maxlen
            {
                maxlen = curlen
                maxin = i
            }
            
        }
        return longRed[maxin]
    }
    
    
    
    
    func invert(_ matrix : [Double]) -> [Double] {
        
        var inMatrix = matrix
        
        var pivot : __CLPK_integer = 0
        var workspace = 0.0
        var error : __CLPK_integer = 0
        
        var N = __CLPK_integer(sqrt(Double(matrix.count)))
        dgetrf_(&N, &N, &inMatrix, &N, &pivot, &error)
        
        if error != 0 {
            return inMatrix
        }
        
        dgetri_(&N, &inMatrix, &N, &pivot, &workspace, &N, &error)
        return inMatrix
    }
    
    /**
     Calculate theta values using the normal equations.
     - returns: Double array with theta coefficients
     */
    func normalEquations(_ Data:[CGPoint]) -> [Double]
    {
        //𝜃 = inverse(X' * X) * X' * y
        var x: [Double] = []
        var y: [Double] = []
        for v in 0...Data.count-1
        {
            x.append(Double(Data[v].x))
            x.append(1.0)
            y.append(Double(Data[v].y))
        }
        var mtresult = [Double](repeating: 0.0, count: x.count)
        vDSP_mtransD(x, 1, &mtresult, 1, 2, UInt(Data.count))
        
        var mresult = [Double](repeating: 0.0, count: 4)
        vDSP_mmulD(mtresult, 1, x, 1, &mresult, 1, 2, 2, UInt(Data.count))
        
        let inverse = invert(mresult)
        
        var doubleOG = [Double](repeating: 0.0, count: 2*Data.count)
        vDSP_mmulD(inverse, 1, mtresult, 1, &doubleOG, 1, 2, UInt(Data.count),2)
        
        var VK4lyfe = [Double](repeating: 0.0, count: 2)
        vDSP_mmulD(doubleOG, 1, y, 1, &VK4lyfe, 1, 2, 1, UInt(Data.count))
        return VK4lyfe
    }
    
    
}
