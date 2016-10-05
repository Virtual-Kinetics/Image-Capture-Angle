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
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if (indexPath as NSIndexPath).row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell") as! DescriptionCell
            cell.configure("", placeholder: "First Name")
            return cell
        }
        else if (indexPath as NSIndexPath).row == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LastNameCell") as! DescriptionCell
            cell.configure("", placeholder: "Last Name")
            return cell
        }
        else if (indexPath as NSIndexPath).row == 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AngleCell") as! DescriptionCell
            cell.configure(String(angle), placeholder: String(angle))
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell") as! DescriptionCell
            cell.configure("", placeholder: "Description")
            return cell
        }
    }
    
    @IBAction func storeData()
    {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! DescriptionCell
        let lastCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! DescriptionCell
        let angleCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! DescriptionCell
        let descriptionCell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! DescriptionCell
        let today = Date()
        var unwrapped = cell.field.text! + ", " + lastCell.field.text! + ", "
        unwrapped = unwrapped + angleCell.field.text! + ", " + String(describing: today)
        unwrapped = unwrapped + ", " + descriptionCell.field.text! + ", "
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0].appendingPathComponent("goniometerDataAugust2.csv")
        
        var text2: String = ""
        do
        {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

}
