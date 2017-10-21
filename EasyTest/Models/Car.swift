//
//  Car.swift
//  EasyTest
//
//  Created by Gilson Gil on 20/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation
import Mapper

struct Car: Mappable {
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
}
