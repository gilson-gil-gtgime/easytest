//
//  NetworkErrorTest.swift
//  EasyTestTests
//
//  Created by Gilson Gil on 22/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import XCTest
@testable import EasyTest

class NetworkErrorTest: XCTestCase {
  let timeoutError = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut, userInfo: nil)
  let noConnectionError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
  let apiError = NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)

  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }

  func testInit() {
    let timeoutNetworkError = NetworkError(error: timeoutError)
    assert(timeoutNetworkError == NetworkError.timeout)

    let noConnectionNetworkError = NetworkError(error: noConnectionError)
    assert(noConnectionNetworkError == NetworkError.noConnection)

    let apiNetworkError = NetworkError(error: apiError)
    assert(apiNetworkError == NetworkError.api)

    let noNetworkError = NetworkError(error: nil)
    assert(noNetworkError == nil)
  }
}
