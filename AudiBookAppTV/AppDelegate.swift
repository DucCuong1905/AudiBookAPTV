//
//  AppDelegate.swift
//  AudiBookAppTV
//
//  Created by Nguyen Van Tinh on 9/10/20.
//  Copyright © 2020 Nguyen Van Tinh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func copyFileToDocumentsFolder(nameForFile: String, extForFile: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destURL = documentsURL!.appendingPathComponent(nameForFile).appendingPathExtension(extForFile)
        guard let sourceURL = Bundle.main.url(forResource: nameForFile, withExtension: extForFile)
            else {
                print("Source File not found.")
                return
        }
        let fileManager = FileManager.default
        do {
            try fileManager.copyItem(at: sourceURL, to: destURL)
        } catch {
            print("Unable to copy file")
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       let docName = "Book"
       let docExt = "db"
       copyFileToDocumentsFolder(nameForFile: docName, extForFile: docExt)
        
        return true
    }
   

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


}

