//
//  SwiftUIView.swift
//  Locations
//
//  Created by August Wetterau on 12/1/21.
//


import SwiftUI
import MapKit
import Combine
import Foundation
import AVFoundation
import UIKit
import CoreLocation
import Firebase
import FirebaseFirestore
import Foundation

struct MapView: UIViewRepresentable {
    var annotations: [MKPointAnnotation]
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingPlaceDetails: Bool
    @State var shownList: [Location] = locationList().list
    @EnvironmentObject var userData: mainModel
    
    @ObservedObject var filter: currentFilter
    
    func filterTagResults(item: Location) -> Bool {
        var isShown = false
        for tag in 0...filter.filterTagList.count-1 {
            if (filter.filterTagList.count > 1) {
                if (item.tags.firstIndex(of: filter.filterTagList[tag]) != nil) {
                isShown = true
            } else {
                isShown = false
                break
            }
            } else {
                isShown = true
            }
        }
        return isShown
   
        
    }
    
    public let mapView = MKMapView()
    
    
    
    func makeUIView(context: Context) -> MKMapView {
            
        let map = MKMapView()
        map.showsCompass = false
        map.region = filter.mapLocation
        map.showsUserLocation = true
        map.delegate = context.coordinator
        

    
        return map
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        if annotations.count != uiView.annotations.count {
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(annotations)
        }
        


    }


    class AnnotationView: MKMarkerAnnotationView {

    static let ReuseID = "cultureAnnotation"


    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "clustering"
        
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
     }
    }
    class Coordinator: NSObject, MKMapViewDelegate {
        
        
        var control: MapView

        
        
        init(_ control: MapView) {
            self.control = control
        }
        


        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) ->
        MKAnnotationView? {
            
                   
                
            if annotation.title != mapView.userLocation.title {
             

            let identifier = "Placemark"
          

            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {

                annotationView = AnnotationView(annotation: annotation, reuseIdentifier: AnnotationView.ReuseID)
                if !((annotationView?.annotation?.debugDescription)!.contains("MKClusterAnnotation")) {

                annotationView?.canShowCallout = true

 
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                } else {
                    annotationView?.canShowCallout = true
                    
                    annotationView?.rightCalloutAccessoryView = UILabel()
                }
            } else {

                annotationView?.annotation = annotation
            }
                
    
            return annotationView
            
            } else {
                return nil
            }
        }
    
       
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let placemark = view.annotation as? MKPointAnnotation else { return }

            self.control.selectedPlace = placemark
            self.control.filter.yes = true
           
            if self.control.userData.places.count != 0 {
                for item in self.control.userData.places {
                    if (item.placeName == placemark.title) {
                        self.control.filter.selectedLocation = Location(name: item.placeName, nickName: item.user, latitude: item.Latitude, longitude: item.Longitude, address: "N/A", tags: item.tags)
                        break
                    }
                }
            }
            for item in locationList().list {
                if (item.nickName == placemark.title || item.name == placemark.title) {
                    self.control.filter.selectedLocation = item
                    break
                }
            }
            
        }
    }
    
}



class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation? = nil
    @Published var location2: CLLocationCoordinate2D?
    @Published var region = MKCoordinateRegion()
    
    
    override init() {
        
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
  
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location2 = locations.first?.coordinate
        guard let location = locations.last else {
            
            return
        }
        
        self.locationManager.stopUpdatingLocation()
        self.location = location
        
        locations.last.map {
                    let center = CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                    region = MKCoordinateRegion(center: center, span: span)
                }
    }
    
}


