//
//  DidomiPersistenceManager.swift
//  DidomiConsents
//
//  Created by Shimon Azulay on 10/01/2020.
//  Copyright © 2020 shimon.azulay. All rights reserved.
//

class DidomiPersistenceManager: NSObject {
    
    // MARK - API
    
    /**
    Call this to get a shared instance of DidomiPersistenceManager.
    */
    static let shared = DidomiPersistenceManager()
    
    /**
     Persiste consent status.
     - Parameter consentStatus: The consent status to persiste.
     */
    func persisteConsentStatus(consentStatus: String, forKey: String) {
        let defaults = UserDefaults.standard
        defaults.set(consentStatus, forKey: forKey)
        defaults.synchronize()
        DidomiLogManager.shared.log(logMessage: "\(DidomiConstants.Persistence.ConsentPersisted) \(consentStatus)")
    }
    
    /**
     Retrive persistent consent status string.
     - Returns: Persistent consent status string.
     */
    func retriveConsentStatus(forKey: String) -> String {
        let defaults = UserDefaults.standard
        let consentStatus = defaults.string(forKey: forKey) ?? DidomiConstants.ConsentStatusStrings.Undefined
        defaults.synchronize()
        DidomiLogManager.shared.log(logMessage: "\(DidomiConstants.Persistence.ConsentRetrived) \(consentStatus)")
        
        return consentStatus
    }
    
    
    // MARK - private methods
     
     private override init() {
         super.init()
     }

}
