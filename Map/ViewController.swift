//
//  ViewController.swift
//  Map
//
//  Created by Radha on 11/10/15.
//  Copyright © 2015 TurnToTech. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    var region : MKCoordinateRegion?
    var searchResultAnnotations = [MKAnnotation]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self // Do you need this.
        mapView.frame = self.view.frame
        setCenter()
        //loadRestaurantMarkers()
        
        let lpGesture : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        lpGesture.minimumPressDuration = 1.0
        self.view.addGestureRecognizer(lpGesture)
    }
    
    func setCenter() {
        let center = CLLocationCoordinate2D(
            latitude: 40.720390,
            longitude: -73.987566
        )
        
        searchBar.placeholder = "Search for place or address"
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region!, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "Home"
        annotation.subtitle = "139 Essex Street, New York, NY 10002"
        mapView.addAnnotation(annotation)
    }
    
//    func loadRestaurantMarkers() {
//        let restaurants:Dictionary<String, String> = [
//            "Patacon Pisao"     :   "139 Essex Street, New York, NY 10002",
//            "Beauty & Essex"    :   "146 Essex Street, New York, NY 10002"
//            
//            ]
//        
//        for restaurant in restaurants {
//            CLGeocoder().geocodeAddressString(restaurant.1, completionHandler:
//                {
//                    (placemarks, error) -> Void in
//                    var placeMark: CLPlacemark!
//                    if error == nil {
//                        placeMark = placemarks![0] as CLPlacemark
//                        let annotation = MKPointAnnotation()
//                        annotation.coordinate = placeMark.location!.coordinate
//                        annotation.title = restaurant.0
//                        annotation.subtitle = restaurant.1
//                        self.mapView.addAnnotation(annotation)
//                    }
//                    else {
//                        print("Geocoding failed!: \(error!.localizedDescription)")
//                    }
//            })
//        }
//    }
    
    @IBAction func findPlaces(sender: AnyObject) {
        self.mapView.removeAnnotations(searchResultAnnotations)
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBar.text
        request.region = self.mapView.region
    
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response: MKLocalSearchResponse?, error:NSError?) -> Void in
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else if response!.mapItems.count == 0 {
                print("No matches found")
            } else {
                print("Matches found")
                for item in response!.mapItems {
//                    print("Name = \(item.name)")
//                    print("Phone = \(item.phoneNumber)")
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    self.mapView.addAnnotation(annotation)
                    self.searchResultAnnotations.append(annotation)
                }
            }
        }
    }
    
    
    
    // Add custom markers
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        var anView = self.mapView.dequeueReusableAnnotationViewWithIdentifier((annotation.title!)!)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.title!)
            anView!.image = UIImage(named: "restaurant.png")
            anView!.canShowCallout = true
            print("Adding custom marker for  \(annotation.title!)")
        } else {
            anView!.annotation = annotation
        }
        
        return anView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func longPressed(longPress: UILongPressGestureRecognizer) {
        if (longPress.state == UIGestureRecognizerState.Began) {
            print("Began")
        } else if (longPress.state == UIGestureRecognizerState.Ended){
            print("Ended")
        }
    }

    
}


