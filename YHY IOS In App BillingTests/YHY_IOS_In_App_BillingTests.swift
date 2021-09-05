//
//  YHY_IOS_In_App_BillingTests.swift
//  YHY IOS In App BillingTests
//
//  Created by Ucdemir on 4.09.2021.
//

import XCTest
@testable import YHY_IOS_In_App_Billing

class YHY_IOS_In_App_BillingTests: XCTestCase {

    var swiftyLib: TestLib!

       override func setUp() {
           swiftyLib = TestLib()
       }

       func testAdd() {
           XCTAssertEqual(swiftyLib.add(a: 1, b: 1), 2)
       }
       
       func testSub() {
           XCTAssertEqual(swiftyLib.sub(a: 2, b: 1), 1)
       }

}
