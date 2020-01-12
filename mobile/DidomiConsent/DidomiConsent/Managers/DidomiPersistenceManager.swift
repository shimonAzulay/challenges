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
    func persisteConsentStatus(consentStatus: String) {
        let defaults = UserDefaults.standard
        defaults.set(consentStatus, forKey: DidomiConstants.Persistence.PersistenceConsentStatusKey)
        defaults.synchronize()
        DidomiLogManager.shared.log(logMessage: "\(DidomiConstants.Persistence.ConsentPersisted) \(consentStatus)")
    }
    
    /**
     Retrive persistent consent status string.
     - Returns: Persistent consent status string.
     */
    func retriveConsentStatus() -> String {
        let defaults = UserDefaults.standard
        let consentStatus = defaults.string(forKey: DidomiConstants.Persistence.PersistenceConsentStatusKey) ?? DidomiConstants.ConsentStatusStrings.Undefined
        defaults.synchronize()
        DidomiLogManager.shared.log(logMessage: "\(DidomiConstants.Persistence.ConsentRetrived) \(consentStatus)")
        
        return consentStatus
    }
    
    
    // MARK - private methods
     
     private override init() {
         super.init()
     }

}
