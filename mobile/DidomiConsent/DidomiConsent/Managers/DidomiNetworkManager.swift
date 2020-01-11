//
//  DidomiNetworkManager.swift
//  DidomiConsents
//
//  Created by Shimon Azulay on 10/01/2020.
//  Copyright © 2020 shimon.azulay. All rights reserved.
//

import UIKit

public struct DidomiNetworkResult {
    
}

public struct DidomiNetworkConfiguration {
    public var reties: Int
}

class DidomiNetworkManager: NSObject {
    
    // MARK - API
    
    static let shared = DidomiNetworkManager()

    func sendConsentAsync(consentStatus: String, completion: (_ result: DidomiNetworkResult)->()) {
        let url = URL(string: DidomiConstants.Network.EndpointURL)!
        var request = URLRequest(url: url)
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DidomiConstants.Network.ISO8601UTC
        dateFormatter.string(from: date)
        let json: [String: Any] = [
            DidomiConstants.Network.PayloadConsentStatusKey: consentStatus,
            DidomiConstants.Network.PayloadConsentDeviceIdKey: UIDevice.current.identifierForVendor?.uuidString ?? DidomiConstants.Device.defaultDeviceId,
            DidomiConstants.Network.PayloadConsentDateKey: dateFormatter.string(from: date)
        ]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpMethod = DidomiConstants.Network.PostRequest
        request.setValue(DidomiConstants.Network.ContentHeaderJsonValue, forHTTPHeaderField: DidomiConstants.Network.ContentHeaderTypeKey)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("data: \(dataString)")
                }
            }
        }
        task.resume()
    }
    
    func sendConsentSync(consent: DidomiConsent) -> DidomiNetworkResult {
        return DidomiNetworkResult()
    }
    
    func setNetworkConfiguration(configuration: DidomiNetworkConfiguration) {
        // Check null
        
    }
    
    // MARK - private methods
    
    private override init() {
        configuration = DidomiNetworkConfiguration(reties: 5)
        super.init()
    }
    
    
    // MARK - attributes
    
    private var configuration: DidomiNetworkConfiguration
    
    
    

}
