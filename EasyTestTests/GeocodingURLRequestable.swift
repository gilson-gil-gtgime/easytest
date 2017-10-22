//
//  GeocodingURLRequestable.swift
//  EasyTestTests
//
//  Created by Gilson Gil on 22/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import XCTest
@testable import EasyTest

class GeocodingURLRequestableTest: XCTestCase {
  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testInit() {
    let requestable = GeocodingURLRequestable(latitude: -23, longitude: -46)
    let requestURL = requestable.urlRequest?.url?.absoluteString

    assert(requestURL == Endpoints.baseURLGeocodingString + "-23.0,-46.0")
  }
}
