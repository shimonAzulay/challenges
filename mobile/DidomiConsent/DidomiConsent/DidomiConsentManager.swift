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

protocol DidomiConsentManagerProtocol {
    func checkConsentStatus()
    func getConsentStatus() -> DidomiConsentStatus
    func setConsentStatus(status: DidomiConsentStatus)
    func showConsent()
    
}

public class DidomiConsentManager : NSObject {
    
    // MARK - API
    
    /**
     This method should be called on app start.
     Check status of consent. If status is Undefined
     */
    public static func checkConsentStatus() {
        
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(DidomiConsentManager.self,
                                                   selector: #selector(DidomiConsentManager.checkConsetStatusInternal),
                                                   name: UIScene.didActivateNotification,
                                                   object: nil)
        } else {
            DidomiConsentManager.checkConsetStatusInternal()
        }
    }
    
    /**
     Get consent status.
     - Note: This method can be overriden.
     - Returns: DidomiConsentStatus.
     */
    public class func getConsentStatus() -> DidomiConsentStatus {
        var currentStatus = DidomiConsentStatus.Undefined
        managerSerialQueue.sync {
            currentStatus = DidomiConsentManager.consentStatus
        }
        
        return currentStatus
    }
    
    /**
     Set consent status. The new consent status will be presisted and send to server.
     - Note: This method can be overriden.
     - Parameter status: The new status.
     */
    public class func setConsentStatus(status: DidomiConsentStatus) {
        managerSerialQueue.sync {
            DidomiConsentManager.consentStatus = status
            DidomiLogManager.shared.log(logMessage: "\(DidomiConstants.ConsentManager.ConsentChanged) \(consentStatus.rawValue)")
            DidomiPersistenceManager.shared.persisteConsentStatus(consentStatus: status.rawValue)
            
            // Notify server
            DidomiNetworkManager.shared.sendConsentAsync(consentStatus: consentStatus.rawValue) { (result: DidomiNetworkResult) in
                if let statusCode = result.statusCode {
                    // Successful response
                    if 200 ... 299 ~= statusCode, let consentStatus = result.sentConsentStatus {
                        DidomiLogManager.shared.log(logMessage: "\(DidomiConstants.ConsentManager.ConsentStatusSentToServer) \(consentStatus)")
                    }
                } else if let consentStatus = result.sentConsentStatus {
                    // Unsuccessful response
                    DidomiLogManager.shared.log(logMessage: "\(DidomiConstants.ConsentManager.ConsentStatusSendToServerError) \(consentStatus)")
                }
                
            }
        }
    }
    
    /**
     Show dialog consent to the user.
     - Note: The default implementation is to open a new window and show a dialog.
     - Note: This method can be overriden for more complex UI.
     - Important: This method should be run on main thread.
     */
    public class func showConsent() {
        DidomiVisualConsentManager.shared.showConsentDialog(consent: consent) { (status: DidomiConsentStatus) -> () in
            DidomiConsentManager.setConsentStatus(status: status)
        }
    }
    
    // MARK - private methods
    
    private override init() {
        super.init()
    }
    
    @objc private static func checkConsetStatusInternal() {
        managerSerialQueue.sync {
            DidomiConsentManager.consentStatus = DidomiConsentStatus(rawValue: DidomiPersistenceManager.shared.retriveConsentStatus()) ?? .Undefined
        }
        
        if (getConsentStatus() == .Undefined) {
            showConsent()
        }
    }
    
    
    
    // MARK - attributs
    
    private static var consentStatus = DidomiConsentStatus.Undefined
    
    private static let consent = DidomiConsent(consentTitle: "default", consentMassage: "default")
    
    private static let managerSerialQueue = DispatchQueue(label: DidomiConstants.ConsentManager.DispatchQueueLabel)
    
}
