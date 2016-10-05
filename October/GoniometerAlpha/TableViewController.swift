//
//  TableViewController.swift
//  GoniometerAlpha
//
//  Created by Keshav Patel on 6/2/16.
//  Copyright © 2016 Keshav Patel. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    
    @IBOutlet var storeButton: UIButton!
    @IBOutlet var tableView: UITableView!
    var angle = 0.0
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("NameCell") as! DescriptionCell
            cell.configure("", placeholder: "First Name")
            return cell
        }
        else if indexPath.row == 1
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("LastNameCell") as! DescriptionCell
            cell.configure("", placeholder: "Last Name")
            return cell
        }
        else if indexPath.row == 2
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("AngleCell") as! DescriptionCell
            cell.configure(String(angle), placeholder: String(angle))
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("DescriptionCell") as! DescriptionCell
            cell.configure("", placeholder: "Description")
            return cell
        }
    }
    
    @IBAction func storeData()
    {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! DescriptionCell
        let lastCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! DescriptionCell
        let angleCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as! DescriptionCell
        let descriptionCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0)) as! DescriptionCell
        let today = NSDate()
        var unwrapped = cell.field.text! + ", " + lastCell.field.text! + ", "
        unwrapped = unwrapped + angleCell.field.text! + ", " + String(today)
        unwrapped = unwrapped + ", " + descriptionCell.field.text! + ", "
        
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let path = paths[0].URLByAppendingPathComponent("goniometerDataAugust2.csv")
        
        var text2: String = ""
        do
        {
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
        
        //var text2: NSString?
        //do {
        //    text2 = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        //}
        //catch {/* error handling here */}
        //print(text2!)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }

}
