//
//  SoCal_LocationsApp.swift
//  SoCal Locations
//
//  Created by August Wetterau on 1/15/23.
//

import SwiftUI
import FirebaseCore
import Firebase

@main
struct SoCal_LocationsApp: App {
    @StateObject var MainModel = mainModel()

    init() {
        FirebaseApp.configure()
    }
  var body: some Scene {
    WindowGroup {
        ContentView().environmentObject(MainModel)
      
    }
  }
}
