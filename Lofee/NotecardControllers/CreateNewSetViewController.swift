//
//  CreateNewSetViewController.swift
//  Lofee
//
//  Created by 65,115,114,105,116,104,98 on 9/14/20.
//  Copyright © 2020 Asritha Bodepudi. All rights reserved.
//


import UIKit
import RealmSwift
import GoogleMobileAds

class CreateNewSetViewController: NewNotecardSetViewController {
    //IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameOfSetTextField: UITextField!
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    //Variables
    let defaults = UserDefaults(suiteName: "group.com.Tonnelier.Lofee")
    let realm = try! Realm()
    var notecardSets: Results<Set>?
    let newSet = Set()
    
    
    //View Heirarchy Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initilization 
        notecardSets = realm.objects(Set.self)
        newNotecardSetTableView = tableView
        set = newSet
        
        tableViewConfiguration()
        //To configure saveButton font
        let titleFont: UIFont = UIFont(name: "Avenir Heavy", size: 20.0)!
        let attributes = [NSAttributedString.Key.font : titleFont]
        saveButton.setTitleTextAttributes(attributes, for: .normal)
        
        
        //Banner Ad
        bannerView.rootViewController = self
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.load(GADRequest())
    }
    

    
    //Add new notecard
    @IBAction func addButtonPressed(_ sender: UIButton) {
        addNewNotecard()
    }
    
    //Save set
    func showAlert(alertTitle: String, alertMessage: String, actionTitle: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        //Check if any other set has the same name
        var sameName = false
        if notecardSets != nil{
            for set in notecardSets! {
                if nameOfSetTextField.text ?? "UNNAMED SET" == set.name{
                    sameName = true
                }
            }
        }
        
        //If user has created 0 notecards
        if newSet.notecards.count < 1{
            showAlert(alertTitle: "Please create at least one notecard to continue", alertMessage: "", actionTitle: "Ok")
        }
            //If user has entered no set name
        else if nameOfSetTextField.text == ""{
            showAlert(alertTitle:  "Please enter a set name to continue", alertMessage: "", actionTitle: "Ok")
        }
            //If any other set has the same name
        else if sameName == true{
            showAlert(alertTitle: "Please enter a different name for your set to continue", alertMessage: "One of your other sets already has the same name", actionTitle: "Ok")
        }
            //Save set
        else{
            //Save set name
            newSet.name = nameOfSetTextField.text ?? "UNNAMED SET"
            //Color of set rotation
            if defaults?.integer(forKey: "colorCounter") == nil || defaults?.integer(forKey: "colorCounter") == 4{
                defaults?.set(0, forKey: "colorCounter")
            }
            if let colorNumber = defaults?.integer(forKey: "colorCounter"){
                newSet.colorNumber = colorNumber
                let colorCounter = colorNumber + 1
                defaults?.set(colorCounter, forKey: "colorCounter")
            }
            //Save to Realm
            do {
                try realm.write{
                    realm.add(newSet)
                }
            }
            catch {
                print (error)
            }
            tableView.reloadData()
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
}
