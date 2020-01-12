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
        static var retriveConsentStatusCalled = false
        static var persisteConsentStatusCalled = false
        static var sendConsentStatusToServerCalled = false
        static var persistedConsentStatus = DidomiConsentStatus.Undefined
        
        override class func showConsent() {
            showConsentCalled = true
        }
        
        override class func retriveConsentStatus() -> DidomiConsentStatus {
            retriveConsentStatusCalled = true
            return persistedConsentStatus
        }
        
        override class func persisteConsentStatus(status: String) {
            persisteConsentStatusCalled = true
            persistedConsentStatus = DidomiConsentStatus(rawValue: status) ?? .Undefined
        }
        
        override class func sendConsentStatusToServer(consentStatus: String) {
            sendConsentStatusToServerCalled = true
        }
    }
    
    override class func tearDown() {
        DidomiConsentManagerMock.showConsentCalled = false
        DidomiConsentManagerMock.retriveConsentStatusCalled = false
        DidomiConsentManagerMock.persisteConsentStatusCalled = false
        DidomiConsentManagerMock.sendConsentStatusToServerCalled = false
        DidomiConsentManagerMock.persistedConsentStatus = DidomiConsentStatus.Undefined
    }
    
    func testSetGetConsentStatus() {
        DidomiConsentManagerMock.setConsentStatus(status: .Undefined)
        XCTAssertEqual(DidomiConsentManagerMock.getConsentStatus(), .Undefined)
        XCTAssertTrue(DidomiConsentManagerMock.sendConsentStatusToServerCalled)
        XCTAssertTrue(DidomiConsentManagerMock.persisteConsentStatusCalled)
        
        tearDown()
        
        DidomiConsentManagerMock.setConsentStatus(status: .Accept)
        XCTAssertEqual(DidomiConsentManagerMock.getConsentStatus(), .Accept)
        XCTAssertTrue(DidomiConsentManagerMock.sendConsentStatusToServerCalled)
        XCTAssertTrue(DidomiConsentManagerMock.persisteConsentStatusCalled)
        
        tearDown()
        
        DidomiConsentManagerMock.setConsentStatus(status: .Deny)
        XCTAssertEqual(DidomiConsentManagerMock.getConsentStatus(), .Deny)
        XCTAssertTrue(DidomiConsentManagerMock.sendConsentStatusToServerCalled)
        XCTAssertTrue(DidomiConsentManagerMock.persisteConsentStatusCalled)
    }

    func testCheckConsentStatusUndefined() {
        DidomiConsentManagerMock.persistedConsentStatus = .Undefined
        DidomiConsentManagerMock.checkConsetStatusInternal()
        XCTAssertTrue(DidomiConsentManagerMock.showConsentCalled)
        XCTAssertTrue(DidomiConsentManagerMock.retriveConsentStatusCalled)
    }
    
    func testCheckConsentStatusAccept() {
        DidomiConsentManagerMock.persistedConsentStatus = .Accept
        DidomiConsentManagerMock.checkConsetStatusInternal()
        XCTAssertFalse(DidomiConsentManagerMock.showConsentCalled)
        XCTAssertTrue(DidomiConsentManagerMock.retriveConsentStatusCalled)
    }
    
    func testCheckConsentStatusDeny() {
        DidomiConsentManagerMock.persistedConsentStatus = .Deny
        DidomiConsentManagerMock.checkConsetStatusInternal()
        XCTAssertFalse(DidomiConsentManagerMock.showConsentCalled)
        XCTAssertTrue(DidomiConsentManagerMock.retriveConsentStatusCalled)
    }
}
