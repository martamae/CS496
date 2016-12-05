//
//  Map View Controller.swift
//  RSVP
//
//  Created by Marta Wegner on 11/7/16.
//  Copyright © 2016 Marta Wegner. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class Map_View_Controller: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var eventName: String!
    var address: String!
    
    @IBOutlet weak var name: UILabel!

    @IBOutlet weak var eventMap: MKMapView!

    let locationManager = CLLocationManager()
    
    var currMapItem: MKMapItem?
    var eventMapItem: MKMapItem?
    
    var Route: MKRoute?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.name.text = eventName
        
        eventMap.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
            eventMap.showsUserLocation = true
        
            currMapItem = MKMapItem.forCurrentLocation()
        
            CLGeocoder().geocodeAddressString(address, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
                if let placemarks = placemarks {
                    let placemark = placemarks[0]
                
                    self.eventMapItem = MKMapItem(placemark: MKPlacemark(coordinate: placemark.location!.coordinate, addressDictionary: placemark.addressDictionary as! [String:AnyObject]?))
                
                    let request: MKDirectionsRequest = MKDirectionsRequest()
                    request.source = self.currMapItem
                    request.destination = self.eventMapItem
                    request.transportType = .automobile
                    request.requestsAlternateRoutes = false
                
                    let directions = MKDirections(request: request)
                    directions.calculate(completionHandler: {
                        (response: MKDirectionsResponse?, error: Error?) in
                        if error != nil {
                            print ("ERROR Calculate")
                        }
                        else {
                            self.Route = response?.routes.first
                            self.eventMap.add(self.Route!.polyline)
                            self.eventMap.setVisibleMapRect(self.Route!.polyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0), animated: false)
                        }
                    })
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(locations.last!, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> () in
            if let placemarks = placemarks {
                let _ = placemarks[0]
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        return
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
    
        if (overlay is MKPolyline ){
            polylineRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.75)
    
            polylineRenderer.lineWidth = 5
            
            
        }
    
        return polylineRenderer
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
