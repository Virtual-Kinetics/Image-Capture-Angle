//
//  DataView.swift
//  GoniometerAlpha
//
//  Created by Keshav Patel on 9/14/16.
//  Copyright © 2016 Keshav Patel. All rights reserved.
//

import UIKit
import Foundation

class DataView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{
    @IBOutlet var dataCellView: UICollectionView!
    var numberOfRows = 0
    //var firstNameList: [String] = []
    //var lastNameList: [String] = []
    var timeList: [Date] = []
    var descriptionList: [String] = []
    var angleList: [Double] = []
    var descriptionPicked: String?
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        //dataCellView.reloadData()
    }
    */
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        dataCellView.backgroundColor = UIColor.white
        numberOfRows = angleList.count + 1
        //print(numberOfRows)
        return numberOfRows * 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let screenSize = dataCellView.frame
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        return CGSize(width: screenWidth/3, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //dataCellView.backgroundColor = UIColor.whiteColor()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let i = Int(floor(Double((indexPath as NSIndexPath).item/3)))-1
        //print(i)
        if (indexPath as NSIndexPath).item%3 == 0
        {
            //print("1")
            if i > -1
            {
                cell.field.text = NSString(string: String(describing: timeList[i])).substring(to: 10)
            }
            else
            {
                cell.field.text = "Date"
            }
        }
        else if (indexPath as NSIndexPath).item%3 == 1
        {
            //print("2")
            if descriptionPicked != nil && i > 0 && descriptionPicked != ""
            {
                cell.field.text = descriptionPicked
            }
            else if i == -1
            {
                cell.field.text = "Part"
            }
            else
            {
                cell.field.text = descriptionList[i]
            }
        }
        else if (indexPath as NSIndexPath).item%3 == 2
        {
            //print("3")
            if i == -1
            {
                cell.field.text = "Angle"
            }
            else
            {
                cell.field.text = String(angleList[i])
            }
        }
        
        /*
        if i == -1
        {
        cell.field.font = cell.field.font!.fontWithSize(20)
        }
        */
        
        cell.field.isUserInteractionEnabled = false;
        cell.field.textAlignment = .center
        cell.frame = CGRect(x: 150*CGFloat((indexPath as NSIndexPath).item%3)+5, y: CGFloat(i+1)*50, width: 150, height: 50)
        //print(cell)
        return cell
    }
}
