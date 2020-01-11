//
//  DidomiConsents.swift
//  DidomiConsents
//
//  Created by Shimon Azulay on 10/01/2020.
//  Copyright © 2020 shimon.azulay. All rights reserved.
//

import Foundation
import UIKit

public enum DidomiConsentStatus: String {
    case Undefined = "undefined"
    case Accept = "accept"
    case Deny = "deny"
}

public class DidomiConsentManager : NSObject {
    
    // MARK - API
    
    public static let shared = DidomiConsentManager()

    public func checkConsentStatus() {
        let consentStatus = DidomiPersistenceManager.shared.retriveConsent()
        if (consentStatus == DidomiConstants.ConsentStatusStrings.Undefined) {
            showConsent()
        }
    }
    
    public func getConsentStatus() -> DidomiConsentStatus {
        return currentConsent.consentStatus
    }
    
    public func setConsentStatus(status: DidomiConsentStatus) {
        if (currentConsent.consentStatus != status) {
            currentConsent.consentStatus = status
            DidomiPersistenceManager.shared.persisteConsent(consentStatus: status.rawValue)
            
            // Notify server
            DidomiNetworkManager.shared.sendConsentAsync(consentStatus: currentConsent.consentStatus.rawValue) { (DidomiNetworkResult) in
                // Nothing to do.
                // TODO change this to null?
            }
        }
    }
    

    public func showConsent() {
        DidomiVisualConsentManager.shared.showConsent(consent: currentConsent) { (status: DidomiConsentStatus) -> () in
            self.setConsentStatus(status: status)
        }
    }

    // MARK - private methods
    
    private override init() {
        self.currentConsent = DidomiConsent(consentTitle: "default", consentMassage: "default", consentStatus: .Undefined)
        super.init()
    }
    
    // MARK - attributs
    
    private var currentConsent: DidomiConsent

}
