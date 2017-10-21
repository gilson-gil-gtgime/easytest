//
//  Endpoints.swift
//  EasyTest
//
//  Created by Gilson Gil on 20/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation

struct Endpoints {
  static var baseURLString: String {
    return "http://quasinada-ryu.easytaxi.net.br/api/"
  }

  static var baseURL: URL {
    guard let url = URL(string: baseURLString) else {
      fatalError()
    }
    return url
  }

  static var cars: String {
    return "gettaxis"
  }
}
