//
//  ViewController.swift
//  ScoutAR
//
//  Created by Ella on 4/25/17.
//  Copyright © 2017 Ellatronic. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cameraButton: UIButton!
    fileprivate let locationManager = CLLocationManager()
    fileprivate var startedLoadingPOIs = false
    fileprivate var places = [Place]()
    fileprivate var arViewController: ARViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()

        cameraButton.setBackgroundImage(#imageLiteral(resourceName: "CameraButton-Selected"), for: .highlighted)
        cameraButton.adjustsImageWhenHighlighted = false
        cameraButton.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleBottomMargin]
    }

    @IBAction func showARController(_ sender: Any) {
        arViewController = ARViewController()
        arViewController.dataSource = self
        arViewController.maxVisibleAnnotations = 10
        arViewController.headingSmoothingFactor = 0.05
        arViewController.maxVerticalLevel = 3
        arViewController.setAnnotations(places)
        arViewController.closeButtonImage = UIImage(named: "MapButton")
        self.present(arViewController, animated: true, completion: nil)
    }

    // MARK: - Helper Functions
    func showWebInfoView(forPlace place: Place) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        viewController.venueID = place.id
        arViewController.present(viewController, animated: true, completion: nil)
    }

    func showDetailView(forPlace place: Place) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        viewController.place = place
        arViewController.present(viewController, animated: true, completion: nil)
    }

}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            let location = locations.last!
            print("Accuracy: \(location.horizontalAccuracy)")

            if location.horizontalAccuracy < 100 {
                manager.stopUpdatingLocation()
                let span = MKCoordinateSpan(latitudeDelta: 0.014, longitudeDelta: 0.014)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                mapView.region = region

                if !startedLoadingPOIs {
                    startedLoadingPOIs = true

                    let apiManager = APIManager()
                    apiManager.loadPOIs(for: location, within: 1_000, completion: { (places, error) in
                        if let _ = error {
                            let alert = UIAlertController(title: "Error", message: "Could not load points of interest. Please check Internet connection, then close and reload app.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else if let loadedPlaces = places {
                            print("Finding POIs")
                            self.places = loadedPlaces

                            let annotations = loadedPlaces.map({ (place) -> PlaceAnnotation in
                                return PlaceAnnotation(location: place.location!.coordinate, title: place.name)
                            })

                            DispatchQueue.main.async {
                                annotations.forEach({ (annotation) in
                                    self.mapView.addAnnotation(annotation)
                                })
                            }
                        }
                    })
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's location")
    }
}

extension ViewController: ARDataSource, AnnotationViewDelegate {
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        let annotationView = AnnotationView()
        annotationView.annotation = viewForAnnotation
        annotationView.delegate = self
        annotationView.loadUI()

        guard let place = viewForAnnotation as? Place else {
            return annotationView
        }

        guard let titleLabel = annotationView.titleLabel else {
            return annotationView
        }

        let expectedLabelSize = place.name.size(attributes: [NSFontAttributeName: titleLabel.font])
        let labelWidth = expectedLabelSize.width + 75.0 > 200.0 ? expectedLabelSize.width + 75.0: 200.0

        annotationView.frame = CGRect(x: 0, y: 0, width: labelWidth, height: 70)

        return annotationView
    }

    func didTouch(annotationView: AnnotationView) {
        if let annotation = annotationView.annotation as? Place {
            self.showDetailView(forPlace: annotation)
        }
    }
}
