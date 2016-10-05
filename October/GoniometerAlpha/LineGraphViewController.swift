//
//  LineGraphViewController.swift
//  GoniometerAlpha
//
//  Created by Keshav Patel on 6/9/16.
//  Copyright © 2016 Keshav Patel. All rights reserved.
//

import UIKit

class LineGraphViewController: UIViewController
{
    
    @IBOutlet var area: UIButton!

    @IBOutlet weak var beginMonth: UITextField!
    @IBOutlet weak var beginDay: UITextField!
    @IBOutlet weak var beginYear: UITextField!
    @IBOutlet weak var endMonth: UITextField!
    @IBOutlet weak var endDay: UITextField!
    @IBOutlet weak var endYear: UITextField!
    
    @IBOutlet var graphView: GraphView!
    
    var fullData: [String] = []
    var descriptionPicked: String?
    var beginDate: NSDate?
    var endDate: NSDate?
    var firstName: String?
    var lastName: String?
    
    var angleList: [Double] = []
    var timeList: [NSDate] = []
    var descriptionList = ["Area"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        search()
        /*
        else
        {
            let alert = UIAlertController(title: "Goniometer Alpha", message: "Please search for patient data in the previous page before graphing", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
         */
        
    }
    
    @IBAction func search()
    {
        angleList = []
        timeList = []
        descriptionList = ["Area"]
        
        if(fullData.count > 1)
        {
            for entry in 0...fullData.count-2
            {
                if((fullData[entry] == firstName! || firstName! == "") && (fullData[entry+1] == lastName! || lastName! == ""))
                {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
                    let nowDate = dateFormatter.dateFromString(fullData[entry+3])
                    var isInRange = true
                    
                    if descriptionPicked != nil
                    {
                        if descriptionPicked != fullData[entry+4]
                        {
                            isInRange = false
                        }
                    }
                    if beginDate != nil
                    {
                        if beginDate!.timeIntervalSinceDate(nowDate!) > 0
                        {
                            isInRange = false
                        }
                    }
                    if endDate != nil
                    {
                        if endDate!.timeIntervalSinceDate(nowDate!) < 0
                        {
                            isInRange = false
                        }
                    }
                    
                    if isInRange
                    {
                        angleList.append(Double(fullData[entry+2])!)
                        timeList.append(nowDate!)
                    }
                    descriptionList.append(fullData[entry+4])
                }
            }
            if angleList.count < 2
            {
                let alert = UIAlertController(title: "Goniometer Alpha", message: "More than one data point is required to graph", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                angleList = graphView.graphPoints
                timeList = graphView.timePoints
            }
            else
            {
                graphView.graphPoints = angleList
                graphView.timePoints = timeList
                graphView.setNeedsDisplay()
            }
        }
        
    }
    
    @IBAction func filter()
    {
        let beginYearString = beginYear.text!
        var beginMonthString = beginMonth.text!
        var beginDayString = beginDay.text!
        if beginMonthString.count < 2
        {
            beginMonthString = "0" + beginMonthString
        }
        if beginDayString.count < 2
        {
            beginDayString = "0" + beginDayString
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        beginDate = dateFormatter.dateFromString(beginYearString+"-"+beginMonthString+"-"+beginDayString+" 00:00:00 +0000")
        
        let endYearString = endYear.text!
        var endMonthString = endMonth.text!
        var endDayString = endDay.text!
        if endMonthString.count < 2
        {
            endMonthString = "0" + endMonthString
        }
        if endDayString.count < 2
        {
            endDayString = "0" + endDayString
        }
        endDate = dateFormatter.dateFromString(endYearString+"-"+endMonthString+"-"+endDayString+" 23:59:59 +0000")
        search()
        //dataCellView.reloadData()
        //TODO: Adjust reloadData() to include begin and end dates
    }
    
    @IBAction func displayOptions()
    {
        let alertController = UIAlertController(title: "Select an Area to Narrow the Search", message: "", preferredStyle: .Alert)
        
        var displayList: [String] = []
        if descriptionList.count > 1
        {
            for i in 1 ..< descriptionList.count
            {
                if !displayList.contains(descriptionList[i])
                {
                    displayList.append(descriptionList[i])
                    let action = UIAlertAction(title: descriptionList[i], style: .Default)
                    { (_) in
                        self.descriptionPicked = self.descriptionList[i]
                        self.search()
                    }
                    alertController.addAction(action)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in}
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) {}
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
