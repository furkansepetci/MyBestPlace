//
//  ViewController.swift
//  MyBestPlace
//
//  Created by Furkan Sepetci on 6.08.2022.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class ViewController: UIViewController , MKMapViewDelegate , CLLocationManagerDelegate {
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var commentLabel: UITextField!
    
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
            
            chosenLatitude = touchedCoordinates.latitude
            chosenLongitude = touchedCoordinates.longitude
            
            let annotation = MKPointAnnotation()
            annotation.title = nameLabel.text
            annotation.subtitle = commentLabel.text
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

    @IBAction func saveButton(_ sender: Any) {
        
        if nameLabel.text != "" && commentLabel.text != "" {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let places = NSEntityDescription.insertNewObject(forEntityName: "BestPlace", into: context)
            
            places.setValue(nameLabel.text, forKey: "name")
            places.setValue(commentLabel.text, forKey: "comment")
            places.setValue(UUID(), forKey: "id")
            places.setValue(chosenLatitude, forKey: "latitude")
            places.setValue(chosenLongitude, forKey: "longitude")
            
            do{
                try context.save()
                print("OK")
            }catch{
                print("Error")
            }
        }else{
            alertFunction(message: "PLease Enter Name and Comment")
        }
    }
    
    func alertFunction (message:String){
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction.init(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
}


