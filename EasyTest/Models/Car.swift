//
//  Car.swift
//  EasyTest
//
//  Created by Gilson Gil on 20/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation
import MapKit

import Mapper

final class Car: NSObject, Mappable {
  let latitude: Double
  let longitude: Double
  let name: String
  let driver: String

  init(map: Mapper) throws {
    latitude = try map.from("lat")
    longitude = try map.from("lng")
    name = try map.from("driver-car")
    driver = try map.from("driver-name")
  }

  func distance(from location: CLLocation) -> Double {
    let carLocation = CLLocation(latitude: latitude, longitude: longitude)
    return carLocation.distance(from: location)
  }
}

extension Car: MKAnnotation {
  var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}

extension Array where Element: Car {
  func nearest(from location: CLLocation) -> Car? {
    let distances = self.flatMap { car -> (car: Car, distance: Double)? in
      let distance = car.distance(from: location)
      return (car: car, distance: distance)
      }.sorted { lhs, rhs -> Bool in
        return lhs.distance <= rhs.distance
    }
    return distances.first?.car
  }
}
