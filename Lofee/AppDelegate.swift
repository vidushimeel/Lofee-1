//
//  AppDelegate.swift
//  Design
//
//  Created by 65,115,114,105,116,104,98 on 8/12/20.
//  Copyright © 2020 Asritha Bodepudi. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let defaults = UserDefaults(suiteName: "group.com.Tonnelier.Lofee")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        moveRealmFile()
        
        //defaults for minutesBetweenNotifications and frequencyOfNotifications
        if defaults?.object(forKey: "minutesBetweenNotifications") == nil {
            defaults?.set(10, forKey: "minutesBetweenNotifications")
        }
        if defaults?.object(forKey: "frequencyOfNotifications") == nil {
            defaults?.set(2.0.description, forKey: "frequencyOfNotifications")
        }
        
     
        //Action to do when app FIRST launches
        if defaults?.bool(forKey: "First Launch") == true{
            print ("Second++")
            defaults?.set(true, forKey: "First Launch")
        }
        else {
            print ("First")
            defaults?.set(true, forKey: "First Launch")
        }
        
        
        //Ask permission to send notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        //Pod settings
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        return true
    }
    
    func moveRealmFile(){
        let fileManager = FileManager.default
        let originalPath = Realm.Configuration.defaultConfiguration.fileURL!
        let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Tonnelier.Lofee")!.appendingPathComponent("default.realm")
        if fileManager.fileExists(atPath: originalPath.absoluteString) {
            do{
                try _ = fileManager.replaceItemAt(appGroupURL, withItemAt: originalPath)
                print("Successfully replaced DB file")
            }
            catch{
                print("Error info: \(error)")
            }
        } else {
            print("File is not exist on original path")
        }
        var config = Realm.Configuration()
        config.fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Tonnelier.Lofee")!.appendingPathComponent("default.realm")
        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "no location to realm file")
        
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    private func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set) {
    }
    
   
}

