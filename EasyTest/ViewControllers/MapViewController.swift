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
      // reload cars annotations
      DispatchQueue.main.async {
        
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
    mapViewModel?.update(coordinate: coordinate) { [weak self] callback in
      do {
        let viewModel = try callback()
        self?.mapViewModel = viewModel
      } catch let error as NetworkError {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.async {
          self?.present(alert, animated: true, completion: nil)
        }
      } catch {
        print(error)
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
    mapViewModel = MapViewModel()
    update(with: location.coordinate)
  }
}

// MARK: - Gesture Recognizer Delegate
extension MapViewController: UIGestureRecognizerDelegate {
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    userHasDragged = true
    return false
  }
}
