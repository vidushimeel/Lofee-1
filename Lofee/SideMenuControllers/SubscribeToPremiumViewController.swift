//
//  SubscribeToPremiumViewController.swift
//  Lofee
//
//  Created by 65,115,114,105,116,104,98 on 9/25/20.
//  Copyright © 2020 Asritha Bodepudi. All rights reserved.
//

import UIKit
import StoreKit
import SystemConfiguration

class SubscribeToPremiumViewController: UIViewController, SKPaymentTransactionObserver {
    
let productID = "RemoveAds"
    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
      
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBAction func purchaseButtonPressed(_ sender: UIButton) {
        if SKPaymentQueue.canMakePayments(){
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        }
        else{
            
        }
    }
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased{
                //User payment successful
                print ("Transaction successful")
            }
            else if transaction.transactionState == .failed{
                //Payment Failed
                print ("Transaction failed")
                
            }
        }
    }
    
    
}
