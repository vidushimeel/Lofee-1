//
//  ProgressViewController.swift
//  Design
//
//  Created by 65,115,114,105,116,104,98 on 8/12/20.
//  Copyright © 2020 Asritha Bodepudi. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class ProgressViewController: UIViewController {
    let realm = try! Realm()
      var allSets: Results<Set>?
      let defaults = UserDefaults(suiteName: "group.com.Tonnelier.Lofee")
    @IBOutlet weak var circleProgress: CircleProgressBarView!
    @IBOutlet weak var seeQuestionsAnsweredCorrectlyButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seeQuestionsAnsweredCorrectlyButton.layer.cornerRadius = 18
        
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        allSets = realm.objects(Set.self)
        circleProgress.setNeedsDisplay()
        if let count =  defaults?.integer(forKey: "setToStudyCount"){
              if let selectedSet = defaults?.object(forKey: "questionArray"){ 
                  let set:[String] = selectedSet as! [String]
                print (count)
                print (set)
                seeQuestionsAnsweredCorrectlyButton.setTitle( "\(String((Int(count - set.count)))) Questions Answered Correctly", for: .normal)
              }
          }
        else{
            seeQuestionsAnsweredCorrectlyButton.setTitle("See Questions Answered Correctly", for: .normal)
        }
        bannerView.rootViewController = self
              bannerView.adUnitID = "ca-app-pub-1093493132842059/6694089687"
              bannerView.load(GADRequest())
    }
}
