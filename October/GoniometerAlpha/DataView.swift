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
    var timeList: [NSDate] = []
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
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        dataCellView.backgroundColor = UIColor.whiteColor()
        numberOfRows = angleList.count + 1
        //print(numberOfRows)
        return numberOfRows * 3
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let screenSize = dataCellView.frame
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        return CGSize(width: screenWidth/3, height: 30)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        //dataCellView.backgroundColor = UIColor.whiteColor()
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        let i = Int(floor(Double(indexPath.item/3)))-1
        //print(i)
        if indexPath.item%3 == 0
        {
            //print("1")
            if i > -1
            {
                cell.field.text = NSString(string: String(timeList[i])).substringToIndex(10)
            }
            else
            {
                cell.field.text = "Date"
            }
        }
        else if indexPath.item%3 == 1
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
        else if indexPath.item%3 == 2
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
        
        cell.field.userInteractionEnabled = false;
        cell.field.textAlignment = .Center
        cell.frame = CGRectMake(150*CGFloat(indexPath.item%3)+5, CGFloat(i+1)*50, 150, 50)
        //print(cell)
        return cell
    }
}
