//
//  DidomiLogManager.swift
//  DidomiConsent
//
//  Created by Shimon Azulay on 12/01/2020.
//  Copyright © 2020 shimon.azulay. All rights reserved.
//

import UIKit

/* Basic log levels
enum LogLevel {
    case DEBUG
    case INFO
    case ERROR    
}
*/

class DidomiLogManager: NSObject {
    
    // MARK - API
    
    /**
     Call this to get a shared instance of DidomiLogManager.
     */
    static let shared = DidomiLogManager()
    
    /**
     This is a basic log function
     */
    func log(logMessage: String?) {
        if let logMessage = logMessage {
            print(logMessage)
        }
    }
    
    /*
    func log(logMessage: String, logLevel: logLevel) {}
    */
    
}
