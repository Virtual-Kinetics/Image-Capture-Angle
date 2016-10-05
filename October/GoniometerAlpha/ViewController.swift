//
//  ViewController.swift
//  Goniometer Beta
//
//  Created by Keshav Patel on 5/24/16.
//  Copyright © 2016 Keshav Patel. All rights reserved.
//

import UIKit
import AVFoundation

extension UIView
{
    func layerGradient()
    {
        let layer : CAGradientLayer = CAGradientLayer()
        layer.frame.size = self.frame.size
        layer.frame.origin = CGPoint(x: 0.0,y: 0.0)
        layer.cornerRadius = CGFloat(frame.width / 20)
        
        let color0 = UIColor(red:250.0/255, green:250.0/255, blue:250.0/255, alpha:0.5).cgColor
        let color1 = UIColor(red:200.0/255, green:200.0/255, blue: 200.0/255, alpha:0.1).cgColor
        let color2 = UIColor(red:150.0/255, green:150.0/255, blue: 150.0/255, alpha:0.1).cgColor
        let color3 = UIColor(red:100.0/255, green:100.0/255, blue: 100.0/255, alpha:0.1).cgColor
        let color4 = UIColor(red:50.0/255, green:50.0/255, blue:50.0/255, alpha:0.1).cgColor
        let color5 = UIColor(red:0.0/255, green:0.0/255, blue:0.0/255, alpha:0.1).cgColor
        let color6 = UIColor(red:150.0/255, green:150.0/255, blue:150.0/255, alpha:0.1).cgColor
        
        layer.colors = [color0,color1,color2,color3,color4,color5,color6]
        self.layer.insertSublayer(layer, at: 0)
    }
}

class ViewController: UIViewController
{
    let dataFile = "goniometerDataAugust2.csv"
    
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    //@IBOutlet var photoButton: UIButton!
    @IBOutlet var captureImage: UIButton!
    @IBOutlet var home: UIButton!
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    var imageCapture : UIImage!
    var pictureTaken = false
    
    var fullText: [String] = []
    var firstNameList: [String] = []
    var lastNameList: [String] = []
    var angleList: [Double] = []
    var timeList: [Date] = []
    var descriptionList: [String] = []
    
    var descriptionPicked: String?
    var beginDate: Date?
    var endDate: Date?
    var firstName: String?
    var lastName: String?
    
    @IBOutlet var angleOutput: UILabel!
    var points: [CGRect] = []
    var rectViews: [UIView] = []
    var lineViews: [UIView] = []
    var currentRect: Int?
    let size: Int = 20
    var isLoaded = false
    let cutoff = 0.1
    let edges = 0.3
    var calcAngle = 0.0
    
    @IBOutlet var filter: UIBarButtonItem!
    @IBOutlet var table: UIBarButtonItem!
    @IBOutlet var graph: UIBarButtonItem!
    @IBOutlet var store: UIBarButtonItem!
    
    @IBOutlet var cameraView: CameraView!
    @IBOutlet var tableView: DataView!
    @IBOutlet var graphView: GraphView!
    @IBOutlet var imageView: ImageView!
    @IBOutlet var bottomBar: UIToolbar!
    var activeView: UIView?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        activeView = cameraView
        //view.addSubview(activeView!)
        view.bringSubview(toFront: activeView!)
        view.bringSubview(toFront: bottomBar)
        activeView!.setNeedsDisplay()
        
        loadData()
    }
    
    func loadData()
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0].appendingPathComponent(dataFile)
        
        do
        {
            let fileText = try String(contentsOf: path, encoding: String.Encoding.utf8)
            fullText = fileText.components(separatedBy: ", ")
            
        }
        catch {}
        
        let textSize = fullText.count
        var addAt: [Int] = []
        var toAdd: [String] = []
        for i in 0..<textSize
        {
            if fullText[i].contains("\n")
            {
                let toSplit = fullText[i].components(separatedBy: "\n")
                fullText[i] = toSplit[0]
                toAdd.append(toSplit[1])
                addAt.append(i+1)
            }
            fullText[i] = fullText[i].trimmingCharacters(in: CharacterSet.whitespaces)
        }
        for i in 0..<toAdd.count
        {
            fullText.insert(toAdd[i], at: addAt[i]+i)
        }
    }
    
    
    @IBAction func search()
    {
        print(firstName)
        print(descriptionPicked)
        firstNameList = []
        lastNameList = []
        angleList = []
        timeList = []
        descriptionList = []
        //let firstText = firstNameField.text
        //let lastText = lastNameField.text
        if (firstName == nil || firstName == "") && (lastName == nil || lastName == "")
        {
            let alert = UIAlertController(title: "Goniometer Alpha", message: "A name must be given to search", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if(fullText.count > 1)
        {
            let firstNameSearch = firstName!.lowercased().trimmingCharacters(in: CharacterSet.whitespaces)
            let lastNameSearch = lastName!.lowercased().trimmingCharacters(in: CharacterSet.whitespaces)
            for entry in 0...fullText.count-4
            {
                if((fullText[entry].lowercased() == firstNameSearch || firstNameSearch == "") && (fullText[entry+1].lowercased() == lastNameSearch || lastNameSearch == ""))
                {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
                    let nowDate = dateFormatter.date(from: fullText[entry+3])
                    var isInRange = true
                    
                    if descriptionPicked != nil && descriptionPicked != ""
                    {
                        if descriptionPicked != fullText[entry+4]
                        {
                            isInRange = false
                        }
                    }
                    if beginDate != nil
                    {
                        if beginDate!.timeIntervalSince(nowDate!) > 0
                        {
                            isInRange = false
                        }
                    }
                    if endDate != nil
                    {
                        if endDate!.timeIntervalSince(nowDate!) < 0
                        {
                            isInRange = false
                        }
                    }
                    
                    if isInRange
                    {
                        firstNameList.append(fullText[entry])
                        lastNameList.append(fullText[entry+1])
                        angleList.append(Double(fullText[entry+2])!)
                        timeList.append(nowDate!)
                    }
                    descriptionList.append(fullText[entry+4])
                }
            }
        }
        //print(descriptionList)
        //print(angleList)
        //print(timeList)
    }
    
    func filter(_ beginMonth: String, beginDay: String, beginYear: String, endMonth: String, endDay: String, endYear: String)
    {
        var beginMonthString = beginMonth
        var beginDayString = beginDay
        let beginYearString = beginYear
        var endMonthString = endMonth
        var endDayString = endDay
        let endYearString = endYear
        
        if beginMonthString.count < 2
        {
            beginMonthString = "0" + beginMonthString
        }
        else if beginMonthString.count == 0
        {
            beginMonthString = "00"
        }
        if beginDayString.count < 2
        {
            beginDayString = "0" + beginDayString
        }
        else if beginDayString.count == 0
        {
            beginDayString = "00"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        beginDate = dateFormatter.date(from: beginYearString+"-"+beginMonthString+"-"+beginDayString+" 00:00:00 +0000")

        if endMonthString.count < 2
        {
            endMonthString = "0" + endMonthString
        }
        else if endMonthString.count == 0
        {
            endMonthString = "12"
        }
        if endDayString.count < 2
        {
            endDayString = "0" + endDayString
        }
        else if endDayString.count == 0
        {
            beginMonthString = "31"
        }
        endDate = dateFormatter.date(from: endYearString+"-"+endMonthString+"-"+endDayString+" 23:59:59 +0000")
        search()
    }
    
    @IBAction func switchViews(_ sender: UIBarButtonItem)
    {
        let button = sender.tag
        if activeView != nil
        {
            //activeView?.removeFromSuperview()
            var viewSwitch = false
            if button == 0
            {
                filterPopup()
            }
            if button == 1
            {
                tableView.angleList = angleList
                tableView.descriptionList = descriptionList
                tableView.descriptionPicked = descriptionPicked
                tableView.timeList = timeList
                tableView.dataCellView.reloadData()
                activeView = tableView
                viewSwitch = true
            }
            if button == 2
            {
                viewSwitch = true
                graphView.graphPoints = angleList
                graphView.timePoints = timeList
                activeView = graphView
                graphView.setNeedsDisplay()
            }
            if button == 3
            {
                storeData()
                loadData()
            }
            if button == 4
            {
                //print("hey")
                viewSwitch = true
                if pictureTaken
                {
                    activeView = imageView
                }
                else
                {
                    activeView = cameraView
                }
            }
            if viewSwitch
            {
                //print("howdy")
                //view.addSubview(activeView!)
                view.bringSubview(toFront: activeView!)
                view.bringSubview(toFront: bottomBar)
                //activeView!.setNeedsDisplay()
                view.setNeedsDisplay()
            }
        }
        else
        {
            activeView = tableView
            view.addSubview(activeView!)
            view.bringSubview(toFront: activeView!)
            view.bringSubview(toFront: bottomBar)
            activeView!.setNeedsDisplay()
            view.setNeedsDisplay()
        }
    }
    
    func filterPopup()
    {
        let alertController = UIAlertController(title: "Filter by These Fields", message: "", preferredStyle: .alert)
        alertController.addTextField { (field: UITextField) in
            field.placeholder = "First Name"
        }
        alertController.addTextField { (field: UITextField) in
            field.placeholder = "Last Name"
        }
        alertController.addTextField { (field: UITextField) in
            field.placeholder = "Datum Description"
        }
        alertController.addTextField { (field: UITextField) in
            field.placeholder = "Begin Month"
        }
        alertController.addTextField { (field: UITextField) in
            field.placeholder = "Begin Day"
        }
        alertController.addTextField { (field: UITextField) in
            field.placeholder = "Begin Year"
        }
        alertController.addTextField { (field: UITextField) in
            field.placeholder = "End Month"
        }
        alertController.addTextField { (field: UITextField) in
            field.placeholder = "End Day"
        }
        alertController.addTextField { (field: UITextField) in
            field.placeholder = "End Year"
        }
        let action = UIAlertAction(title: "Filter", style: .default)
        { (_) in
            self.firstName = alertController.textFields![0].text!
            self.lastName = alertController.textFields![1].text!
            self.descriptionPicked = alertController.textFields![2].text!
            self.filter(alertController.textFields![3].text!, beginDay: alertController.textFields![4].text!, beginYear: alertController.textFields![5].text!, endMonth: alertController.textFields![6].text!, endDay: alertController.textFields![7].text!, endYear: alertController.textFields![8].text!)
        }
        alertController.addAction(action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {}
    }
    
    func storeData()
    {
        let alertController = UIAlertController(title: "Enter Patient Information", message: "", preferredStyle: .alert)
        alertController.addTextField { (field: UITextField) in
            field.placeholder = "First Name"
        }
        alertController.addTextField { (field: UITextField) in
            field.placeholder = "Last Name"
        }
        alertController.addTextField { (field: UITextField) in
            field.placeholder = "Datum Description"
        }
        let action = UIAlertAction(title: "Store", style: .default)
        { (_) in
            self.store(alertController)
        }
        alertController.addAction(action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {}
    }
    
    func store(_ alert: UIAlertController)
    {
        let today = Date()
        var unwrapped = alert.textFields![0].text! + ", " + alert.textFields![1].text! + ", "
        unwrapped = unwrapped + String(calcAngle) + ", " + String(describing: today)
        unwrapped = unwrapped + ", " + alert.textFields![2].text! + ", "
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0].appendingPathComponent(dataFile)
        
        var text2: String = ""
        do {
            text2 = try String(contentsOf: path, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("Error: \(error)")
        }
        unwrapped = text2 + unwrapped
        
        //writing
        do
        {
            try unwrapped.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            let alert = UIAlertController(title: "Goniometer Alpha", message: "Data Stored!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        catch {print("Noooo")}
    }
    
    @IBAction func showCamera()
    {
        pictureTaken = false
        removeAngle()
        activeView = cameraView
        view.bringSubview(toFront: activeView!)
        view.bringSubview(toFront: bottomBar)
        view.setNeedsDisplay()
        cameraView.resumeSession()
        //viewDidLoad()
    }
    
    func removeAngle()
    {
        angleOutput.text = "0.0"
        points = []
        while rectViews.count > 0
        {
            rectViews[0].removeFromSuperview()
            rectViews.remove(at: 0)
        }
        while lineViews.count > 0
        {
            lineViews[0].removeFromSuperview()
            lineViews.remove(at: 0)
        }
        currentRect = nil
    }
    
    @IBAction func showImage()
    {
        pictureTaken = true
        cameraView.captureSession.stopRunning()
        
        ///*
        activeView = imageView
        //imageView.image = self.imageCapture
        imageView.image = UIImage(named: "testImage")
        //Show the captured image to
        view.bringSubview(toFront: activeView!)
        view.bringSubview(toFront: bottomBar)
        view.setNeedsDisplay()
        activeView!.setNeedsDisplay()
        //*/
        
        
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo)
        {
            
            //Show the captured image to
            self.view.addSubview(imageView)
            // send to back so that the buttons and label are visible
            self.view.sendSubview(toBack: imageView)
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: {
                (sampleBuffer, error) in
                // These slowly convert the raw data into the image we want
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                let dataProvider = CGDataProvider(data: imageData as! CFData)
                let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                
                self.imageCapture = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                
                //Save the captured preview to image
                //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                
                self.captureSession.stopRunning()
                self.previewLayer?.removeFromSuperlayer()
                
                self.activeView = self.imageView
                //let imageView = UIImageView(image: self.imageCapture)
                self.imageView.image = self.imageCapture
                //Show the captured image to
                self.view.addSubview(self.activeView!)
                self.activeView?.setNeedsDisplay()
            })
        }
    }
    
    //Both linear regression and touchesMoved can place dots and lines
    func placeDot(_ x: CGFloat, y: CGFloat)
    {
        let rect: CGRect = CGRect(x: x-CGFloat(size/2), y: y-CGFloat(size/2), width: CGFloat(size), height: CGFloat(size))
        let square = UIView(frame: rect)
        square.backgroundColor = UIColor.cyan
        square.layer.cornerRadius = CGFloat(size/2)
        square.clipsToBounds = true
        imageView.addSubview(square)
        // arrays used to distinguish between boxes in touchesMoved
        points.append(rect)
        rectViews.append(square)
    }
    
    func placeLine(_ lineNum: Int = 0, changePos: Bool)
    {
        let x1 = points[0+lineNum].midX
        let y1 = points[0+lineNum].midY
        let x2 = points[1+lineNum].midX
        let y2 = points[1+lineNum].midY
        let d1 = pow(pow(x1-x2,2)+pow(y1-y2,2),0.5)
        let line: CGRect = CGRect(x: points[0].midX, y: points[0].midY, width: d1, height: 5)
        var angle = acos((x2-x1)/d1)
        if y1-y2 > 0
        {
            angle = acos((x1-x2)/d1)
        }
        if(!changePos)
        {
            let lineView = UIView(frame: line)
            lineView.transform = CGAffineTransform(rotationAngle: angle)
            lineView.backgroundColor = UIColor.cyan
            lineView.center = CGPoint(x: (x1+x2)/2, y: (y1+y2)/2)
            imageView.addSubview(lineView)
            lineViews.append(lineView)
        }
        else
        {
            lineViews[0+lineNum].transform = CGAffineTransform.identity
            lineViews[0+lineNum].frame = line
            lineViews[0+lineNum].transform = CGAffineTransform(rotationAngle: angle)
            lineViews[0+lineNum].center = CGPoint(x: (x1+x2)/2, y: (y1+y2)/2)
        }
    }
    
    //How you move dots around screen
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesMoved(touches, with:event)
        if let touch = touches.first
        {
            let oldTouchLocation = touch.previousLocation(in: imageView)
            let newTouchLocation = touch.location(in: imageView)
            if currentRect != nil
            {
                if points[currentRect!].contains(CGPoint(x: oldTouchLocation.x, y: oldTouchLocation.y))
                {
                    //change the frame of the current rectangle as a way to move it across the screen
                    let rect: CGRect = CGRect(x: newTouchLocation.x-10, y: newTouchLocation.y-10, width: 20, height: 20)
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with:event)
        if touches.first != nil
        {
            currentRect = nil
        }
    }
    
    
    //Setting the 3 points
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if activeView! == imageView
        {
            super.touchesBegan(touches, with:event)
            if let touch = touches.first
            {
                let touchLocation = touch.location(in: imageView)
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
                        if points[index].contains(CGPoint(x: touchLocation.x, y: touchLocation.y))
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
        let x1 = points[0].midX
        let y1 = points[0].midY
        let x2 = points[1].midX
        let y2 = points[1].midY
        let x3 = points[2].midX
        let y3 = points[2].midY
        
        let d1 = pow(pow(x1-x2,2)+pow(y1-y2,2),0.5)
        let d2 = pow(pow(x2-x3,2)+pow(y2-y3,2),0.5)
        let d3 = pow(pow(x3-x1,2)+pow(y3-y1,2),0.5)
        
        calcAngle = Double(round(acos((pow(d1,2)+pow(d2,2)-pow(d3,2))/(2*d1*d2))*180/3.14159*10)/10)
        angleOutput.text = "\(calcAngle)"
    }
    
    
    
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showImageView"
        {
            // Specify what type of output this will receive
            if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo)
            {
                stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                    (sampleBuffer, error) in
                    // These slowly convert the raw data into the image we want
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    
                    self.imageCapture = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    
                    //Save the captured preview to image
                    //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    
                    // Allows the two Controllers to "talk" to each other
                    let destViewController: ImageController = segue.destinationViewController as! ImageController
                    destViewController.photo = self.imageCapture!
                    //let photo = UIImage(named: "testImage")
                    //destViewController.photo = photo
                    destViewController.viewDidLoad()
                })
            }
        }
    }
    */
}

