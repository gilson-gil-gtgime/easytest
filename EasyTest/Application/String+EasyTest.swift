//
//  String+EasyTest.swift
//  EasyTest
//
//  Created by Gilson Gil on 22/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation

extension String {
  struct EasyTest {
    static var appName: String {
      return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "Easy Test"
    }

    static var okay: String {
      return NSLocalizedString("okay", comment: "")
    }

    struct ErrorMessages {
      static var title: String {
        return NSLocalizedString("error_messages.title", comment: "")
      }

      static var noResults: String {
        return NSLocalizedString("error_messages.no_results", comment: "")
      }

      static var connection: String {
        return NSLocalizedString("error_messages.connection", comment: "")
      }

      static var api: String {
        return NSLocalizedString("error_messages.api", comment: "")
      }
    }

    struct MapViewController {
      static var addressNotFound: String {
        return NSLocalizedString("map_view_controller.address_not_found", comment: "")
      }
    }
  }
}
