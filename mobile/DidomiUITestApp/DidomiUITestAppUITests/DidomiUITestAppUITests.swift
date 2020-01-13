//
//  DidomiUITestAppUITests.swift
//  DidomiUITestAppUITests
//
//  Created by Shimon Azulay on 13/01/2020.
//  Copyright © 2020 shimon.azulay. All rights reserved.
//

import XCTest
@testable import DidomiConsent

class DidomiUITestAppUITests: XCTestCase {
    
    var expectation: XCTestExpectation?
    
    override func setUp() {
        
        expectation = self.expectation(description: "Wait for UI")
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAccept() {
        
        let app = XCUIApplication()
        app.launch()

        // Wait for alert to show.
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) {

            let acceptButton = XCUIApplication().alerts["GPS location access consent"].scrollViews.otherElements.buttons["ACCEPT"]
            
            acceptButton.tap()

            self.expectation?.fulfill()
        }

        waitForExpectations(timeout: 60, handler: nil)
    }
    
    
    func testDeny() {
        
             let app = XCUIApplication()
            app.launch()

            // Wait for alert to show.
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) {

                let denyButton = XCUIApplication().alerts["GPS location access consent"].scrollViews.otherElements.buttons["DENY"]
                
                denyButton.tap()
                
                

                self.expectation?.fulfill()
            }

            waitForExpectations(timeout: 60, handler: nil)
        }
}
