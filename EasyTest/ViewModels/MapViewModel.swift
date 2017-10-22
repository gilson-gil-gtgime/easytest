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
  let userLocation: UserLocation?
  let cars: [Car]

  init(locationManager: CLLocationManager? = nil, userLocation: UserLocation? = nil, cars: [Car] = []) {
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
    self.userLocation = userLocation
    self.cars = cars
  }

  func update(coordinate: CLLocationCoordinate2D, completion: @escaping CompletionHandlerType<MapViewModel>) {
    GeocodingURLRequestable(latitude: coordinate.latitude, longitude: coordinate.longitude).request { callback in
      do {
        guard let address = try callback() as? String else {
          fatalError()
        }
        CarsURLRequestable(latitude: coordinate.latitude, longitude: coordinate.longitude).request { callback in
          do {
            guard let cars = try callback() as? [Car] else {
              fatalError()
            }
            let userLocation = UserLocation(coordinate: coordinate, title: address)
            let viewModel = MapViewModel(locationManager: self.locationManager, userLocation: userLocation, cars: cars)
            completion { viewModel }
          } catch {
            completion { throw error }
          }
        }
      } catch {
        completion { throw error }
      }
    }
  }

  func nearestCar() -> Car? {
    guard let userLocation = userLocation else {
      return nil
    }
    let location = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
    let nearest = cars.nearest(from: location)
    return nearest
  }
}
