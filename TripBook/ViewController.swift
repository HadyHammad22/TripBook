//
//  ViewController.swift
//  TripBook
//
//  Created by HadyHammad on 2/8/20.
//  Copyright © 2020 HadyHammad. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK :- Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var commentTxtField: UITextField!
    
    // MARK :- Properities
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //mapView and location manager attributes
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(getsureRecognizer:)))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
    }
    // Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
    }
    
    @objc func chooseLocation(getsureRecognizer: UILongPressGestureRecognizer){
        if getsureRecognizer.state == UIGestureRecognizer.State.began{
            let touchedPoint = getsureRecognizer.location(in: self.mapView)
            let choosenCoordinates = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = choosenCoordinates
            annotation.title = nameTxtField.text
            annotation.subtitle = commentTxtField.text
            self.mapView.addAnnotation(annotation)
        }
        
    }
    
    @IBAction func SaveButtonClicked(_ sender: Any) {
        
    }
    
}

