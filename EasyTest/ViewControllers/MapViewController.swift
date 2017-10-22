//
//  MapViewController.swift
//  EasyTest
//
//  Created by Gilson Gil on 19/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit
import MapKit

import Cartography

final class MapViewController: UIViewController {
  fileprivate lazy var mapView: MKMapView = {
    let mapView = MKMapView()
    mapView.showsUserLocation = true
    mapView.delegate = self
    return mapView
  }()

  fileprivate let panGesture = UIPanGestureRecognizer(target: self, action: nil)

  fileprivate var userHasDragged = false

  fileprivate var mapViewModel: MapViewModel? {
    didSet {
      DispatchQueue.main.async {
        self.mapView.removeAnnotations(self.mapView.annotations)
        if let cars = self.mapViewModel?.cars {
          self.mapView.addAnnotations(cars)
        }
        if let userLocation = self.mapViewModel?.userLocation {
          self.mapView.addAnnotation(userLocation)
        }
      }
    }
  }

  init() {
    super.init(nibName: nil, bundle: nil)
    setUp()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setUp() {
    view.backgroundColor = .white

    addSubviews()
    addConstraints()
  }

  private func addSubviews() {
    view.addSubview(mapView)
  }

  private func addConstraints() {
    constrain(mapView) { mapView in
      mapView.edges == mapView.superview!.edges
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.addGestureRecognizer(panGesture)
    panGesture.delegate = self
  }
}

// MARK: - Private
private extension MapViewController {
  func update(with coordinate: CLLocationCoordinate2D) {
    ProgressHUD.show()
    mapViewModel?.update(coordinate: coordinate) { [weak self] callback in
      ProgressHUD.dismiss()
      do {
        let viewModel = try callback()
        self?.mapViewModel = viewModel
        if viewModel.cars.count == 0 {
          let alert = UIAlertController(title: "Easy Test", message: "No results found", preferredStyle: .alert)
          let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
          alert.addAction(okAction)
          DispatchQueue.main.async {
            self?.present(alert, animated: true, completion: nil)
          }
        }
      } catch let error as NetworkError {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.async {
          self?.present(alert, animated: true, completion: nil)
        }
      } catch {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.async {
          self?.present(alert, animated: true, completion: nil)
        }
      }
    }
  }
}

// MARK: - MKMapView Delegate
extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    guard userHasDragged else {
      return
    }
    if mapViewModel == nil {
      mapViewModel = MapViewModel()
    }
    update(with: mapView.centerCoordinate)
  }

  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    guard mapViewModel == nil else {
      return
    }
    guard let location = userLocation.location else {
      return
    }
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let region = MKCoordinateRegion(center: location.coordinate, span: span)
    mapView.setRegion(region, animated: true)
    mapViewModel = MapViewModel()
    update(with: location.coordinate)
  }

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    switch annotation {
    case is Car:
      if let carView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(CarView.self)) as? CarView {
        carView.car = annotation as? Car
        return carView
      } else {
        let carView = CarView(car: annotation as? Car)
        return carView
      }
    case is UserLocation:
      if let userLocationView = mapView.dequeueReusableAnnotationView(withIdentifier: NSStringFromClass(UserLocationView.self)) as? UserLocationView {
        userLocationView.userLocation = annotation as? UserLocation
        return userLocationView
      } else {
        let userLocationView = UserLocationView(userLocation: annotation as? UserLocation)
        userLocationView?.canShowCallout = true
        return userLocationView
      }
    default:
      return nil
    }
  }
}

// MARK: - Gesture Recognizer Delegate
extension MapViewController: UIGestureRecognizerDelegate {
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    userHasDragged = true
    return false
  }
}
