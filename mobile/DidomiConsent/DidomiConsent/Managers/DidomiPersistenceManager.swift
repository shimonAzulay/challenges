//
//  DidomiPersistenceManager.swift
//  DidomiConsents
//
//  Created by Shimon Azulay on 10/01/2020.
//  Copyright © 2020 shimon.azulay. All rights reserved.
//

class DidomiPersistenceManager: NSObject {
    
    // MARK - API
    static let shared = DidomiPersistenceManager()
    
    // Null check or optional
    func persisteConsent(consentStatus: String) {
        let defaults = UserDefaults.standard
        defaults.set(consentStatus, forKey: DidomiConstants.Persistence.PersistenceConsentStatusKey)
        defaults.synchronize()
    }
    
    // Null check or optional
    func retriveConsent() -> String {
        let defaults = UserDefaults.standard
        let consentStatus = defaults.string(forKey: DidomiConstants.Persistence.PersistenceConsentStatusKey) ?? DidomiConstants.ConsentStatusStrings.Undefined
        defaults.synchronize()
        
        return consentStatus
    }
    
    
    // MARK - private methods
     
     private override init() {
         super.init()
     }

}
