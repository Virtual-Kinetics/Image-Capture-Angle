//
//  ImageView.swift
//  GoniometerAlpha
//
//  Created by Keshav Patel on 9/22/16.
//  Copyright © 2016 Keshav Patel. All rights reserved.
//

import UIKit

class ImageView: UIView {
    
    var image: UIImage?
    var view: UIImageView?
    
    override func draw(_ rect: CGRect)
    {
        if image != nil
        {
            if view != nil
            {
                view!.removeFromSuperview()
            }
            view = UIImageView(image: image)
            let screenSize: CGRect = frame
            view!.frame = CGRect(x:0, y:0, width:screenSize.width, height:screenSize.height)
            addSubview(view!)
            sendSubview(toBack: view!)
        }
    }
}
