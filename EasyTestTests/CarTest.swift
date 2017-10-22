//
//  CarTest.swift
//  EasyTestTests
//
//  Created by Gilson Gil on 22/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import XCTest
import CoreLocation

@testable import EasyTest

class CarTest: XCTestCase {
  var userCoordinate: CLLocationCoordinate2D!
  var closeTaxi: Car!
  var farTaxi: Car!

  override func setUp() {
    super.setUp()
    userCoordinate = CLLocationCoordinate2D(latitude: -23, longitude: -46)

    let closeTaxiJSON: NSDictionary = [
      "lat": -23.5,
      "lng": -46,
      "driver-car": "Delorean",
      "driver-name": "Doc Brown"
    ]
    closeTaxi = Car.from(closeTaxiJSON)

    let farTaxiJSON: NSDictionary = [
      "lat": -23.5,
      "lng": -46.5,
      "driver-car": "Eleanor",
      "driver-name": "Memphis"
    ]
    farTaxi = Car.from(farTaxiJSON)
  }

  override func tearDown() {
    super.tearDown()
    userCoordinate = nil
    closeTaxi = nil
    farTaxi = nil
  }

  func testDistance() {
    let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
    let closeTaxiDistance = closeTaxi.distance(from: userLocation)
    let farTaxiDistance = farTaxi.distance(from: userLocation)
    assert(Int(closeTaxiDistance) == 55373)
    assert(Int(farTaxiDistance) == 75393)
  }

  func testNearest() {
    let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
    let taxis1: [Car] = [closeTaxi, farTaxi]
    let nearest1 = taxis1.nearest(from: userLocation)
    assert(nearest1 == closeTaxi)

    let taxis2: [Car] = [farTaxi, closeTaxi]
    let nearest2 = taxis2.nearest(from: userLocation)
    assert(nearest2 == closeTaxi)
  }

  func testDistancePerformance() {
    self.measure {
      testDistance()
    }
  }

  func testNearestPerformance() {
    self.measure {
      testNearest()
    }
  }
}
