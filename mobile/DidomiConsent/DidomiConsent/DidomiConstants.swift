//
//  DidomiConstants.swift
//  DidomiConsent
//
//  Created by Shimon Azulay on 11/01/2020.
//  Copyright © 2020 shimon.azulay. All rights reserved.
//

struct DidomiConstants {
    
    struct ConsentStatusStrings {
        static let Accept = "accept"
        static let Deny = "deny"
        static let Undefined = "undefined"
    }
    
    struct Network {
        static let EndpointURL = "http://www.mocky.io/v2/5e14e8122d00002b00167430"
        static let ISO8601UTC = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        static let PostRequest = "POST"
        static let ContentHeaderTypeKey = "Content-Type"
        static let ContentHeaderJsonValue = "application/json; charset=utf-8"
        static let PayloadConsentStatusKey = "status"
        static let PayloadConsentDeviceIdKey = "device_id"
        static let PayloadConsentDateKey = "date"
        static let ResponseError = "Respose error:"
        static let ResponseStatusCode = "Respose status code:"
        static let ResponseData = "Respose data:"
        static let NetworkSetupError = "Error due to network setup."
        static let PayloadError = "Error on build payload."
        static let RequestError = "Error on build request."
    }
    
    struct Persistence {
        static let PersistenceConsentStatusKey = "Didomi-consent-Status-persistence-key"
        static let ConsentPersisted = "Consent status has persisted. Persisted consent status:"
        static let ConsentRetrived = "Consent status has retrived. Retrived consent status:"
        static let ConsentPersisteError = "Consent status has not persisted due to an error."
        static let ConsentRetrivedError = "Consent status has not retrived due to an error."
    }
    
    struct Device {
        static let defaultDeviceId = "no-device-id"
    }
    
    struct VisualConsetManager {
        static let ConsentMessageKey = "Didomi-consent-message-key"
        static let ConsentTitleKey = "Didomi-consent-title-key"
        static let RetriveConsentStringsError = "Could not find consent title or message."
        static let SceneError = "Could not find scene."
        static let DefaultStringsTable = "Default"
    }
    
    struct ConsentDialog {
        static let AcceptButtonText = "ACCEPT"
        static let DenyButtonText = "DENY"
    }
    
    struct ConsentManager {
        static let ConsentStatusSentToServer = "Consent status has sent to server. Sent consent status:"
        static let ConsentStatusSendToServerError = "Consent status has not sent to server due to an error."
        static let ConsentChanged = "Consent status has changed. New consent status:"
        static let DispatchQueueLabel = "DidomiConsent.serial.dispatch.queue"
    }
}
