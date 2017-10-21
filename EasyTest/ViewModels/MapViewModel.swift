//
//  MapViewModel.swift
//  EasyTest
//
//  Created by Gilson Gil on 20/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import Foundation

import CoreLocation

struct MapViewModel {
  let locationManager: CLLocationManager
  let coordinate: CLLocationCoordinate2D?
  let cars: [Car]

  init(locationManager: CLLocationManager? = nil, coordinate: CLLocationCoordinate2D? = nil, cars: [Car] = []) {
    if let locationManager = locationManager {
      self.locationManager = locationManager
    } else {
      let newLocationManager = CLLocationManager()
      newLocationManager.requestWhenInUseAuthorization()
      newLocationManager.activityType = .other
      newLocationManager.allowsBackgroundLocationUpdates = false
      newLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      self.locationManager = newLocationManager
    }
    self.coordinate = coordinate
    self.cars = cars
  }

  func update(coordinate: CLLocationCoordinate2D, completion: @escaping CompletionHandlerType<MapViewModel>) {
    CarsURLRequestable(latitude: coordinate.latitude, longitude: coordinate.longitude).request { callback in
      do {
        guard let cars = try callback() as? [Car] else {
          fatalError()
        }
        let viewModel = MapViewModel(locationManager: self.locationManager, coordinate: coordinate, cars: cars)
        completion { viewModel }
      } catch {
        completion { throw error }
      }
    }
  }
}
