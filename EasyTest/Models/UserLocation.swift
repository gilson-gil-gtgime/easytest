//
//  UserLocation.swift
//  EasyTest
//
//  Created by Gilson Gil on 22/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation
import MapKit

final class UserLocation: NSObject, MKAnnotation {
  let coordinate: CLLocationCoordinate2D
  var title: String?

  init(coordinate: CLLocationCoordinate2D) {
    self.coordinate = coordinate
    self.title = "title"
    super.init()
  }
}
