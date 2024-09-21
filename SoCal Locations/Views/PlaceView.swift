//
//  PlaceView.swift
//  Locations
//
//  Created by August Wetterau on 11/16/21.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation
import FirebaseStorage

struct PlaceView: View {
    static let tagColors: [String: Color] = ["School": .black, "Risky": Color(red: 187/255, green: 33/255, blue: 36/255), "View": .green, "Road": .yellow, "Food": .orange, "Abandoned": Color(red: 187/255, green: 33/255, blue: 36/255), "Chill": Color(red: 173/255, green: 216/255, blue: 230/255), "Lowkey": .purple]
    static let tags: [String] = ["Food", "View", "User", "Road", "Abandoned"]
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    @State var Address1: String = ""
    @ObservedObject var filter: currentFilter
    @ObservedObject var mainModel: mainModel

    var listItem = Location(
        name: "Eleanor Roosevelt High School",
        nickName: "Roosevelt",
        latitude: 33.952930,
        longitude: -117.569250,
        address: "7447 Scholar Way, Eastvale, CA 92880",
        tags: ["School"])
    private let defaults = UserDefaults.standard
    var falses = false
    func save() {
        defaults.set(filter.favoriteList, forKey: "Favorites")
    }
    let paths = Bundle.main.paths(forResourcesOfType: "png", inDirectory: nil)
  
   

    func coordinatesToAddress(latitude: Double, longitude: Double) -> String {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        var addressString = ""
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                print("Error getting address: \(error!.localizedDescription)")
            }
            else if let placemarks = placemarks, placemarks.count > 0 {
                let placemark = placemarks[0]
                addressString = "\(placemark.name ?? ""), \(placemark.locality ?? ""), \(placemark.country ?? "")"
            }
        }
        return addressString
    }
    
    func getIndex() -> UIImage {
        for i in mainModel.images {
            if i.placeName == listItem.name {
                return i.image
            }
        }
        return UIImage()
    }

    var body: some View {
        ZStack() {
            VStack() {
                if !listItem.tags.contains("user") {
                    Image("\(listItem.name)").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea().clipShape(Rectangle()).frame(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height/2)).cornerRadius(1).ignoresSafeArea()
                    Spacer()
                } else {
                    Image(uiImage: getIndex()).resizable().aspectRatio(contentMode: .fill).ignoresSafeArea().clipShape(Rectangle()).frame(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height/2)).cornerRadius(1).ignoresSafeArea()
                    Spacer()
                }
            }
        VStack() {
        
            
            Image("\(listItem.name)").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea().clipShape(Rectangle()).frame(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height/2)).cornerRadius(1).ignoresSafeArea()
            
            
            HStack() {
                
                Text(listItem.name).font(.largeTitle).bold().padding(.leading).multilineTextAlignment(.leading)
                Spacer()
                Button(action: {
                    if filter.favoriteList.contains(listItem.name) {
                        filter.favoriteList.remove(at: filter.favoriteList.firstIndex(of: listItem.name) ?? 0)
                    } else {
                        filter.favoriteList.append(listItem.name)
                    }
                    save()
                    print(filter.favoriteList)
                }) {
                    if filter.favoriteList.contains(listItem.name){
                        Image(systemName: "star.fill").foregroundColor(.white).font(.title).padding(.trailing)
                    } else {
                        Image(systemName: "star").foregroundColor(.white).font(.title).padding(.trailing)
                    }
                }
            }
            HStack() {
                if listItem.tags.contains("user") {
                    Text("Discovered by: \(listItem.nickName)").bold().italic().font(.title3).padding(.leading)
                    Spacer()
                } 
            }
        HStack() {
            
            ForEach(listItem.tags, id: \.self) { tag in
                if tag != "user" {
                    ZStack() {
                        
                        Rectangle()
                            .foregroundColor(Self.tagColors[tag, default: .gray])
                            .frame(width: 80, height: 30)
                            .cornerRadius(20)
                        Text(tag)
                            .bold()
                            .font(.footnote)
                            .foregroundColor(Color.white)
                    }
                }
            }
            Spacer()
        }.padding(.leading)
            ZStack() {
                Rectangle().cornerRadius(20).foregroundColor(Color(UIColor.secondarySystemBackground)).padding(.horizontal).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/6)
                VStack() {
            HStack() {
                Text("Address:").font(.title3).multilineTextAlignment(.leading).padding(.leading).foregroundColor(.secondary)
                Spacer()
            }
                   

            HStack() {
                if !listItem.tags.contains("user") {
                    Link( String(listItem.address), destination: (URL(string:  "http://maps.apple.com/?daddr=\(listItem.latitude),\(listItem.longitude)"))!).padding(.leading)
                } else {
                    Link( coordinatesToAddress(latitude: listItem.latitude, longitude: listItem.longitude), destination: (URL(string:  "http://maps.apple.com/?daddr=\(listItem.latitude),\(listItem.longitude)"))!).padding(.leading)
                    
                }
            Spacer()
            }
            Divider()
                    HStack() {
                        Text("Cordinates:").font(.title3).multilineTextAlignment(.leading).padding(.leading).foregroundColor(.secondary)
                        Spacer()
                    }
                    HStack() {
                        Text("\(listItem.latitude), \(listItem.longitude)").padding(.leading)
                        Spacer()
                    }
                }.clipShape( Rectangle()).cornerRadius(20).padding(.horizontal).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/6)
            }
            Spacer()
        }
            VStack() {
                HStack() {
                    if !filter.yes {
                    Button(action: {
                        
                        viewControllerHolder?.dismissController()
                    }) {
                        Image(systemName: "xmark").padding(.leading).foregroundColor(.white).font(.title3)
                    }
                    }
                    Spacer()
                }
                Spacer()
            }
        }.navigationBarHidden(true).transition(.move(edge: .leading))
        
    }
    
}
struct PlaceView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceView(filter: currentFilter(), mainModel: mainModel(), listItem: locationList().list[0])
    }
}






    
