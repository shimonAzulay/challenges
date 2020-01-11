//
//  DidomiVisualConsent.swift
//  DidomiConsents
//
//  Created by Shimon Azulay on 10/01/2020.
//  Copyright © 2020 shimon.azulay. All rights reserved.
//

import UIKit

class DidomiVisualConsentManager: NSObject {
    
    // MARK - API
    
    static let shared = DidomiVisualConsentManager()
    
    var window: UIWindow?
    
    func showConsent(consent: DidomiConsent, callback: @escaping (_ status: DidomiConsentStatus) -> ()) {
        let alert = UIAlertController(title: consent.consentTitle, message: consent.consentMassage, preferredStyle: .alert)
                
        let acceptAction = UIAlertAction(title: DidomiConstants.ConsentDialog.AcceptButtonText, style: .default) { (action: UIAlertAction) in
            callback(.Accept)
            self.closeConsentWindow()
        }
        let denyAction = UIAlertAction(title: DidomiConstants.ConsentDialog.DenyButtonText, style: .default) { (action: UIAlertAction) in
            callback(.Deny)
            self.closeConsentWindow()
        }
        
        alert.addAction(acceptAction)
        alert.addAction(denyAction)
           
        prepareConsentWindow()
        // TODO - check errors
        window?.rootViewController?.present(alert, animated: true)
        
    }
    
    // MARK - private methods
    
    private override init() {
        super.init()
    }
    
    func prepareConsentWindow() {
        
        if #available(iOS 13, *) {
            let windowScenes = UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }
            if let windowScene = windowScenes.first as? UIWindowScene {
                window = UIWindow(windowScene: windowScene)
            }
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
        }

        window?.backgroundColor = .clear
        window?.windowLevel = .alert
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
    }
    
    func closeConsentWindow() {
        window?.isHidden = true
        window = nil
    }
    
    
}
