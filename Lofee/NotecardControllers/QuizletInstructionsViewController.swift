//
//  QuizletInstructionsViewController.swift
//  Design
//
//  Created by 65,115,114,105,116,104,98 on 9/9/20.
//  Copyright © 2020 Asritha Bodepudi. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class QuizletInstructionsViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        let url = URL(string: "https://www.youtube.com/watch?v=J3SmEu9xcHQ&feature=youtu.be")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        bannerView.rootViewController = self
        bannerView.adUnitID = "ca-app-pub-1093493132842059/6694089687"
        bannerView.load(GADRequest())
    }
    
}
