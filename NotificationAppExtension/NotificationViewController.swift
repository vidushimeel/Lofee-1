//
//  NotificationViewController.swift
//  NotificationAppExtension
//
//  Created by 65,115,114,105,116,104,98 on 8/23/20.
//  Copyright © 2020 Asritha Bodepudi. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import RealmSwift
import GoogleMobileAds

class NotificationViewController: UIViewController {
    
//IBOutlets
    @IBOutlet weak var notecardButton: UIButton!
    @IBOutlet weak var rightToggle: UISwitch!
    @IBOutlet weak var didYouAnswerCorrectlyTextLabel: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
//Variables
    let defaults = UserDefaults(suiteName: "group.com.Tonnelier.Lofee")
    var realm: Realm?
    var allSets: Results<Set>?
    var questionArray: [String] = []
    var answerArray: [String] = []
    var timesGotRightArray: [Int] = []
    var counter: Int?
    var numToStop: Any?
    var notecardFlipped = false
    var viewWillDisappearCounter = 0

//View Hierarchy Methods
    func formatNotecardButton(){
         notecardButton.titleLabel?.textAlignment = .center
         notecardButton.titleLabel?.numberOfLines = 0
         notecardButton.titleLabel?.adjustsFontSizeToFitWidth = true
         notecardButton.titleLabel?.minimumScaleFactor = 0.5
         notecardButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
         notecardButton.layer.cornerRadius = 18
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRealm()
        allSets = realm?.objects(Set.self)
        formatNotecardButton()

        viewWillDisappearCounter = 0 //reset viewWillDisappearCounter
        rightToggle.isOn = false //by default rightToggle = to false
        
        counter = defaults?.integer(forKey: "counter")
        numToStop = defaults?.object(forKey: "frequencyOfNotifications")
        questionArray = defaults?.array(forKey: "questionArray") as! [String]
        answerArray = defaults?.array(forKey: "answerArray") as! [String]
        timesGotRightArray = defaults?.array(forKey: "timesGotRightArray") as! [Int]
        
        if questionArray.count == 0{ //if user has already answered all questions correctly
            notecardButton.backgroundColor = UIColor.clear
            rightToggle.isHidden = true
            didYouAnswerCorrectlyTextLabel.isHidden = true
            notecardButton.setTitle("You Have Finished Studying This Set 😃🎉", for: .normal)
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
        }
        else{
            if counter == nil{
                defaults?.set(0, forKey: "counter")
            }
            if counter! >= questionArray.count{
                defaults?.set(0, forKey: "counter")
            }
            counter = defaults?.integer(forKey: "counter")
            if (questionArray.count != 0){
                notecardButton.setTitle(questionArray[counter!], for: .normal)
            }
        }
        
        bannerView.rootViewController = self
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.load(GADRequest())
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        viewWillDisappearCounter += 1
        if viewWillDisappearCounter == 1{
            if rightToggle.isOn == true{
                timesGotRightArray[counter!] += 1
            }
            if numToStop as! String == String((Float(timesGotRightArray[counter!]))){
                questionArray.remove(at: counter!)
                answerArray.remove(at: counter!)
                timesGotRightArray.remove(at: counter!)
            }
            
            if let prevCounter = counter{
                defaults?.set((prevCounter + 1), forKey: "counter")
            }
            defaults?.set(questionArray, forKey: "questionArray")
            defaults?.set(answerArray, forKey: "answerArray")
            defaults?.set(timesGotRightArray, forKey: "timesGotRightArray")
        }
        
    }
    
 
//Handle flipping of notecard
    @IBAction func notecardButtonPressed(_ sender: UIButton) {
        if notecardFlipped{
            notecardFlipped = false
            notecardButton.setTitle(questionArray[counter!], for: .normal)
            
            UIView.transition(with: notecardButton, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
        else{
            notecardFlipped = true
            notecardButton.setTitle("back", for: .normal)
            notecardButton.setTitle(answerArray[counter!], for: .normal)
            
            UIView.transition(with: notecardButton, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
    }
    
//Realm
    func loadRealm(){
        let fileManager = FileManager.default
        let originalPath = Realm.Configuration.defaultConfiguration.fileURL!
        let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Tonnelier.Lofee")!.appendingPathComponent("default.realm")
        if fileManager.fileExists(atPath: originalPath.absoluteString) {
            do{
                try _ = fileManager.replaceItemAt(appGroupURL, withItemAt: originalPath)
                print("Successfully replaced DB file")
            }
            catch{
            }
        } else {
        }
        var config = Realm.Configuration()
        config.fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Tonnelier.Lofee")!.appendingPathComponent("default.realm")
        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
    }
}


//MARK: - UNNotificationContentExtension

extension NotificationViewController: UNNotificationContentExtension{
    func didReceive(_ notification: UNNotification) {
    }
}
