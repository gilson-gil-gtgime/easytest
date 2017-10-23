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

  fileprivate lazy var gpsButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .white
    button.setImage(UIImage.EasyTest.gpsButton, for: .normal)
    button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    button.layer.cornerRadius = 4
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.lightGray.cgColor

    button.addTarget(self, action: #selector(gpsTapped), for: .touchUpInside)
    return button
  }()

  fileprivate let panGesture = UIPanGestureRecognizer(target: self, action: nil)

  fileprivate let regionSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)

  fileprivate var userHasDragged = false

  fileprivate var mapViewModel = MapViewModel() {
    didSet {
      DispatchQueue.main.async {
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotations(self.mapViewModel.cars)
        if let userLocation = self.mapViewModel.userLocation {
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
    view.addSubview(gpsButton)
  }

  private func addConstraints() {
    let margins = CGFloat(20)
    constrain(mapView, gpsButton) { mapView, gpsButton in
      mapView.edges == mapView.superview!.edges

      gpsButton.bottom == gpsButton.superview!.bottom - margins
      gpsButton.right == gpsButton.superview!.right - margins
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.addGestureRecognizer(panGesture)
    panGesture.delegate = self
  }
}

// MARK: - Actions
extension MapViewController {
  @objc func gpsTapped() {
    update(with: mapView.userLocation.coordinate)
    mapView.setCenter(mapView.userLocation.coordinate, animated: true)
  }
}

// MARK: - Private
private extension MapViewController {
  func update(with coordinate: CLLocationCoordinate2D) {
    ProgressHUD.show()
    mapViewModel.update(coordinate: coordinate) { [weak self] callback in
      ProgressHUD.dismiss()
      do {
        let viewModel = try callback()
        self?.mapViewModel = viewModel
        if viewModel.cars.count == 0 {
          let alert = UIAlertController(title: String.EasyTest.appName, message: String.EasyTest.ErrorMessages.noResults, preferredStyle: .alert)
          let okAction = UIAlertAction(title: String.EasyTest.okay, style: .default, handler: nil)
          alert.addAction(okAction)
          DispatchQueue.main.async {
            self?.present(alert, animated: true, completion: nil)
          }
        }
      } catch let error as NetworkError {
        let alert = UIAlertController(title: String.EasyTest.ErrorMessages.title, message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: String.EasyTest.okay, style: .default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.async {
          self?.present(alert, animated: true, completion: nil)
        }
      } catch {
        let alert = UIAlertController(title: String.EasyTest.ErrorMessages.title, message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: String.EasyTest.okay, style: .default, handler: nil)
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
    update(with: mapView.centerCoordinate)
  }

  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    guard !userHasDragged else {
      return
    }
    guard let location = userLocation.location else {
      return
    }
    let region = MKCoordinateRegion(center: location.coordinate, span: regionSpan)
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
