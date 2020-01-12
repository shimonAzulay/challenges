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
    func showConsentDialog(callback: @escaping (_ status: DidomiConsentStatus) -> ()) {
        
        if let consentTitle = loadConsentTitle(), let consentMessage = loadConsentMessage() {
            let alert = UIAlertController(title: consentTitle, message: consentMessage, preferredStyle: .alert)
             
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
                 self.window?.rootViewController?.present(alert, animated: true)
             }
        } else {
            DidomiLogManager.shared.log(logMessage: DidomiConstants.VisualConsetManager.RetriveConsentStringsError)
        }
        
 
    }
    
    // MARK - private methods
    
    private override init() {
        super.init()
    }
    
    func loadConsentTitle() -> String? {
        return loadFromLocalizable(key: DidomiConstants.VisualConsetManager.ConsentTitleKey)
    }
    
    func loadConsentMessage() -> String? {
        return loadFromLocalizable(key: DidomiConstants.VisualConsetManager.ConsentMessageKey)
    }
    
    func loadFromLocalizable(key: String) -> String? {
        var result = Bundle.main.localizedString(forKey: key, value: nil, table: nil)
        
        if result == key {
            // Key has not been found on the Localizable table, Try on Default table.
            result = Bundle.main.localizedString(forKey: key, value: nil, table: DidomiConstants.VisualConsetManager.DefaultStringsTable)
        }
        
        if result == key {
            // Key has not been found on the Default table.
            return nil
        }
        
        return result
    }
    
    func prepareConsentWindow() {
        // TODO test it.
        // Check for scenes
        if #available(iOS 13, *) {
            let windowScenes = UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }
            if let windowScene = windowScenes.first as? UIWindowScene {
                window = UIWindow(windowScene: windowScene)
            } else {
                DidomiLogManager.shared.log(logMessage: DidomiConstants.VisualConsetManager.SceneError)
                return
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

    func closeConsentWindow() {
        window = nil
    }
    
    // MARK - attributes
    
    var window: UIWindow?
    
    
}
