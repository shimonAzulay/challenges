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
@objc public enum DidomiConsentStatus: Int, RawRepresentable {
    case Undefined
    case Accept
    case Deny
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        var value: RawValue
        switch self {
        case .Undefined:
            value = DidomiConstants.ConsentStatusStrings.Undefined
        case .Accept:
            value = DidomiConstants.ConsentStatusStrings.Accept
        case .Deny:
            value = DidomiConstants.ConsentStatusStrings.Deny
        }
        
        return value
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case DidomiConstants.ConsentStatusStrings.Undefined:
            self = .Undefined
        case DidomiConstants.ConsentStatusStrings.Accept:
            self = .Accept
        case DidomiConstants.ConsentStatusStrings.Deny:
            self = .Deny
        default:
            return nil
        }
    }
}

open class DidomiConsentManager : NSObject {
    
    // MARK - API
    
    /**
     This method should be called on app start.
     Check status of consent. If status is Undefined
     */
    @objc public static func checkConsentStatus() {
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.checkConsetStatusInternal),
                                                   name: UIScene.didActivateNotification,
                                                   object: nil)
        } else {
            self.checkConsetStatusInternal()
        }
    }
    
    /**
     Get consent status.
     - Note: This method can be overriden.
     - Returns: DidomiConsentStatus.
     */
    @objc open class func getConsentStatus() -> DidomiConsentStatus {
        var currentStatus = DidomiConsentStatus.Undefined
        managerSerialQueue.sync {
            currentStatus = self.consentStatus
        }
        
        return currentStatus
    }
    
    /**
     Set consent status. The new consent status will be presisted and send to server.
     - Note: This method can be overriden.
     - Parameter status: The new status.
     */
    @objc open class func setConsentStatus(status: DidomiConsentStatus) {
        managerSerialQueue.sync {
            self.consentStatus = status
            DidomiLogManager.shared.log(logMessage: "\(DidomiConstants.ConsentManager.ConsentChanged) \(consentStatus.rawValue)")
            self.persisteConsentStatus(status: status.rawValue)
            
            // Notify server
            self.sendConsentStatusToServer(consentStatus: status.rawValue)
        }
    }
    
    /**
     Show dialog consent to the user.
     - Note: The default implementation is to open a new window and show a dialog.
     - Note: This method can be overriden for more complex UI.
     - Important: This method should be run on main thread.
     */
    @objc open class func showConsent() {
        DidomiVisualConsentManager.shared.showConsentDialog() { (status: DidomiConsentStatus) -> () in
            self.setConsentStatus(status: status)
        }
    }
    
    // MARK - private methods
    
    private override init() {
        super.init()
    }
    
    @objc static func checkConsetStatusInternal() {
        managerSerialQueue.sync {
            self.consentStatus = self.retriveConsentStatus()
        }
        
        if (getConsentStatus() == .Undefined) {
            self.showConsent()
        }
    }
    
    // MARK - attributs
    
    private static var consentStatus = DidomiConsentStatus.Undefined
    
    private static let managerSerialQueue = DispatchQueue(label: DidomiConstants.ConsentManager.DispatchQueueLabel)
    
    
    // MARK - call managers
    class func persisteConsentStatus(status: String) {
        DidomiPersistenceManager.shared.persisteConsentStatus(consentStatus: status, forKey: DidomiConstants.Persistence.PersistenceConsentStatusKey)
    }
    
    class func retriveConsentStatus() -> DidomiConsentStatus {
        return DidomiConsentStatus(rawValue: DidomiPersistenceManager.shared.retriveConsentStatus(forKey: DidomiConstants.Persistence.PersistenceConsentStatusKey)) ?? .Undefined
    }
    
    class func sendConsentStatusToServer(consentStatus: String) {
        
        DidomiNetworkManager.shared.sendConsentAsync(consentStatus: consentStatus, url: DidomiConstants.Network.EndpointURL) { (result: DidomiNetworkResult) in
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
