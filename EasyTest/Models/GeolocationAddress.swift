//
//  GeolocationAddress.swift
//  EasyTest
//
//  Created by Gilson Gil on 22/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation
import Mapper

struct GeolocationAddress: Mappable {
  let address: String

  init(map: Mapper) throws {
    address = try map.from("formatted_address")
  }
}
