//
//  AngleDatumCell.swift
//  GoniometerAlpha
//
//  Created by Keshav Patel on 6/3/16.
//  Copyright © 2016 Keshav Patel. All rights reserved.
//

import UIKit

class AngleDatumCell: UITableViewCell {

    @IBOutlet weak var angleValue: UITextField!
    
    public func configure(text: String?, placeholder: String) {
        angleValue.text = text
        angleValue.placeholder = placeholder
        
        angleValue.accessibilityValue = text
        angleValue.accessibilityLabel = placeholder
    }

}
