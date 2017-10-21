//
//  CarsResult.swift
//  EasyTest
//
//  Created by Gilson Gil on 20/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation
import Mapper

struct CarsResult: Mappable {
  let cars: [Car]

  init(map: Mapper) throws {
    cars = try map.from("taxis")
  }
}
