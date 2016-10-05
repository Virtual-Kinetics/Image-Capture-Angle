//
//  TableViewDatumCell.swift
//  GoniometerAlpha
//
//  Created by Keshav Patel on 6/2/16.
//  Copyright © 2016 Keshav Patel. All rights reserved.
//

import UIKit

class TableViewDatumCell: UITableViewCell {

    @IBOutlet weak var patientName: UITextField!
    
    public func configure(text: String?, placeholder: String) {
        patientName.text = text
        patientName.placeholder = placeholder
        
        patientName.accessibilityValue = text
        patientName.accessibilityLabel = placeholder
    }

}
