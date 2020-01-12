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
    
    /**
    Call this to get a shared instance of DidomiVisualConsentManager.
    */
    static let shared = DidomiVisualConsentManager()
    
    /**
     Show consent dialog to user.
     - Important: This method will be run async on main thread.
     - Parameter consent: The consent to show.
     - Parameter callback: The consent status given by the user.
     */
    func showConsentDialog(consent: DidomiConsent, callback: @escaping (_ status: DidomiConsentStatus) -> ()) {
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
        
        DispatchQueue.main.async {
            self.prepareConsentWindow()
                // TODO check errors
            self.window?.rootViewController?.present(alert, animated: true)
        }
    }
    
    // MARK - private methods
    
    private override init() {
        super.init()
    }
    
    func prepareConsentWindow() {
        // TODO test it.
        // Check for scenes
        if #available(iOS 13, *) {
            let windowScenes = UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }
            if let windowScene = windowScenes.first as? UIWindowScene {
                window = UIWindow(windowScene: windowScene)
            } else {
                // No scenes found
                 window = UIWindow(frame: UIScreen.main.bounds)
            }
        } else {
            // In case of iOS version < 13.
            window = UIWindow(frame: UIScreen.main.bounds)
        }

        window?.backgroundColor = .clear
        window?.windowLevel += 1
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
    }
    // TODO this is the best way?
    func closeConsentWindow() {
        window?.isHidden = true
        window = nil
    }
    
    // MARK - attributes
    
    var window: UIWindow?
    
    
}
