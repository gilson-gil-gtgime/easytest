//
//  MapViewModelTest.swift
//  EasyTestTests
//
//  Created by Gilson Gil on 22/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import XCTest
import CoreLocation

@testable import EasyTest

class MapViewModelTest: XCTestCase {
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

  func testNearestCar() {
    let viewModel1 = MapViewModel(locationManager: nil, userLocation: nil, cars: [farTaxi, closeTaxi])
    let nearest1 = viewModel1.nearestCar()
    assert(nearest1 == nil)

    let userLocation2 = UserLocation(coordinate: userCoordinate, title: "title")
    let viewModel2 = MapViewModel(locationManager: nil, userLocation: userLocation2, cars: [farTaxi, closeTaxi])
    let nearest2 = viewModel2.nearestCar()
    assert(nearest2 == closeTaxi)

    let userLocation3 = UserLocation(coordinate: userCoordinate, title: "title")
    let viewModel3 = MapViewModel(locationManager: nil, userLocation: userLocation3, cars: [closeTaxi, farTaxi])
    let nearest3 = viewModel3.nearestCar()
    assert(nearest3 == closeTaxi)
  }
}
