//
//  SettingsViewController.swift
//  Design
//
//  Created by 65,115,114,105,116,104,98 on 8/22/20.
//  Copyright © 2020 Asritha Bodepudi. All rights reserved.
//
import UIKit
import UserNotifications
import SystemConfiguration
import RealmSwift
import GoogleMobileAds

class SettingsViewController: UIViewController, UNUserNotificationCenterDelegate {
    //IBOutlets
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var startNotificationsToggle: UISwitch!
    @IBOutlet weak var chooseSetToStudyButton: UIButton!
    @IBOutlet weak var minutesBetweenNotificationsSlider: UISlider!
    @IBOutlet weak var numberOfRepeatTimesSlider: UISlider!
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var couchImageView: UIImageView!
    @IBOutlet weak var chooseSetToStudyLabel: UILabel!
    
//Variables
    let transparentView = UIView()
    let tableView = UITableView()
    var dataSource: [String] = []
    
    let realm = try! Realm()
    var allSets: Results<Set>?
    var selectedSet: Results<Notecard>?
    
    let defaults = UserDefaults(suiteName: "group.com.Tonnelier.Lofee")
    var questionArray: [String] = []
    var answerArray: [String] = []
    var timesGotRightArray: [Int] = []
    var notecardSetImages: [UIImage] = []
    
    var notificationsEnabled = false

//IBActions
    let transition = SlideInTouch()
 
    @IBAction func didTapButton(_ sender: UIButton) {

        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "menu") as? MenuTableViewController else {return}
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
        
    }
    
    @IBAction func chooseSetToStudyButtonPressed(_ sender: UIButton) {
        dataSource.removeAll()
        if allSets != nil{
            for set in allSets!{
                dataSource.append(set.name)
            }
        }
        
        tableView.reloadData()
        addTransparentView(frames: chooseSetToStudyButton.frame)
    }
    
    @IBAction func minutesBetweenNotificationsSliderValueChanged(_ sender: UISlider) {
        startNotificationsToggle.isOn = false
        let roundedValue = round(sender.value / 1) * 1
        sender.value = roundedValue
        defaults?.set(sender.value, forKey: "minutesBetweenNotifications")
        stopNotifications()
    }
    
    @IBAction func numberOfRepeatTimesSliderValueChanged(_ sender: UISlider) {
        startNotificationsToggle.isOn = false
        let roundedValue = round(sender.value / 1) * 1
        sender.value = roundedValue
        defaults?.set(sender.value.description, forKey: "frequencyOfNotifications")
        stopNotifications()
    }
    
//View Hierarchy Methods
    override func viewDidDisappear(_ animated: Bool) {
        tabBarController?.tabBar.backgroundColor = #colorLiteral(red: 0.9684234262, green: 0.9680920243, blue: 1, alpha: 1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
       
        allSets = realm.objects(Set.self)
        notecardSetImages = [#imageLiteral(resourceName: "ButtonRedNotecardSet"), #imageLiteral(resourceName: "ButtonBlueNotecardSet"), #imageLiteral(resourceName: "ButtonYellowNotecardSet"), #imageLiteral(resourceName: "ButtonLightBlueNotecardSet")]
        chooseSetToStudyButton.layer.cornerRadius = 18
        tabBarController?.tabBar.backgroundColor = .clear
        let modelName = UIDevice.modelName
        if modelName == "iPod Touch 6" || modelName == "iPhone 4" || modelName == "iPhone 4s" || modelName == "iPhone 5" || modelName == "iPhone 5c" || modelName == "iPhone 5s" || modelName ==  "iPhone 6" || modelName == "iPhone 6 Plus" || modelName ==  "iPhone 6s" || modelName == "iPhone 6s Plus" || modelName == "iPhone 7" || modelName == "iPhone 7 Plus" || modelName == "iPhone SE" || modelName ==  "iPhone 8" || modelName == "iPhone 8 Plus"{
            couchImageView.image = nil
        }
        
        
        if defaults?.object(forKey: "startNotificationsToggleIsOn") == nil || (startNotificationsToggle.isOn == false){
            defaults?.set(false, forKey: "startNotificationsToggleIsOn")
            stopNotifications()
        }
        startNotificationsToggle.isOn = (defaults?.bool(forKey: "startNotificationsToggleIsOn") ?? false)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.9684234262, green: 0.9680920243, blue: 1, alpha: 1)
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        let nib = UINib(nibName: "NotecardSetCell", bundle:
            nil)
        self.tableView.register(nib, forCellReuseIdentifier: "NotecardSetCell")
        
        
        bannerView.rootViewController = self
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.load(GADRequest())
        if let setBeingStudied = defaults?.object(forKey: "setPickedToBeStudied"){
            if allSets != nil{
                for set in allSets!{
                    dataSource.append(set.name)
                    if set.name == setBeingStudied as! String{
                        chooseSetToStudyButton.setTitle("", for: .normal)
                        chooseSetToStudyLabel.text = setBeingStudied as? String
                        chooseSetToStudyLabel.textColor = #colorLiteral(red: 0.193418343, green: 0.2713271025, blue: 0.4186728597, alpha: 1)
                        displayImage.image = notecardSetImages[set.colorNumber]
                    }
                }
            }
        }
        
        if let minutes = defaults?.object(forKey: "minutesBetweenNotifications"){
            minutesBetweenNotificationsSlider.setValue(minutes as? Float ?? 1.0, animated: animated)
        }
        if let frequency = defaults?.object(forKey: "frequencyOfNotifications"){
            numberOfRepeatTimesSlider.setValue((frequency as! NSString).floatValue, animated: animated)
        }
      
      
    }
 
    
}
//MARK: - UIViewControllerTransitioningDelegate

extension SettingsViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}


//MARK: - Schedule Notifications Methods
extension SettingsViewController{
    
    @IBAction func startNotificationsToggleChanged(_ sender: UISwitch) {
        if self.chooseSetToStudyButton.titleLabel?.text != ""{ //if toggled again to study same set, refill array values so can loop through entire set again instead of just showing "YOU ARE DONE" message
            if allSets != nil{
                for set in allSets!{
                    if (set.name) == (self.defaults?.object(forKey: "setPickedToBeStudied") as! String){
                        selectedSet = set.notecards.sorted(byKeyPath: "dateCreated", ascending: true)
                        displayImage.image = notecardSetImages[set.colorNumber]
                    }
                }
            }
            updateSetArrays()
        }
        
        if self.chooseSetToStudyLabel.text == ""{ //if no set has been selected, but user tried to toggle notifications
            let alert = UIAlertController(title: "Please pick a notecard set to study", message: "Notifications cannot be sent without picking a set", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            self.startNotificationsToggle.isOn = false
        }
            
        else{
            registerCategories()
            self.defaults?.set(sender.isOn , forKey: "startNotificationsToggleIsOn")
            if self.startNotificationsToggle.isOn {
                let center = UNUserNotificationCenter.current()
                let content = UNMutableNotificationContent()
                content.title = "Notification"
                content.categoryIdentifier = "NotecardNotification"
                content.sound = .default
                let time = self.defaults?.object(forKey: "minutesBetweenNotifications") as! Double * 60
                print (Int(time))
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(time), repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request)
            }
            else {
                stopNotifications()
            }
        }
    }
    
    func registerCategories(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    func stopNotifications(){
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
}



//MARK: - Table View Delegate Methods

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotecardSetCell", for: indexPath) as! NotecardSetCell
        cell.notecardSetNameLabel.text = dataSource[indexPath.row]
        let clearNotecardSetImages = [#imageLiteral(resourceName: "RedNotecardSet"), #imageLiteral(resourceName: "BlueNotecardSet"), #imageLiteral(resourceName: "YellowNotecardSet"), #imageLiteral(resourceName: "LightBlueNotecardSet")]
        cell.notecardSetImage.image = clearNotecardSetImages[(allSets?[indexPath.row].colorNumber)!]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defaults?.set(allSets?[indexPath.row].name, forKey: "setPickedToBeStudied")
        
        if self.defaults?.object(forKey: "setPickedToBeStudied") != nil{
            if let count = self.allSets?.count{
                for index in 0..<count{
                    if (self.allSets![index].name) == (self.defaults?.object(forKey: "setPickedToBeStudied") as! String){
                        selectedSet = allSets![index].notecards.sorted(byKeyPath: "dateCreated", ascending: true)
                        displayImage.image = notecardSetImages[allSets![index].colorNumber]
                    }
                }
            }
        }
        
        updateSetArrays()
        chooseSetToStudyButton.setTitle("", for: .normal)
        chooseSetToStudyLabel.text = dataSource[indexPath.row]
        chooseSetToStudyLabel.textColor = #colorLiteral(red: 0.193418343, green: 0.2713271025, blue: 0.4186728597, alpha: 1)
        
        startNotificationsToggle.isOn = false
        stopNotifications()
        
    }
}

//MARK: - Update Set Arrays
extension SettingsViewController{
    func updateSetArrays(){
           questionArray.removeAll()
           answerArray.removeAll()
           timesGotRightArray.removeAll()
           
           if let count = selectedSet?.count{
               for index in 0..<count{
                   if let question = selectedSet?[index].question{
                       questionArray.append(question)
                   }
                   if let def = selectedSet?[index].answer{
                       answerArray.append(def)
                   }
                   if (selectedSet?[index].timesGotItRight) != nil{
                       timesGotRightArray.append(0)
                   }
               }
           }
           defaults?.set(questionArray, forKey: "questionArray")
           defaults?.set(answerArray, forKey: "answerArray")
           defaults?.set(timesGotRightArray, forKey: "timesGotRightArray")
           defaults?.set(questionArray.count, forKey: "setToStudyCount")
    }

}

//MARK: -  Appearance Methods
extension SettingsViewController{
    func addTransparentView(frames: CGRect){
        tableView.reloadData()
        
        transparentView.frame = self.view.frame
        self.view.addSubview(transparentView)
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 18
        transparentView.backgroundColor = UIColor.black
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView)).self
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            var tableViewHeight: CGFloat = 0.0
            if self.dataSource.count < 3{
                tableViewHeight = CGFloat(self.dataSource.count * 90)
            }
            else{
                tableViewHeight = 300
            }
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: tableViewHeight)
        }, completion: nil)
        
    }
    
    @objc func removeTransparentView(){
        let frames = chooseSetToStudyButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
}





//MARK: - Device Extension

public extension UIDevice {
  static let modelName: String = {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    
    func mapToDevice(identifier: String) -> String {
      #if os(iOS)
      switch identifier {
      case "iPod5,1":                                 return "iPod Touch 5"
      case "iPod7,1":                                 return "iPod Touch 6"
      case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
      case "iPhone4,1":                               return "iPhone 4s"
      case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
      case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
      case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
      case "iPhone7,2":                               return "iPhone 6"
      case "iPhone7,1":                               return "iPhone 6 Plus"
      case "iPhone8,1":                               return "iPhone 6s"
      case "iPhone8,2":                               return "iPhone 6s Plus"
      case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
      case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
      case "iPhone8,4":                               return "iPhone SE"
      case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
      case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
      case "iPhone10,3", "iPhone10,6":                return "iPhone X"
      case "iPhone11,2":                              return "iPhone XS"
      case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
      case "iPhone11,8":                              return "iPhone XR"
      case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
      case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
      case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
      case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
      case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
      case "iPad6,11", "iPad6,12":                    return "iPad 5"
      case "iPad7,5", "iPad7,6":                      return "iPad 6"
      case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
      case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
      case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
      case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
      case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
      case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
      case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
      case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
      case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
      case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
      case "AppleTV5,3":                              return "Apple TV"
      case "AppleTV6,2":                              return "Apple TV 4K"
      case "AudioAccessory1,1":                       return "HomePod"
      case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
      default:                                        return identifier
      }
      #elseif os(tvOS)
      switch identifier {
      case "AppleTV5,3": return "Apple TV 4"
      case "AppleTV6,2": return "Apple TV 4K"
      case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
      default: return identifier
      }
      #endif
    }
    
    return mapToDevice(identifier: identifier)
  }()
}


