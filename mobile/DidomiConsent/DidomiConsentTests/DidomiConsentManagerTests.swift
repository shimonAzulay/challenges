//
//  DidomiConsentTests.swift
//  DidomiConsentTests
//
//  Created by Shimon Azulay on 10/01/2020.
//  Copyright © 2020 shimon.azulay. All rights reserved.
//

import XCTest
@testable import DidomiConsent

class DidomiConsentManagerTests: XCTestCase {
    
    class DidomiConsentManagerMock : DidomiConsentManager {
        
        static var showConsentCalled = false
        
        override static func showConsent() {
            showConsentCalled = true
        }
    }
    
    func testSetGetConsentStatus() {
        DidomiConsentManager.setConsentStatus(status: .Undefined)
        XCTAssertEqual(DidomiConsentManager.getConsentStatus(), .Undefined)
        
        DidomiConsentManager.setConsentStatus(status: .Accept)
        XCTAssertEqual(DidomiConsentManager.getConsentStatus(), .Accept)
        
        DidomiConsentManager.setConsentStatus(status: .Deny)
        XCTAssertEqual(DidomiConsentManager.getConsentStatus(), .Deny)
    }
    
    func testCheckConsentStatusUndefined() {
        DidomiConsentManagerMock.setConsentStatus(status: .Undefined)
        DidomiConsentManagerMock.checkConsentStatus()
        XCTAssertTrue(DidomiConsentManagerMock.showConsentCalled)
    }
    
    func testCheckConsentStatusAccept() {
        DidomiConsentManagerMock.setConsentStatus(status: .Accept)
        DidomiConsentManagerMock.checkConsentStatus()
        XCTAssertFalse(DidomiConsentManagerMock.showConsentCalled)
    }
    
    func testCheckConsentStatusDeny() {
        DidomiConsentManagerMock.setConsentStatus(status: .Deny)
        DidomiConsentManagerMock.checkConsentStatus()
        XCTAssertFalse(DidomiConsentManagerMock.showConsentCalled)
    }
}
