//
//  GeocodingURLRequestable.swift
//  EasyTest
//
//  Created by Gilson Gil on 22/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Alamofire

struct GeocodingURLRequestable: URLRequestConvertible {
  let latitude: Double
  let longitude: Double

  func asURLRequest() throws -> URLRequest {
    let urlString = Endpoints.baseURLGeocodingString.appending("\(latitude),\(longitude)")
    guard let url = URL(string: urlString) else {
      throw NetworkError.api
    }
    let urlRequest = URLRequest(url: url)
    return urlRequest
  }

  func request(_ completion: @escaping CompletionHandlerType<Any?>) {
    Alamofire.request(self).responseJSON { response in
      if let networkError = NetworkError(error: response.error) {
        completion { throw networkError }
        return
      }
      self.handleResponse(response: response, completion: completion)
    }
  }

  func handleResponse(response: DataResponse<Any>, completion: @escaping CompletionHandlerType<Any?>) {
    guard let json = response.result.value as? NSDictionary,
      let geolocationResult = GeolocationResult.from(json) else {
        completion { throw NetworkError.api }
        return
    }
    completion { return geolocationResult.results.first?.address }
  }
}

