//
//  DidomiNetworkManagerTests.swift
//  DidomiConsentTests
//
//  Created by Shimon Azulay on 12/01/2020.
//  Copyright © 2020 shimon.azulay. All rights reserved.
//

import XCTest
@testable import DidomiConsent

class DidomiNetworkManagerTests: XCTestCase {
    
    func testSucces() {
        
        let expectation = self.expectation(description: "Scaling")
        
        DidomiNetworkManager.shared.sendConsentAsync(consentStatus: DidomiConstants.ConsentStatusStrings.Accept, url: DidomiConstants.Network.EndpointURL) { (result: DidomiNetworkResult) in
            
            XCTAssertNil(result.error)
            XCTAssertNotNil(result.statusCode)
            XCTAssertNotNil(result.response)
            XCTAssertNotNil(result.sentConsentStatus)
            
            XCTAssertTrue(200 ... 299 ~=  result.statusCode!)
            XCTAssertEqual(result.sentConsentStatus!, DidomiConstants.ConsentStatusStrings.Accept)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFailure() {
        
        let expectation = self.expectation(description: "Scaling")
        
        DidomiNetworkManager.shared.sendConsentAsync(consentStatus: DidomiConstants.ConsentStatusStrings.Accept, url: "http://www.fake.io") { (result: DidomiNetworkResult) in
            
            XCTAssertNotNil(result.error)
            XCTAssertNil(result.statusCode)
            XCTAssertNil(result.response)
            XCTAssertNotNil(result.sentConsentStatus)
            XCTAssertEqual(result.sentConsentStatus!, DidomiConstants.ConsentStatusStrings.Accept)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFailureBadConfiguration() {
        
        let expectation = self.expectation(description: "Scaling")
        
        DidomiNetworkManager.shared.sendConsentAsync(consentStatus: DidomiConstants.ConsentStatusStrings.Accept, url: "") { (result: DidomiNetworkResult) in
            
            XCTAssertNotNil(result.error)
            XCTAssertNil(result.statusCode)
            XCTAssertNil(result.response)
            XCTAssertNotNil(result.sentConsentStatus)
            XCTAssertEqual(result.error!, DidomiConstants.Network.BadConfigurationError)
            XCTAssertEqual(result.sentConsentStatus!, DidomiConstants.ConsentStatusStrings.Accept)
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
