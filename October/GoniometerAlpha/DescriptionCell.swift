//
//  DescriptionCell.swift
//  GoniometerAlpha
//
//  Created by Keshav Patel on 6/4/16.
//  Copyright © 2016 Keshav Patel. All rights reserved.
//

import UIKit

class DescriptionCell: UITableViewCell
{

    @IBOutlet weak var field: UITextField!
    
    func configure(_ text: String?, placeholder: String)
    {
        field.frame = CGRect(x: 0,y: 0,width: 50,height: 25)
        field.text = text
        field.placeholder = placeholder
        
        field.accessibilityValue = text
        field.accessibilityLabel = placeholder
    }

}
