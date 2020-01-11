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
        static let ISO8601UTC = "yyyyMMdd'T'HHmmssZ"
        static let PostRequest = "POST"
        static let ContentHeaderTypeKey = "Content-Type"
        static let ContentHeaderJsonValue = "application/json; charset=utf-8"
        static let PayloadConsentStatusKey = "status"
        static let PayloadConsentDeviceIdKey = "device_id"
        static let PayloadConsentDateKey = "date"
    }
    
    struct Persistence {
        static let PersistenceConsentStatusKey = "DidomiConsentStatus"
        
    }
    
    struct Device {
        static let defaultDeviceId = "no-device-id"
    }
    
    struct ConsentDialog {
        static let AcceptButtonText = "ACCEPT"
        static let DenyButtonText = "DENY"
    }
    
    
    
}
