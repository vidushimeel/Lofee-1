//
//  ViewNotecardSetViewController.swift
//  Design
//
//  Created by 65,115,114,105,116,104,98 on 8/20/20.
//  Copyright © 2020 Asritha Bodepudi. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class ViewNotecardSetViewController: UIViewController {
    
//IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var setNameLabel: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var bannerView: GADBannerView!
    
//Variables
    let realm = try! Realm()
    var viewNotecards: Results<Notecard>?
    var selectedNotecardSet: Set?{
        didSet{
            viewNotecards = selectedNotecardSet?.notecards.sorted(byKeyPath: "dateCreated", ascending: true)
        }
    }
    
//View Heirarchy Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "NotecardCell", bundle:
            nil)
        self.tableView.register(nib, forCellReuseIdentifier: "NotecardCell")
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 1.00, alpha: 1.00)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        setNameLabel.text = selectedNotecardSet?.name
        let titleFont: UIFont = UIFont(name: "Avenir Heavy", size: 20.0)!
        let attributes = [NSAttributedString.Key.font : titleFont]
        editButton.setTitleTextAttributes(attributes, for: .normal)
        self.tableView.reloadData()
        
        bannerView.rootViewController = self
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.load(GADRequest())
    }
    
//Segue Methods
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToEditSet", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditExistingSetViewController
        destinationVC.selectedSet = selectedNotecardSet
    }
    @IBAction func unwindToViewControllerA(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.title = self.selectedNotecardSet?.name
                self.tableView.reloadData()
                
            }
        }
    }
}


//MARK: - Table View Datasource Methods
extension ViewNotecardSetViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewNotecards?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotecardCell", for: indexPath) as! NotecardCell
        if let notecard = viewNotecards?[indexPath.row]{
            cell.questionTextView?.text = notecard.question
            cell.answerTextView?.text = notecard.answer
            cell.questionTextView.isUserInteractionEnabled = false
            cell.answerTextView.isUserInteractionEnabled = false
        }
        return cell
    }
    
}
