//
//  UIImage+EasyTest.swift
//  EasyTest
//
//  Created by Gilson Gil on 22/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit

extension UIImage {
  struct EasyTest {
    static var gpsButton: UIImage {
      guard let image = UIImage(named: "icons8-Near Me-100") else {
        fatalError()
      }
      return image
    }

    static var carView: UIImage {
      guard let image = UIImage(named: "easytaxi_marker_Normal") else {
        fatalError()
      }
      return image
    }

    static var userView: UIImage {
      guard let image = UIImage(named: "icon_pin_user_Normal") else {
        fatalError()
      }
      return image
    }
  }
}
