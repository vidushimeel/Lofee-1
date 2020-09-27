//
//  MenuTableViewController.swift
//  Lofee
//
//  Created by 65,115,114,105,116,104,98 on 9/18/20.
//  Copyright © 2020 Asritha Bodepudi. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
let slideInTouch = SlideInTouch()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        makeCorner(withRadius: 10.0)
        self.view.backgroundColor = #colorLiteral(red: 0.9684234262, green: 0.9680920243, blue: 1, alpha: 1)
    }
   
    // MARK: - Table view data source
  
    @IBAction func premiumButtonPressed(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "LofeeStudyPremium") as UIViewController
        vc.modalPresentationStyle = .fullScreen 
        self.present(vc, animated: false, completion: nil)
    }
    func makeCorner(withRadius radius: CGFloat) {
        self.view.layer.cornerRadius = radius
        self.view.layer.masksToBounds = true
        self.view.layer.isOpaque = false
    }

}
