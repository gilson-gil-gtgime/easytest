//
//  UserLocationView.swift
//  EasyTest
//
//  Created by Gilson Gil on 22/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import MapKit

final class UserLocationView: MKAnnotationView {
  var userLocation: UserLocation?

  init?(userLocation: UserLocation?) {
    guard let userLocation = userLocation else {
      return nil
    }
    self.userLocation = userLocation
    super.init(annotation: userLocation, reuseIdentifier: NSStringFromClass(UserLocationView.self))
    image = UIImage.EasyTest.userView
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
