//
//  CarsURLRequestable.swift
//  EasyTest
//
//  Created by Gilson Gil on 20/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Alamofire

struct CarsURLRequestable: URLRequestable {
  let latitude: Double
  let longitude: Double

  var method: HTTPMethod {
    return .get
  }

  var path: String {
    return Endpoints.cars
  }

  var parameters: Parameters? {
    return [
      "lat": latitude,
      "lng": longitude
    ]
  }

  var headers: Parameters? {
    return nil
  }

  var encoding: ParameterEncoding {
    return URLEncoding.queryString
  }

  func handleResponse(response: DataResponse<Any>, completion: @escaping CompletionHandlerType<Any?>) {
    guard let json = response.result.value as? NSDictionary,
      let carsResult = CarsResult.from(json)else {
        completion { throw NetworkError.api }
        return
    }
    completion { return carsResult.cars }
  }
}

