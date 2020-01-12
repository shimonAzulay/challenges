//
//  MyCustomConsentManager.swift
//  TestAppIOS9
//
//  Created by Shimon Azulay on 12/01/2020.
//  Copyright © 2020 shimon.azulay. All rights reserved.
//

import UIKit
import DidomiConsent

class MyCustomConsentManager: DidomiConsentManager {
    
    static var viewController: UIViewController?
    
    override class func showConsent() {
        
       let alert = UIAlertController(title: "My custom consent", message: "This application will access your photos", preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "ACCEPT", style: .default) { (action: UIAlertAction) in
            setConsentStatus(status: .Accept)
        }
        let denyAction = UIAlertAction(title: "DENY", style: .default) { (action: UIAlertAction) in
            setConsentStatus(status: .Deny)
        }
        
        alert.addAction(acceptAction)
        alert.addAction(denyAction)
        
        DispatchQueue.main.async {
            viewController?.present(alert, animated: true)
        }
    }
    
    override class func setConsentStatus(status: DidomiConsentStatus) {
        print("Custom set consent status")
        super.setConsentStatus(status: status)
    }
    
    override class func getConsentStatus() -> DidomiConsentStatus {
        print("Custom get consent status")
        return super.getConsentStatus()
    }
}
