//
//  LocationsList.swift
//  Locations
//
//  Created by August Wetterau on 11/15/21.
//

import Foundation
import MapKit
import SwiftUI
import Firebase
import FirebaseFirestore
import Foundation

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let nickName: String
    let latitude: Double
    let longitude: Double
    let address: String
    let tags: [String]
    let user = false
    func getCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct locationList {
    
    init() {
        addFireBase()
    }
    func addFireBase() {
        
        
    }
    public var list = [
    
        Location(
            name: "Chino View",
            nickName: "Chino View",
            latitude: 33.955884,
            longitude: -117.735301,
            address: "16321 Aviano Ln, Chino Hills, CA 91709",
            tags: ["View"]),
        Location(
            name: "Norco Office View",
            nickName: "Norco Office View",
            latitude: 33.932030,
            longitude: -117.564010,
            address: "2191 Fifth St, Norco, CA 92860",
            tags: ["View"]),
        Location(
            name: "Norco Rocks",
            nickName: "Norco Rocks",
            latitude: 33.919890,
            longitude: -117.514194,
            address: "2662 Vandermolen Dr, Norco, CA 92860",
            tags: ["View"]),
        Location(
            name: "Graffiti Falls",
            nickName: "Graffiti Falls",
            latitude: 33.878779677768556,
            longitude: -117.50010696334903,
            address: "3339 Lincoln St, Riverside, CA 92503",
            tags: ["View"]),
        Location(
            name: "Devil’s Basement",
            nickName: "Devil’s Basement",
            latitude: 33.827249535911605,
            longitude: -117.57684960370644,
            address: "6283 Harrison Avenue, Eastvale, CA 92880",
            tags: ["Abandoned"]),
        Location(
            name: "Abandoned Mall",
            nickName: "Abandoned Mall",
            latitude: 33.92137328930352,
            longitude:  -118.3517041182762,
            address: "12000 Hawthorne Boulevard, Hawthorne, CA",
            tags: ["Abandoned"]),
        Location(
            name: "Pumpkin Rock",
            nickName: "Pumpkin Rock",
            latitude: 33.93110774599895,
            longitude:  -117.51769567854654,
            address: "Vandermolen Drive, Crestview Dr, Norco, CA 92860",
            tags: ["View"]),
        Location(
            name: "Norco Lab",
            nickName: "Norco Lab",
            latitude: 33.91201411638779,
            longitude:  -117.536831,
            address: "1841 Hillside Avenue, Norco, CA 92860",
            tags: ["Abandoned","View"]),
        Location(
            name: "Navy Hangars",
            nickName: "Navy Hangars",
            latitude: 33.710064841891004,
            longitude:  -117.8247991572098,
            address: "MCAS Tustin Blimp Hangar, 1688 Valencia Avenue, Tustin, CA 92782",
            tags: ["Abandoned"]),
        Location(
            name: "Hidden Valley Nature Area",
            nickName: "Hidden Valley Nature Area",
            latitude: 33.95757278095915,
            longitude:  -117.51249814733065,
            address: "Chaparral Trail, Jurupa Valley, CA 92505",
            tags: ["View"]),
    ]
}


