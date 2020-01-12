//
//  ViewController.swift
//  TestAppIOS9
//
//  Created by Shimon Azulay on 12/01/2020.
//  Copyright © 2020 shimon.azulay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MyCustomConsentManager.viewController = self
        MyCustomConsentManager.checkConsentStatus()
    }

    @IBAction func getConsentStatus(_ sender: Any) {
        let alert = UIAlertController(title: "My custom consent status", message: MyCustomConsentManager.getConsentStatus().rawValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func setConsentStatusUndefined(_ sender: Any) {
        MyCustomConsentManager.setConsentStatus(status: .Undefined)
    }
    
    @IBAction func setConsentStatusAccept(_ sender: Any) {
        MyCustomConsentManager.setConsentStatus(status: .Accept)
    }
    
    @IBAction func setConsentStatusDeny(_ sender: Any) {
        MyCustomConsentManager.setConsentStatus(status: .Deny)
    }
    
    @IBAction func showConsentRequest(_ sender: Any) {
        MyCustomConsentManager.showConsent()
    }
}

