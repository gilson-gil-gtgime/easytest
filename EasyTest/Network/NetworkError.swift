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
        self = .api
        return
      }
    }
    return nil
  }

  var localizedDescription: String {
    switch self {
    case .timeout, .noConnection:
      return String.EasyTest.ErrorMessages.connection
    case .api:
      return String.EasyTest.ErrorMessages.api
    }
  }
}
