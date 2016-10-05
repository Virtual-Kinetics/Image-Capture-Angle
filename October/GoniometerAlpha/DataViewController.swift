//
//  DataViewController.swift
//  GoniometerAlpha
//
//  Created by Keshav Patel on 6/4/16.
//  Copyright © 2016 Keshav Patel. All rights reserved.
//

import UIKit
import Foundation

extension String
{
    var count: Int
    {
        return characters.count
    }
}

class DataViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{
    
    var numberOfRows = 0
    var fullText: [String] = []
    var firstNameList: [String] = ["First Name"]
    var lastNameList: [String] = ["Last Name"]
    var angleList: [String] = ["Angle"]
    var timeList: [String] = ["Date"]
    var descriptionList: [String] = ["Area"]
    var descriptionPicked: String?
    @IBOutlet var dataCellView: UICollectionView!
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    
    @IBOutlet var beginMonth: UITextField!
    @IBOutlet var beginDay: UITextField!
    @IBOutlet var beginYear: UITextField!
    @IBOutlet var endMonth: UITextField!
    @IBOutlet var endDay: UITextField!
    @IBOutlet var endYear: UITextField!
    @IBOutlet var filterButton: UIButton!
    
    var beginDate: Date?
    var endDate: Date?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        dataCellView.dataSource = self;
        dataCellView.delegate = self;
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0].appendingPathComponent("goniometerDataAugust2.csv")
        
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
        firstNameList = ["First Name"]
        lastNameList = ["Last Name"]
        angleList = ["Angle"]
        timeList = ["Date"]
        descriptionList = ["Area"]
        let firstText = firstNameField.text
        let lastText = lastNameField.text
        if (firstText == nil || firstText == "") && (lastText == nil || lastText == "")
        {
            let alert = UIAlertController(title: "Goniometer Alpha", message: "A name must be given to search", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if(fullText.count > 1)
        {
            let firstNameSearch = firstText!.lowercased().trimmingCharacters(in: CharacterSet.whitespaces)
            let lastNameSearch = lastText!.lowercased().trimmingCharacters(in: CharacterSet.whitespaces)
            for entry in 0...fullText.count-4
            {
                if((fullText[entry].lowercased() == firstNameSearch || firstNameSearch == "") && (fullText[entry+1].lowercased() == lastNameSearch || lastNameSearch == ""))
                {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
                    let nowDate = dateFormatter.date(from: fullText[entry+3])
                    var isInRange = true

                    if descriptionPicked != nil
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
                        angleList.append(fullText[entry+2])
                        timeList.append(fullText[entry+3])
                    }
                    descriptionList.append(fullText[entry+4])
                }
            }
            dataCellView.reloadData()
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
        
        let endYearString = endYear.text!
        var endMonthString = endMonth.text!
        var endDayString = endDay.text!
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
        dataCellView.reloadData()
        //TODO: Adjust reloadData() to include begin and end dates
    }
    
    @IBAction func displayOptions()
    {
        let alertController = UIAlertController(title: "Select an Area to Narrow the Search", message: "", preferredStyle: .alert)

        var displayList: [String] = []
        if descriptionList.count > 1
        {
            for i in 1 ..< descriptionList.count
            {
                if !displayList.contains(descriptionList[i])
                {
                    displayList.append(descriptionList[i])
                    let action = UIAlertAction(title: descriptionList[i], style: .default)
                    { (_) in
                        self.descriptionPicked = self.descriptionList[i]
                        self.search()
                    }
                    alertController.addAction(action)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {}

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        numberOfRows = firstNameList.count
        //print(numberOfRows)
        return numberOfRows * 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let screenSize = dataCellView.frame
        
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        return CGSize(width: screenWidth/3, height: 50);
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        print((indexPath as NSIndexPath).item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let i = Int(floor(Double((indexPath as NSIndexPath).item/3)))
        if (indexPath as NSIndexPath).item%3 == 0
        {
            if (indexPath as NSIndexPath).item > 2
            {
                cell.field.text = (timeList[i] as NSString).substring(to: 10)
            }
            else
            {
                cell.field.text = timeList[i]
            }
        }
        else if (indexPath as NSIndexPath).item%3 == 1
        {
            if descriptionPicked != nil && (indexPath as NSIndexPath).item > 5
            {
                cell.field.text = descriptionPicked
            }
            else
            {
                cell.field.text = descriptionList[i]
            }
        }
        else if (indexPath as NSIndexPath).item%3 == 2
        {
            cell.field.text = angleList[i]
        }
        /*
        if indexPath.item < 3
        {
            cell.field.font = cell.field.font!.fontWithSize(20)
        }
        */
        
        cell.field.isUserInteractionEnabled = false;
        cell.field.textAlignment = .center
        return cell
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool
    {
        if identifier != "GraphData"
        {
            return true
        }
        if angleList.count < 3
        {
            let alert = UIAlertController(title: "Goniometer Alpha", message: "At least 2 data points must be found before graphing", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else if Set(descriptionList).count > 2 && descriptionPicked == nil
        {
            let alert = UIAlertController(title: "Goniometer Alpha", message: "Only one angle type can be graphed", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        else
        {
            return true
        }
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "GraphData"
        {
            let destViewController: LineGraphViewController = segue.destination as! LineGraphViewController
            destViewController.fullData = fullText
            destViewController.descriptionPicked = descriptionPicked
            destViewController.beginDate = beginDate
            destViewController.endDate = endDate
            destViewController.firstName = firstNameField.text
            destViewController.lastName = lastNameField.text
        }
    }
    
    func adaptivePresentationStyleForPresentationController(_ controller: UIPresentationController!) -> UIModalPresentationStyle
    {
        // Return no adaptive presentation style, use default presentation behaviour
        return .none
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
