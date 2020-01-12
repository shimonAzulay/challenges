//
//  DidomiPersistenceManagerTests.swift
//  DidomiConsentTests
//
//  Created by Shimon Azulay on 13/01/2020.
//  Copyright © 2020 shimon.azulay. All rights reserved.
//

import XCTest
@testable import DidomiConsent

class DidomiPersistenceManagerTests: XCTestCase {
    
    let defualts = UserDefaults.standard
    
    override func tearDown() {
        defualts.removeObject(forKey: "Didomi-consent-status-key-test")
    }

    func testPersiste() {
        DidomiPersistenceManager.shared.persisteConsentStatus(consentStatus: "Some status #1", forKey: "Didomi-consent-status-key-test")
        let status = defualts.string(forKey: "Didomi-consent-status-key-test")
        XCTAssertEqual(status, "Some status #1")
    }
    
    func testRetrive() {
        defualts.set("Some status #2", forKey: "Didomi-consent-status-key-test")
        defualts.synchronize()
        XCTAssertEqual(DidomiPersistenceManager.shared.retriveConsentStatus(forKey: "Didomi-consent-status-key-test"), "Some status #2")
      }

}
