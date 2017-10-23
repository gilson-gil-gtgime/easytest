//
//  CarView.swift
//  EasyTest
//
//  Created by Gilson Gil on 22/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import MapKit

final class CarView: MKAnnotationView {
  var car: Car?

  init?(car: Car?) {
    guard let car = car else {
      return nil
    }
    self.car = car
    super.init(annotation: car, reuseIdentifier: NSStringFromClass(CarView.self))
    image = UIImage.EasyTest.carView
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
