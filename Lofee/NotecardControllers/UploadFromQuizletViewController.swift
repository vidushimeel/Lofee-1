//
//  UploadFromQuizletViewController.swift
//  Design
//
//  Created by 65,115,114,105,116,104,98 on 9/2/20.
//  Copyright © 2020 Asritha Bodepudi. All rights reserved.
//

import UIKit
import WebKit
import RealmSwift
import GoogleMobileAds

class UploadFromQuizletViewController: UIViewController, WKNavigationDelegate {
//IBOutlets
    @IBOutlet weak var nameOfSetTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var bannerView: GADBannerView!
    
//Variables
    let defaults = UserDefaults(suiteName: "group.com.Tonnelier.Lofee")
    let realm = try! Realm()
    var questionArray: [String] = []
    var answerArray: [String] = []
    var identifier = ""
    var text = ""
    var count = 0
    let newSet = Set()
    var notecardSets: Results<Set>?
    
//View Heirarchy Method
    override func viewDidLoad() {
        super.viewDidLoad()
        notecardSets = realm.objects(Set.self)
        
        tabBarController?.tabBar.isHidden = true
        textView.layer.cornerRadius = 18
        let titleFont: UIFont = UIFont(name: "Avenir Heavy", size: 20.0)!
        let attributes = [NSAttributedString.Key.font : titleFont]
        saveButton.setTitleTextAttributes(attributes, for: .normal)
        
        webView.navigationDelegate = self
        let url = URL(string: "https://quizlet.com/latest")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    
        
        bannerView.rootViewController = self
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.load(GADRequest())
    }
    
//Save set just created
    func showAlert(alertTitle: String, alertMessage: String, actionTitle: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if textView.text != ""{
            for (index, char) in textView.text.enumerated() {
                if index <= (textView.text.count - 4){
                    for num in index..<index+4{
                        identifier.append(textView.text[num])
                    }
                    
                    if identifier == "/q/q"{
                        count += 1
                        if count != 1{
                            text = String(text.suffix(text.count - 3))
                        }
                        questionArray.append(text)
                        text = ""
                    }
                    else if identifier == "/a/a"{
                        text = String(text.suffix(text.count - 3))
                        answerArray.append(text)
                        text = ""
                    }
                    else{
                        text.append(char)
                    }
                    identifier = ""
                }
            }
            
        }
        var sameName = false
        if notecardSets != nil{
            for set in notecardSets! {
                if nameOfSetTextField.text ?? "UNNAMED SET" == set.name{
                    sameName = true
                }
            }
        }
        if nameOfSetTextField.text == ""{
            showAlert(alertTitle: "Please enter a set name to continue", alertMessage: "", actionTitle: "Ok")
        }
        else if sameName == true{
            showAlert(alertTitle: "Please enter a different name for your set to continue", alertMessage: "One of your other sets already has the same name", actionTitle: "Ok")
        }
        else if questionArray.count == 0{
            showAlert(alertTitle: "Please enter some set data (properly) in the purple box to continue", alertMessage: "Please make sure any data is formatted correctly - click on the question mark for more instructions", actionTitle: "Ok")
        }
        else{
            newSet.name = nameOfSetTextField.text ?? "UNNAMED SET"
            for counter in 0...(questionArray.count-1){
                let newNotecard = Notecard()
                newNotecard.dateCreated = Date()
                newNotecard.question = questionArray[counter]
                newNotecard.answer = answerArray[counter]
                do {
                    try realm.write{
                        newSet.notecards.append(newNotecard)
                        realm.add(newSet)
                    }
                }
                catch {
                    print (error)
                }
            }
            //Color of set rotation
            if defaults?.integer(forKey: "colorCounter") == nil || defaults?.integer(forKey: "colorCounter") == 4{
                defaults?.set(0, forKey: "colorCounter")
            }
            if let colorNumber = defaults?.integer(forKey: "colorCounter"){
                newSet.colorNumber = colorNumber
                let colorCounter = colorNumber + 1
                defaults?.set(colorCounter, forKey: "colorCounter")
            }
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
    
   

    
}




extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence { self[index(startIndex, offsetBy: range.lowerBound)...] }
    subscript(range: PartialRangeThrough<Int>) -> SubSequence { self[...index(startIndex, offsetBy: range.upperBound)] }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence { self[..<index(startIndex, offsetBy: range.upperBound)] }
}
