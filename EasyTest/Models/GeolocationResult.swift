//
//  GeolocationResult.swift
//  EasyTest
//
//  Created by Gilson Gil on 22/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation
import Mapper

struct GeolocationResult: Mappable {
  let results: [GeolocationAddress]

  init(map: Mapper) throws {
    results = try map.from("results")
  }
}
