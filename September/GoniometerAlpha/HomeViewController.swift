//
//  HomeViewController.swift
//  GoniometerAlpha
//
//  Created by Keshav Patel on 8/31/16.
//  Copyright © 2016 Keshav Patel. All rights reserved.
//

import UIKit

@IBDesignable class HomeViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        let title = UIImage(named: "TitleScreen.png")!
        let resized = title.resizeImage(380)
        self.view.backgroundColor = UIColor(patternImage: resized)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
