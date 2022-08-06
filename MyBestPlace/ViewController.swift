//
//  ViewController.swift
//  MyBestPlace
//
//  Created by Furkan Sepetci on 6.08.2022.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController , MKMapViewDelegate , CLLocationManagerDelegate {

    @IBOutlet weak var myMap: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMap.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(takeLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 3
        myMap.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func takeLocation (gestureRecognizer : UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began{
            let touchedPoint = gestureRecognizer.location(in: self.myMap)
            let touchedCoordinates = self.myMap.convert(touchedPoint, toCoordinateFrom: self.myMap)
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinates
            self.myMap.addAnnotation(annotation)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        myMap.setRegion(region, animated: true)
    }


}

