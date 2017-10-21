//
//  NetworkError.swift
//  EasyTest
//
//  Created by Gilson Gil on 07/08/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation

enum NetworkError: Error {
  case timeout
  case noConnection
  case api

  init?(error: Error?) {
    if let error = error {
      switch error._code {
      case NSURLErrorTimedOut:
        self = .timeout
        return
      case NSURLErrorNotConnectedToInternet:
        self = .noConnection
        return
      default:
        break
      }
    }
    return nil
  }

  var localizedDescription: String {
    switch self {
    case .timeout, .noConnection:
      return "Connection Problem"
    case .api:
      return "Error requesting the API data"
    }
  }
}