//
//  DidomiConsents.swift
//  DidomiConsents
//
//  Created by Shimon Azulay on 10/01/2020.
//  Copyright © 2020 shimon.azulay. All rights reserved.
//

import Foundation
import UIKit

/**
 Consent possible status values
 Undefined, Accept, Deny.
 */
public enum DidomiConsentStatus: String {
    case Undefined = "undefined"
    case Accept = "accept"
    case Deny = "deny"
}

public class DidomiConsentManager : NSObject {
    
    // MARK - API
    
    /**
     Call this to get a shared instance of DidomiConsentManager.
     */
    public static let shared = DidomiConsentManager()

    /**
     This method should be called on app start.
     Check status of consent. If status is Undefined
     */
    public func checkConsentStatus() {
        managerLock.lock()
        let consentStatus = DidomiPersistenceManager.shared.retriveConsentStatus()
        managerLock.unlock()
        
        if (consentStatus == DidomiConstants.ConsentStatusStrings.Undefined) {
            showConsent()
        }
    }
    
    /**
     Get consent status.
     - Returns: DidomiConsentStatus.
     */
    public func getConsentStatus() -> DidomiConsentStatus {
        var currentStatus = DidomiConsentStatus.Undefined
        managerLock.lock()
        currentStatus = consentStatus
        managerLock.unlock()
        
        return currentStatus
    }
    
    /**
     Set consent status. If the new status is diffrent than the current one, it will be presisted
     and notify BE.
     - Parameter status: The new status.
     */
    public func setConsentStatus(status: DidomiConsentStatus) {
        managerLock.lock()
        if (consentStatus != status) {
            consentStatus = status
            DidomiPersistenceManager.shared.persisteConsentStatus(consentStatus: status.rawValue)
            
            // Notify server
            DidomiNetworkManager.shared.sendConsentAsync(consentStatus: consentStatus.rawValue) { (DidomiNetworkResult) in
                // Nothing to do.
                // TODO change this to null?
            }
        }
        managerLock.unlock()
    }
    
    /**
     Show dialog consent to the user.
     This method will be run on main thread.
     */
    public func showConsent() {
        DidomiVisualConsentManager.shared.showConsentDialog(consent: consent) { (status: DidomiConsentStatus) -> () in
            self.setConsentStatus(status: status)
        }
    }

    // MARK - private methods
    
    private override init() {
        consentStatus = .Undefined
        super.init()
    }
    
    // MARK - attributs
    
    private var consentStatus: DidomiConsentStatus
    
    private let consent = DidomiConsent(consentTitle: "default", consentMassage: "default")
    
    private let managerLock = NSLock()

}
