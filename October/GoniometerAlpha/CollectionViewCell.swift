//
//  CollectionViewCell.swift
//  GoniometerAlpha
//
//  Created by Keshav Patel on 6/9/16.
//  Copyright © 2016 Keshav Patel. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var field: UITextView!
    
    func configure(text: String?, placeholder: String)
    {
        field.text = text
        field.accessibilityValue = text
        field.textAlignment = .Center
    }
    
}
