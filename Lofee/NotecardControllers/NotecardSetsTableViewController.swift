//
//  NotecardSetsTableViewController.swift
//  Design
//
//  Created by 65,115,114,105,116,104,98 on 8/12/20.
//  Copyright © 2020 Asritha Bodepudi. All rights reserved.
//

import StoreKit
import UIKit
import UserNotifications
import RealmSwift
import GoogleMobileAds
enum AppStoreReviewManager {
  static func requestReviewIfAppropriate() {
    SKStoreReviewController.requestReview()
  }
}

class NotecardSetsTableViewController: UITableViewController, GADRewardedAdDelegate {
//Variables
   
    let realm = try! Realm()
    var notecardSets: Results<Set>?
    var notecardSetImages: [UIImage] = []
    let viewNotecardSetViewControllerObject = ViewNotecardSetViewController()
    var rewardedAd: GADRewardedAd?

    @IBOutlet weak var createNewSetButton: UIButton!
    
//View Heirarchy Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "NotecardSetCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "NotecardSetCell")
        if notecardSets?.count ?? 0 == 2 || notecardSets?.count ?? 0 == 5 || notecardSets?.count ?? 0 == 10{
            AppStoreReviewManager.requestReviewIfAppropriate()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        notecardSets = realm.objects(Set.self)
        tableView.reloadData()
        configureAppearance()
    }

    //Segue Methods
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
          performSegue(withIdentifier: "goToNewSetViewController", sender: send)
    }
    @IBAction func newSetButtonPressed(_ sender: UIButton) {
        if notecardSets != nil{
            if notecardSets!.count > 2 && notecardSets!.count % 2 != 0{
                let alertController = UIAlertController(title: "Watch short video ad to create new set?", message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
                    
                    self.rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
                    self.rewardedAd?.load(GADRequest()) { error in
                        if error != nil {
                            // Handle ad failed to load case.
                        } else {
                            if self.rewardedAd?.isReady == true {
                                self.rewardedAd?.present(fromRootViewController: self, delegate:self)
                            }
                        }
                    }
                }
                let cancelAction = UIAlertAction(title: "Back", style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                    print ("Back")
                }
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                performSegue(withIdentifier: "goToNewSetViewController", sender: send)
            }
        }
    }
    @IBAction func unwindToViewControllerA(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToViewNotecardSet"){
            let destinationVC = segue.destination as! ViewNotecardSetViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedNotecardSet = notecardSets?[indexPath.row]
            }
        }
    }
    
//Appearance Methods
    func configureAppearance(){
        tabBarController?.tabBar.backgroundColor = #colorLiteral(red: 0.9684234262, green: 0.9680920243, blue: 1, alpha: 1)
        
        //Table View Appearance
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 1.00, alpha: 1.00)
        
        //Navigation Bar Appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 1.00, alpha: 1.00)
        navBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        
        //Navigation Bar Items
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Notecard Sets"
        label.textColor = UIColor(red: 0.12, green: 0.22, blue: 0.47, alpha: 1.00)
        label.font = UIFont(descriptor: UIFontDescriptor(name: "Avenir Next Bold", size: 25), size: 25)
        navigationItem.titleView = label
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: Any?.self, action: nil)
        
        //CreateNewSetButton Appearnace
        createNewSetButton.layer.cornerRadius = 18
    }
}

//MARK: - Table View Datasource Methods

extension NotecardSetsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notecardSets?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotecardSetCell", for: indexPath) as! NotecardSetCell
        cell.notecardSetNameLabel.text = notecardSets?[indexPath.row].name
        notecardSetImages = [#imageLiteral(resourceName: "RedNotecardSet"), #imageLiteral(resourceName: "BlueNotecardSet"), #imageLiteral(resourceName: "YellowNotecardSet"), #imageLiteral(resourceName: "LightBlueNotecardSet")]
        cell.notecardSetImage.image = notecardSetImages[(notecardSets?[indexPath.row].colorNumber)!]
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         return true
     }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToViewNotecardSet", sender: self)
    }
    
    //Delete Functionality
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            if let categoryForDeletetion = self.notecardSets?[indexPath.row]{
                do {
                    try self.realm.write{
                        for notecard in categoryForDeletetion.notecards{
                            self.realm.delete(notecard)
                        }
                        self.realm.delete(categoryForDeletetion)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
                catch{
                    print (error)
                }
            }
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
    
    
}
