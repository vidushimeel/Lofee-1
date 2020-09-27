//
//  NewNotecardSetViewController.swift
//  Lofee
//
//  Created by 65,115,114,105,116,104,98 on 9/14/20.
//  Copyright © 2020 Asritha Bodepudi. All rights reserved.
//

import UIKit
import RealmSwift
class NewNotecardSetViewController: UIViewController {
    
    //IF THIS WORKS, DO SAVING SET ALERTS POP METHOD AS WELL
    let newNotecardSetRealm = try! Realm()
    var newNotecardSetTableView = UITableView()
    var set: Set?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     hideKeyboardWhenUserTapsElsewhereOnScreen()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func addNewNotecard(){
        let newNotecard = Notecard()
        do {
            try newNotecardSetRealm.write{
                set?.notecards.append(newNotecard)
            }
        }
        catch {
            print (error)
        }
        newNotecardSetTableView.reloadData()
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: (self.set?.notecards.count)!-1, section: 0)
            self.newNotecardSetTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    func tableViewConfiguration(){
        //Table view settings
        let nib = UINib(nibName: "NotecardCell", bundle: nil)
        self.newNotecardSetTableView.register(nib, forCellReuseIdentifier: "NotecardCell")
        self.newNotecardSetTableView.dataSource = self
        self.newNotecardSetTableView.tableFooterView = UIView()
        self.newNotecardSetTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.newNotecardSetTableView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 1.00, alpha: 1.00)
    }
}
// MARK: - Table view data source
extension NewNotecardSetViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return set?.notecards.count ?? 0
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotecardCell", for: indexPath) as! NotecardCell
        cell.questionTextView.delegate = self
        cell.questionTextView.accessibilityIdentifier = "questionTextView"
        cell.answerTextView.delegate = self
        cell.answerTextView.accessibilityIdentifier = "answerTextView"
        
        if (set?.notecards.count != 0){
            if set?.notecards[indexPath.row].question != ""{
                cell.questionTextView.text = set?.notecards[indexPath.row].question
                cell.questionTextView.textColor = #colorLiteral(red: 0.05009972304, green: 0.1518454254, blue: 0.4186728597, alpha: 1)
                
            }
            else {
                cell.questionTextView.text = "Enter Question Here"
                cell.questionTextView.textColor = UIColor.gray
                
            }
            if set?.notecards[indexPath.row].answer != ""{
                cell.answerTextView.text = set?.notecards[indexPath.row].answer
                cell.answerTextView.textColor = #colorLiteral(red: 0.05009972304, green: 0.1518454254, blue: 0.4186728597, alpha: 1)
                
            }
            else {
                cell.answerTextView.text = "Enter Answer Here"
                cell.answerTextView.textColor = UIColor.gray
                
            }
        }
        return cell
    }
      //Delete Functionality
      func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if (editingStyle == .delete) {
            if (self.set?.notecards[indexPath.row]) != nil{
                  do {
                      try self.newNotecardSetRealm.write{ //realm.write commits some changes to Realm
                          set?.notecards.remove(at: indexPath.row)
                          newNotecardSetTableView.deleteRows(at: [indexPath], with: .fade)
                      }
                  }
                  catch{
                      print (error) //print error if any happens instead of adding new category
                  }
              }
          }
      }
}



//MARK: - Text View Methods

extension NewNotecardSetViewController: UITextViewDelegate{
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter Answer Here" || textView.text == "Enter Question Here"{
            textView.text = ""
        }
        textView.textColor = #colorLiteral(red: 0.05009972304, green: 0.1518454254, blue: 0.4186728597, alpha: 1)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == ""
        {
            newNotecardSetTableView.reloadData()
        }
        textView.textColor = #colorLiteral(red: 0.05009972304, green: 0.1518454254, blue: 0.4186728597, alpha: 1)
        let size = textView.bounds.size
        let newSize = newNotecardSetTableView.sizeThatFits(CGSize(width: size.width,
                                                    height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            newNotecardSetTableView.beginUpdates()
            newNotecardSetTableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            let cell = UITableViewCell()
            if let thisIndexPath = newNotecardSetTableView.indexPath(for: cell) {
                newNotecardSetTableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let buttonPosition:CGPoint = textView.convert(CGPoint.zero, to:self.newNotecardSetTableView)
        if let indexPath = self.newNotecardSetTableView.indexPathForRow(at: buttonPosition){
            do {
                try! newNotecardSetRealm.write {
                    if textView.accessibilityIdentifier == "questionTextView"{
                        set?.notecards[indexPath[1]].question = (textView.text!)
                    }
                    else if textView.accessibilityIdentifier == "answerTextView"{
                        set?.notecards[indexPath[1]].answer = (textView.text!)
                        
                    }
                }
            }
        }
        if textView.text == ""
        {
            newNotecardSetTableView.reloadData()
        }
    }
}


//MARK: - Keyboard Methods

extension NewNotecardSetViewController
{
    func hideKeyboardWhenUserTapsElsewhereOnScreen()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(CreateNewSetViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
