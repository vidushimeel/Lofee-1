//
//  SeeQuestionsAnsweredViewController.swift
//  Design
//
//  Created by 65,115,114,105,116,104,98 on 8/27/20.
//  Copyright © 2020 Asritha Bodepudi. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class SeeQuestionsAnsweredViewController: UIViewController {
    let defaults = UserDefaults(suiteName: "group.com.Tonnelier.Lofee")
    @IBOutlet weak var tableView: UITableView!
    var allSets: Results<Set>?
    var selectedSet: Results<Notecard>?
    let realm = try! Realm()
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "NotecardCellDoneOrNot", bundle:
            nil)
        self.tableView.register(nib, forCellReuseIdentifier: "NotecardCellDoneOrNot")
        self.tableView.tableFooterView = UIView()
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 1.00, alpha: 1.00)
        
        bannerView.rootViewController = self
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.load(GADRequest())
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
        allSets = realm.objects(Set.self)
        
        if (defaults?.object(forKey: "setPickedToBeStudied") != nil){
            if let count = self.allSets?.count{
                for index in 0..<count{
                    if (self.allSets![index].name) == (self.defaults?.object(forKey: "setPickedToBeStudied") as! String){
                        selectedSet = allSets![index].notecards.sorted(byKeyPath: "dateCreated", ascending: true)
                    }
                }
            }
        }
    }
}


//MARK: - Table View Data Source

extension SeeQuestionsAnsweredViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedSet?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotecardCellDoneOrNot", for: indexPath) as! NotecardCellDoneOrNot
        if let notecard = selectedSet?[indexPath.row]{
            cell.questionTextView?.text = notecard.question
            cell.answerTextView?.text = notecard.answer
            cell.questionTextView.isUserInteractionEnabled = false
            cell.answerTextView.isUserInteractionEnabled = false
        }
        
        if let questionArray: [String] = defaults?.object(forKey: "questionArray") as? [String]{
            for question in questionArray{
                if question == cell.questionTextView?.text{
                    cell.imageIcon.image = UIImage(systemName: "xmark.circle.fill")
                    cell.imageIcon.tintColor = #colorLiteral(red: 0.9874878526, green: 0.1261097789, blue: 0.1475940645, alpha: 1)
                }
            }
        }
    
     
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
