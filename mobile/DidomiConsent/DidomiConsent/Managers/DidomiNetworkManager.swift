//
//  DidomiNetworkManager.swift
//  DidomiConsents
//
//  Created by Shimon Azulay on 10/01/2020.
//  Copyright © 2020 shimon.azulay. All rights reserved.
//

import UIKit

struct DidomiNetworkResult {
    var sentConsentStatus: String?
    var statusCode: Int?
    var response: String?
    var error: String?
}

struct DidomiNetworkConfiguration {
    var endpointURL: String!
    var dateFormat: DidomiNetworkDateFormat!
}

// TODO - change to ISO8601UTC
enum DidomiNetworkDateFormat: String {
    case ISO8601UTC = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
}

class DidomiNetworkManager: NSObject {
    
    // MARK - API
    
    /**
     Call this to get a shared instance of DidomiNetworkManager.
     */
    static let shared = DidomiNetworkManager()
    
    // TODO enforce only known statuses
    
    /**
     Send consent status to server asynchronous.
     - Parameter consentStatus: The consent status string.
     - Parameter completion: Will be called on server response with DidomiNetworkResult
     */
    func sendConsentAsync(consentStatus: String, completion: @escaping (_ result: DidomiNetworkResult)->()) {
        if let payloadData = buildPayloadData(consentStatus: consentStatus), let request = buildRequest(payloadData: payloadData) {
            
            // URLSessionDataTask
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                var statusCode: Int?
                var errorString: String?
                var responseString: String?
                
                if let error = error {
                    errorString = error.localizedDescription
                    DidomiLogManager.shared.log(logMessage: "\(DidomiConstants.Network.ResponseError) \(error)")
                } else {
                    if let response = response as? HTTPURLResponse {
                        statusCode = response.statusCode
                        DidomiLogManager.shared.log(logMessage: "\(DidomiConstants.Network.ResponseStatusCode) \(response.statusCode)")
                    }
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        responseString = dataString
                        DidomiLogManager.shared.log(logMessage: "\(DidomiConstants.Network.ResponseData) \(dataString)")
                    }
                }
                completion(DidomiNetworkResult(sentConsentStatus: consentStatus, statusCode: statusCode, response: responseString, error: errorString))
            }
            
            task.resume()
        }
    }
    
    /*
     For later use.
     Lock or serial queue should be used to sync configuration data.
    
    /**
     Set new network configuration.
     - Parameter configuration: The new configuration.
     */
    
    func setNetworkConfiguration(configuration: DidomiNetworkConfiguration!) {
        if let endpointURL = configuration.endpointURL, let dateFormat = configuration.dateFormat {
            self.configuration = DidomiNetworkConfiguration(endpointURL: endpointURL, dateFormat: dateFormat)
        }
    }
    */
    
    // MARK - private methods
    
    private override init() {
        super.init()
    }
    
    func buildRequest(payloadData: Data) -> URLRequest? {
        let url = URL(string: configuration.endpointURL)!
        var request = URLRequest(url: url)
        request.httpMethod = DidomiConstants.Network.PostRequest
        request.setValue(DidomiConstants.Network.ContentHeaderJsonValue, forHTTPHeaderField: DidomiConstants.Network.ContentHeaderTypeKey)
        request.httpBody = payloadData
        return request
        
    }
    
    func buildPayloadData(consentStatus: String) -> Data? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = configuration.dateFormat.rawValue
        dateFormatter.string(from: date)
        
        let payloadJson: [String: String] = [
            DidomiConstants.Network.PayloadConsentStatusKey: consentStatus,
            DidomiConstants.Network.PayloadConsentDeviceIdKey: UIDevice.current.identifierForVendor?.uuidString ?? DidomiConstants.Device.defaultDeviceId,
            DidomiConstants.Network.PayloadConsentDateKey: dateFormatter.string(from: date)
        ]
        
        let payloadJsonData = try? JSONSerialization.data(withJSONObject: payloadJson)
        
        return payloadJsonData
    }
    
    // MARK - attributes
    
    private var configuration = DidomiNetworkConfiguration(endpointURL: DidomiConstants.Network.EndpointURL, dateFormat: DidomiNetworkDateFormat(rawValue: DidomiConstants.Network.ISO8601UTC)!)
    
}
