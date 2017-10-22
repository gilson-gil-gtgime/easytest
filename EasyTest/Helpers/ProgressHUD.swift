//
//  ProgressHUD.swift
//  EasyTest
//
//  Created by Gilson Gil on 22/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation
import SVProgressHUD

struct ProgressHUD {
  static func setUp() {
    SVProgressHUD.setDefaultMaskType(.gradient)
  }

  static func show() {
    SVProgressHUD.show()
  }

  static func dismiss() {
    SVProgressHUD.dismiss()
  }
}
