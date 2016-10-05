//
//  AppDelegate.swift
//  Goniometer Beta
//
//  Created by Keshav Patel on 5/24/16.
//  Copyright © 2016 Keshav Patel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0].appendingPathComponent("goniometerDataAugust2.csv")

        /*
        let fileManager = NSFileManager()
        do {
            try fileManager.removeItemAtPath(path.absoluteString)
        }
        catch {}
        */
        
        var text2: String = ""
        var exists = true
        do
        {
            text2 = try String(contentsOf: path, encoding: String.Encoding.utf8)
        }
        catch let error as NSError
        {
            exists = false
        }
        if !exists
        {
            let fakeDate1 = String(describing: Date(timeIntervalSinceReferenceDate: 491090000))
            let fakeDate2 = String(describing: Date(timeIntervalSinceReferenceDate: 491600000))
            let fakeDate3 = String(describing: Date(timeIntervalSinceReferenceDate: 492000100))
            let fakeDate4 = String(describing: Date(timeIntervalSinceReferenceDate: 492300000))
            let fakeDate5 = String(describing: Date(timeIntervalSinceReferenceDate: 493030000))
            let fakeDate6 = String(describing: Date(timeIntervalSinceReferenceDate: 493516800))
            let data = "Elliot, Krause, 1.4, "+fakeDate1+", arm, Elliot, Krause, 4.8, "+fakeDate2+", arm, Elliot, Krause, 12.5, "+fakeDate3+", arm, Elliot, Krause, 46.2, "+fakeDate4+", arm, Elliot, Krause, 56.8, "+fakeDate5+", arm, Elliot, Krause, 180.0, "+fakeDate6+", arm, Elliot, Krause, 26.8, "+fakeDate1+", leg, Elliot, Krause, 35.7, "+fakeDate2+", leg, Elliot, Krause, 50.3, "+fakeDate3+", leg, Elliot, Krause, 77.8, "+fakeDate4+", leg, Elliot, Krause, 84.4, "+fakeDate5+", leg, Elliot, Krause, 94.4, "+fakeDate6+", leg, Keshav, Patel, 0.91, "+fakeDate1+", arm, Keshav, Patel, 23.4, "+fakeDate2+", arm, Keshav, Patel, 27.3, "+fakeDate3+", arm, Keshav, Patel, 46.2, "+fakeDate4+", arm, Keshav, Patel, 89.1, "+fakeDate5+", arm, Keshav, Patel, 112.9, "+fakeDate6+", arm, Keshav, Patel, 37.1, "+fakeDate1+", leg, Keshav, Patel, 49.5, "+fakeDate2+", leg, Keshav, Patel, 86.1, "+fakeDate3+", leg, Keshav, Patel, 118.5, "+fakeDate4+", leg, Keshav, Patel, 147.3, "+fakeDate5+", leg, Keshav, Patel, 178.4, "+fakeDate6+", leg, "
            //let data = "Elliot, Krause, 1.4, "+fakeDate1+", arm\nElliot, Krause, 4.8, "+fakeDate2+", arm\nElliot, Krause, 12.5, "+fakeDate3+", arm\nElliot, Krause, 46.2, "+fakeDate4+", arm\nElliot, Krause, 56.8, "+fakeDate5+", arm\nElliot, Krause, 180.0, "+fakeDate6+", arm\nElliot, Krause, 26.8, "+fakeDate1+", leg\nElliot, Krause, 35.7, "+fakeDate2+", leg\nElliot, Krause, 50.3, "+fakeDate3+", leg\nElliot, Krause, 77.8, "+fakeDate4+", leg\nElliot, Krause, 84.4, "+fakeDate5+", leg\nElliot, Krause, 94.4, "+fakeDate6+", leg\nKeshav, Patel, 0.91, "+fakeDate1+", arm\nKeshav, Patel, 23.4, "+fakeDate2+", arm\nKeshav, Patel, 27.3, "+fakeDate3+", arm\nKeshav, Patel, 46.2, "+fakeDate4+", arm\nKeshav, Patel, 89.1, "+fakeDate5+", arm\nKeshav, Patel, 112.9, "+fakeDate6+", arm\nKeshav, Patel, 37.1, "+fakeDate1+", leg\nKeshav, Patel, 49.5, "+fakeDate2+", leg\nKeshav, Patel, 86.1, "+fakeDate3+", leg\nKeshav, Patel, 118.5, "+fakeDate4+", leg\nKeshav, Patel, 147.3, "+fakeDate5+", leg\nKeshav, Patel, 178.4, "+fakeDate6+", leg\n"
            let data1 = data.data(using: String.Encoding.utf8)!
            try? data1.write(to: path, options: [.atomic])
        }
        
//        var text2: String = ""
//        do {
//            text2 = try String(contentsOfURL: path, encoding: NSUTF8StringEncoding)
//        }
//        catch let error as NSError {
//            print("Error: \(error)")
//        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        /*
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let path = paths[0].URLByAppendingPathComponent("goniometerData.csv").absoluteString

        let fileManager = NSFileManager()
        do {
            try fileManager.removeItemAtPath(path)
        }
        catch {}
        */
    }


}

