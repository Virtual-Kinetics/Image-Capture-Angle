//
//  ImageController.swift
//  CameraTutorial
//
//  Created by Keshav Patel on 5/21/16.
//  Copyright © 2016 VK. All rights reserved.
//

import UIKit

extension UIImage
{
    func getPixelColor(width: Int, height: Int) -> [[[CGFloat]]]
    {
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        var pixels: [[[CGFloat]]] = []
        for y in 0...height-1
        {
            var pixelLine: [[CGFloat]] = []
            for x in 0...width-1
            {
                let pixelInfo: Int = ((Int(4+self.size.width) * y) + x) * 4
                
                let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
                let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
                let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
                
                pixelLine.append([r, g, b])
            }
            pixels.append(pixelLine)
        }
        return pixels
    }
    
    func resizeImage(newWidth: CGFloat) -> UIImage
    {
        
        let scale = newWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

class ImageController: UIViewController
{
    
    var photo : UIImage?
    var changedPhoto : UIImage?
    @IBOutlet var storeDataButton: UIButton!
    @IBOutlet var home: UIButton!
    @IBOutlet var cancel: UIButton!
    var points: [CGRect] = []
    var rectViews: [UIView] = []
    var lineViews: [UIView] = []
    var currentRect: Int?
    let size: Int = 20
    var isLoaded = false
    let cutoff = 0.1
    let edges = 0.3
    var calcAngle = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let image = UIImage(named: "home") as UIImage?
        //home = UIButton(type: UIButtonType.Custom) as UIButton
        home.setImage(image, forState: .Normal)
        home.frame = CGRectMake(30, 30, 50, 50)
        view.addSubview(home)
        
        let image2 = UIImage(named: "cancel") as UIImage?
        //home = UIButton(type: UIButtonType.Custom) as UIButton
        cancel.setImage(image2, forState: .Normal)
        //home.frame = CGRectMake(30, 30, 50, 50)
        view.addSubview(cancel)
        */
        
        photo = UIImage(named: "testImage")
        if(photo != nil)
        {
            let OGphoto = photo
            photo = photo?.resizeImage(100)
            
            
            let imageView = UIImageView(image: OGphoto)
            let screenSize: CGRect = view.frame
            imageView.frame = CGRect(x:0, y:0, width:screenSize.width, height:screenSize.height)
        
            //Show the captured image to
            view.addSubview(imageView)
            // send to back so that the buttons and label are visible
            view.sendSubviewToBack(imageView)
            
 
 
            //let lr = LinearRegression(c: cutoff, e: edges)
            
            isLoaded = true
            
            /*
            let start = NSDate(); // <<<<<<<<<< Start time
            let pixels = photo!.getPixelColor(Int(photo!.size.width), height: Int(photo!.size.height))
            let process = lr.processImage(pixels)
            let end = NSDate();   // <<<<<<<<<<   end time
            let timeInterval: Double = end.timeIntervalSinceDate(start); // <<<<< Difference in seconds (double)
            print("Image converted to black and white. Time to evaluate: \(timeInterval) seconds");

            let start2 = NSDate(); // <<<<<<<<<< Start time
            let mid = lr.regressionData(process)
            let end2 = NSDate();   // <<<<<<<<<<   end time
            let timeInterval2: Double = end2.timeIntervalSinceDate(start2); // <<<<< Difference in seconds (double)
            print("Midpoints Found. Time to evaluate: \(timeInterval2) seconds");
            
            let start3 = NSDate(); // <<<<<<<<<< Start time
            let long1 = lr.longLine(mid[0])
            let long2 = lr.longLine(mid[1])
            let end3 = NSDate();   // <<<<<<<<<<   end time
            let timeInterval3: Double = end3.timeIntervalSinceDate(start3); // <<<<< Difference in seconds (double)
            print("Long Lines. Time to evaluate: \(timeInterval3) seconds");
 
            let start4 = NSDate(); // <<<<<<<<<< Start time
            let line1 = lr.normalEquations(long1)
            let line2 = lr.normalEquations(long2)
            let end4 = NSDate();   // <<<<<<<<<<   end time
            let timeInterval4: Double = end4.timeIntervalSinceDate(start4); // <<<<< Difference in seconds (double)
            print("Regression Performed. Time to evaluate: \(timeInterval4) seconds");
            
            let start5 = NSDate(); // <<<<<<<<<< Start time
            findAutoDots(line1, y2: line2, line1: long1, line2: long2)
            let end5 = NSDate();   // <<<<<<<<<<   end time
            let timeInterval5: Double = end5.timeIntervalSinceDate(start5); // <<<<< Difference in seconds (double)
            print("Dots Placed. Time to evaluate: \(timeInterval5) seconds");

            
            let widthRatio = view.frame.width / photo!.size.width
            let heightRatio = view.frame.height / photo!.size.height
            */
            
            /*
            for y in 0...process.count-1
            {
                for x in 0...process[0].count-1
                {
                    if process[y][x] == UIColor.blackColor()
                    {
                        let rect: CGRect = CGRectMake(CGFloat(x)*widthRatio, CGFloat(y)*heightRatio, widthRatio, heightRatio)
                        let square = UIView(frame: rect)
                        //print(view.frame.width)
                        //print(x)
                        square.backgroundColor = UIColor.blackColor()
            
                        view.addSubview(square)
                        //view.sendSubviewToBack(square)
                    }
                }
            }
            */
 
            /*
            for point in mid[0]
            {
                let rect: CGRect = CGRectMake(point.x*widthRatio, point.y*heightRatio, widthRatio, heightRatio)
                let square = UIView(frame: rect)
                //print(view.frame.width)
                //print(x)
                square.backgroundColor = UIColor.yellowColor()
                
                view.addSubview(square)
                //view.sendSubviewToBack(square)
            }
            for point in mid[1]
            {
                let rect: CGRect = CGRectMake(point.x*widthRatio, point.y*heightRatio, widthRatio, heightRatio)
                let square = UIView(frame: rect)
                //print(view.frame.width)
                //print(x)
                square.backgroundColor = UIColor.greenColor()
                
                view.addSubview(square)
                //view.sendSubviewToBack(square)
            }
            */
            
            /*
            for point in long1
            {
                let rect: CGRect = CGRectMake(point.x*widthRatio, point.y*heightRatio, widthRatio, heightRatio)
                let square = UIView(frame: rect)
                //print(view.frame.width)
                //print(x)
                square.backgroundColor = UIColor.redColor()
                
                view.addSubview(square)
                //view.sendSubviewToBack(square)
            }
            for point in long2
            {
                let rect: CGRect = CGRectMake(point.x*widthRatio, point.y*heightRatio, widthRatio, heightRatio)
                let square = UIView(frame: rect)
                //print(view.frame.width)
                //print(x)
                square.backgroundColor = UIColor.blueColor()
                
                view.addSubview(square)
                //view.sendSubviewToBack(square)
            }
            */
            
            /*
            for i in 1...100
            {
                let rect: CGRect = CGRectMake(CGFloat(i)*widthRatio, (CGFloat(line2[0])*CGFloat(i)+CGFloat(line2[1]))*heightRatio, widthRatio, heightRatio)
                let square = UIView(frame: rect)
                //print(view.frame.width)
                //print(x)
                square.backgroundColor = UIColor.purpleColor()
                
                view.addSubview(square)
                //view.sendSubviewToBack(square)
            }
            */
 
            //print("\nsent to viewController. Image will come up shortly")
            
        }
    }
    
    func findAutoDots(y1: [Double], y2: [Double], line1: [CGPoint], line2: [CGPoint])
    {
        let xPos = (y2[1]-y1[1])/(y1[0]-y2[0])
        let yPos = y1[0]*xPos+y1[1]
        
        //ask for first and last points of the two cleaned data lines
        //what quadrant are the points in (wrt the origin at the center point), this determines direction of the vectors
        
//        let vector1 = CGPointMake(line1.x, CGFloat(y1[0])*line1.x+CGFloat(y1[1]))
//        let vector2 = CGPointMake(line2.x, CGFloat(y2[0])*line2.x+CGFloat(y2[1]))
        
        let widthRatio = view.frame.width / photo!.size.width
        let heightRatio = view.frame.height / photo!.size.height
        
        let far1 = findFarPoint(xPos, y: yPos, points: line1)
        let far2 = findFarPoint(xPos, y: yPos, points: line2)
        
        placeDot(widthRatio*far1.x, y: heightRatio*(CGFloat(y1[0])*far1.x+CGFloat(y1[1])))
        placeDot(widthRatio*CGFloat(xPos), y: heightRatio*CGFloat(yPos))
        placeDot(widthRatio*far2.x, y: heightRatio*(CGFloat(y2[0])*far2.x+CGFloat(y2[1])))
        
        placeLine(0, changePos: false)
        placeLine(1, changePos: false)
        
        findAngle()
        
//        let quad1x = Double(line1.x) - xPos
//        let quad1y = Double(line1.y) - yPos
//        let quad2x = Double(line2.x) - xPos
//        let quad2y = Double(line2.y) - yPos
//        
//        let quad1 = pointInQuad(quad1x, quady: quad1y)
//        let quad2 = pointInQuad(quad2x, quady: quad2y)
//        
//        let a1 = pow(y1[0],2)+1
//        let b1 = 2*y1[0]*y1[1]-2*y1[0]*yPos-2*xPos
//        let c11 = pow(y1[1],2)-2*y1[1]*yPos
//        let c1 = c11+pow(yPos,2)+pow(xPos,2)-pow(50,2)
//        
//        let x11 = (-1*b1+pow(pow(b1,2)-4*a1*c1,0.5))/2/a1
//        let x12 = (-1*b1-pow(pow(b1,2)-4*a1*c1,0.5))/2/a1
//        let y11 = y1[0]*x11+y1[1]
//        let y12 = y1[0]*x12+y1[1]
//        
//        let a2 = pow(y2[0],2)+1
//        let b2 = 2*y2[0]*y2[1]-2*y2[0]*yPos-2*xPos
//        let c21 = pow(y2[1],2)-2*y2[1]*yPos
//        let c2 = c21+pow(yPos,2)+pow(xPos,2)-pow(50,2)
//        
//        let x21 = (-1*b2+pow(pow(b2,2)-4*a2*c2,0.5))/2/a2
//        let x22 = (-1*b2-pow(pow(b2,2)-4*a2*c2,0.5))/2/a2
//        let y21 = y2[0]*x21+y2[1]
//        let y22 = y2[0]*x22+y2[1]
//        print(pow(b2,2))
//        print(4*a2*c2)
//        print(x21)
        
//        let quad3 = pointInQuad(x11-xPos, quady: y11-yPos)
//        //let quad4 = pointInQuad(x12-xPos, quady: y12-yPos)
//        if quad1 == quad3
//        {
//            placeDot(CGFloat(x11), y: CGFloat(y11))
//        }
//        else
//        {
//            placeDot(CGFloat(x12), y: CGFloat(y12))
//        }
//        placeLine(0, changePos: false)
//        
//        let quad5 = pointInQuad(x21-xPos, quady: y21-yPos)
//        //let quad6 = pointInQuad(x22-xPos, quady: y22-yPos)
//        if quad1 == quad5
//        {
//            placeDot(CGFloat(x21), y: CGFloat(y21))
//        }
//        else
//        {
//            placeDot(CGFloat(x22), y: CGFloat(y22))
//        }
//        placeLine(1, changePos: false)
        
//        findAngle()
    }
    
    func findFarPoint(x: Double, y: Double, points: [CGPoint]) -> CGPoint
    {
        var output = points[0]
        let d1 = pow(pow(x-Double(points[0].x),2)+pow(y-Double(points[0].y),2),0.5)
        let d2 = pow(pow(x-Double(points[points.count-1].x),2)+pow(y-Double(points[points.count-1].y),2),0.5)
        if d2 > d1
        {
            output = points[points.count-1]
        }
        return output
    }
    
    func pointInQuad(quadx: Double, quady: Double) -> Int
    {
        if quadx > 0 && quady > 0
        {
            return 1
        }
        else if quadx < 0 && quady > 0
        {
            return 2
        }
        else if quadx < 0 && quady < 0
        {
            return 3
        }
        else
        {
            return 4
        }
    }
    
    
    
    
    //Both linear regression and touchesMoved can place dots and lines
    func placeDot(x: CGFloat, y: CGFloat)
    {
        let rect: CGRect = CGRectMake(x-CGFloat(size/2), y-CGFloat(size/2), CGFloat(size), CGFloat(size))
        let square = UIView(frame: rect)
        square.backgroundColor = UIColor.cyanColor()
        square.layer.cornerRadius = CGFloat(size/2)
        square.clipsToBounds = true
        view.addSubview(square)
        // arrays used to distinguish between boxes in touchesMoved
        points.append(rect)
        rectViews.append(square)
    }
    
    func placeLine(lineNum: Int = 0, changePos: Bool)
    {
        let x1 = CGRectGetMidX(points[0+lineNum])
        let y1 = CGRectGetMidY(points[0+lineNum])
        let x2 = CGRectGetMidX(points[1+lineNum])
        let y2 = CGRectGetMidY(points[1+lineNum])
        let d1 = pow(pow(x1-x2,2)+pow(y1-y2,2),0.5)
        let line: CGRect = CGRectMake(CGRectGetMidX(points[0]), CGRectGetMidY(points[0]), d1, 5)
        var angle = acos((x2-x1)/d1)
        if y1-y2 > 0
        {
            angle = acos((x1-x2)/d1)
        }
        if(!changePos)
        {
            let lineView = UIView(frame: line)
            lineView.transform = CGAffineTransformMakeRotation(angle)
            lineView.backgroundColor = UIColor.cyanColor()
            lineView.center = CGPoint(x: (x1+x2)/2, y: (y1+y2)/2)
            view.addSubview(lineView)
            lineViews.append(lineView)
        }
        else
        {
            lineViews[0+lineNum].transform = CGAffineTransformIdentity
            lineViews[0+lineNum].frame = line
            lineViews[0+lineNum].transform = CGAffineTransformMakeRotation(angle)
            lineViews[0+lineNum].center = CGPoint(x: (x1+x2)/2, y: (y1+y2)/2)
        }
    }
    
    
    @IBAction func storeData()
    {
        let alertController = UIAlertController(title: "Enter Patient Information", message: "", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (field: UITextField) in
            field.placeholder = "First Name"
        }
        alertController.addTextFieldWithConfigurationHandler { (field: UITextField) in
            field.placeholder = "Last Name"
        }
        alertController.addTextFieldWithConfigurationHandler { (field: UITextField) in
            field.placeholder = "Datum Description"
        }
        let action = UIAlertAction(title: "Store", style: .Default)
        { (_) in
            self.store(alertController)
        }
        alertController.addAction(action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) {}
    }
    
    func store(alert: UIAlertController)
    {
        let today = NSDate()
        var unwrapped = alert.textFields![0].text! + ", " + alert.textFields![1].text! + ", "
        unwrapped = unwrapped + String(calcAngle) + ", " + String(today)
        unwrapped = unwrapped + ", " + alert.textFields![2].text! + ", "
        
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let path = paths[0].URLByAppendingPathComponent("goniometerDataAugust2.csv")
        
        var text2: String = ""
        do {
            text2 = try String(contentsOfURL: path, encoding: NSUTF8StringEncoding)
        }
        catch let error as NSError {
            print("Error: \(error)")
        }
        unwrapped = text2 + unwrapped
        
        //writing
        do
        {
            try unwrapped.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
            let alert = UIAlertController(title: "Goniometer Alpha", message: "Data Stored!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        catch {print("Noooo")}
    }
    
    
    
    
    //How you move dots around screen
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        super.touchesMoved(touches, withEvent:event)
        if let touch = touches.first
        {
            let oldTouchLocation = touch.previousLocationInView(view)
            let newTouchLocation = touch.locationInView(view)
            if currentRect != nil
            {
                if CGRectContainsPoint(points[currentRect!], CGPointMake(oldTouchLocation.x, oldTouchLocation.y))
                {
                    //change the frame of the current rectangle as a way to move it across the screen
                    let rect: CGRect = CGRectMake(newTouchLocation.x-10, newTouchLocation.y-10, 20, 20)
                    rectViews[currentRect!].frame = rect
                    points[currentRect!] = rect
                    if currentRect == 0 || currentRect == 1
                    {
                        placeLine(0, changePos: true)
                    }
                    if currentRect == 2 || currentRect == 1
                    {
                        placeLine(1, changePos: true)
                    }
                    findAngle()
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        super.touchesBegan(touches, withEvent:event)
        if touches.first != nil
        {
            currentRect = nil
        }
    }
    
    
    //Setting the 3 points
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if isLoaded
        {
            super.touchesBegan(touches, withEvent:event)
            if let touch = touches.first
            {
                    let touchLocation = touch.locationInView(view)
                    if points.count < 3
                    {
                        // Rectangles used to define the points of the angle to measure
                        placeDot(touchLocation.x, y: touchLocation.y)
                        
                        if points.count == 2
                        {
                            placeLine(0, changePos: false)
                        }
                        if points.count == 3
                        {
                            placeLine(1, changePos: false)
                        }
                }
                if points.count == 3
                {
                    for index in 0...points.count-1
                    {
                        if CGRectContainsPoint(points[index], CGPointMake(touchLocation.x, touchLocation.y))
                        {
                            currentRect = index
                            break;
                        }
                    }
                    findAngle()
                }
            }
        }
    }
    
    
    
    func findAngle()
    {
        // Use the Law of Cosines to find the angle
        let x1 = CGRectGetMidX(points[0])
        let y1 = CGRectGetMidY(points[0])
        let x2 = CGRectGetMidX(points[1])
        let y2 = CGRectGetMidY(points[1])
        let x3 = CGRectGetMidX(points[2])
        let y3 = CGRectGetMidY(points[2])
        
        let d1 = pow(pow(x1-x2,2)+pow(y1-y2,2),0.5)
        let d2 = pow(pow(x2-x3,2)+pow(y2-y3,2),0.5)
        let d3 = pow(pow(x3-x1,2)+pow(y3-y1,2),0.5)
        
        calcAngle = Double(round(acos((pow(d1,2)+pow(d2,2)-pow(d3,2))/(2*d1*d2))*180/3.14159*10)/10)
        storeDataButton.setTitle("\(calcAngle)", forState: UIControlState.Normal)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        
        if segue.identifier == "StoreValue"
        {
            let destViewController: TableViewController = segue.destinationViewController as! TableViewController
            destViewController.angle = calcAngle
            
        }
        
        
    }

}
