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
    var locationManager  = CLLocationManager()
    var location         : Location?
    var choosenLatitude  : Double = 0
    var choosenLongitude : Double = 0
    var transmitLocation : Location?
    var requestLocation  : CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mapView and location manager attributes
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(getsureRecognizer:)))
        recognizer.minimumPressDuration = 2
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let reuseId = "myAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = btn
        }else{
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let long = transmitLocation?.longitude, long != 0 ,let lat = transmitLocation?.latitude, lat != 0{
            requestLocation = CLLocation(latitude: lat, longitude: long)
        }
        CLGeocoder().reverseGeocodeLocation(requestLocation!, completionHandler: { (placemarks, error) in
            if let placemark = placemarks, placemark.count > 0{
                let newPlaceMark = MKPlacemark(placemark: placemark[0])
                let item = MKMapItem(placemark: newPlaceMark)
                item.name = self.transmitLocation?.title
                let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                item.openInMaps(launchOptions: launchOptions)
            }
        })
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
        let alert = UIAlertController(title: "\"\( self.nameTxtField.text ?? "" )\" added success", message: "Press OK to show saved locations list ", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newLocationCreated"), object: nil)
            self.navigationController?.popViewController(animated: true)
        })
        
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.nameTxtField.text = nil
            self.commentTxtField.text = nil
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newLocationCreated"), object: nil)
            self.mapView.removeAnnotations(self.mapView.annotations)
        })
        alert.addAction(noAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

