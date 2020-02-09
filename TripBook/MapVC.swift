//
//  ViewController.swift
//  TripBook
//
//  Created by HadyHammad on 2/8/20.
//  Copyright © 2020 HadyHammad. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    // MARK :- Instance
    static func instance () -> MapVC{
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MapVC") as! MapVC
    }
    
    // MARK :- Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var commentTxtField: UITextField!
    
    // MARK :- Properities
    var locationManager = CLLocationManager()
    var location : Location?
    var choosenLatitude : Double = 0
    var choosenLongitude : Double = 0
    var transmitLocation : Location?
    
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
        setupLocation()
    }
    
    func setupLocation(){
        if let location = self.transmitLocation{
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            annotation.coordinate = coordinate
            annotation.title = location.title
            annotation.subtitle = location.subtitle
            self.nameTxtField.text = location.title
            self.commentTxtField.text = location.subtitle
            self.mapView.addAnnotation(annotation)
        }
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
            print(choosenCoordinates.latitude,choosenCoordinates.longitude)
            self.choosenLatitude = choosenCoordinates.latitude
            self.choosenLongitude = choosenCoordinates.longitude
            let annotation = MKPointAnnotation()
            annotation.coordinate = choosenCoordinates
            annotation.title = nameTxtField.text
            annotation.subtitle = commentTxtField.text
            self.mapView.addAnnotation(annotation)
        }
        
    }
    
    @IBAction func SaveButtonClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        location = Location(context: context)
        location?.title = self.nameTxtField.text
        location?.subtitle = self.commentTxtField.text
        location?.latitude = self.choosenLatitude
        location?.longitude = self.choosenLongitude
        appDelegate.saveContext()
    }
    
}

