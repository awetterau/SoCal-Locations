//
//  ContentView.swift
//  Locations
//
//  Created by August Wetterau on 11/15/21.
//

import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI
import Firebase
import FirebaseFirestore
import Foundation


class currentFilter: ObservableObject {
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    @Published public var showUserPlaces = true
    @Published public var searchText = ""
    @Published public var filterTagList: [String] = [""]
    @Published public var favoriteList: [String] = [""]
    @Published public var mapView = true
    @Published var isView = false
    @Published var isAbandoned = false
    @Published var isFavorite = false
    @Published var userLocation = false
    @Published var isFood = false
    @Published var isRoad = false
    @Published var yes = false
    @Published var no = false
    @Published var customLocation = MapLocation(latitude: 0, longitude: 0)
    @Published var selectedLocation = Location(
        name: "Eleanor Roosevelt High School",
        nickName: "Roosevelt",
        latitude: 33.952930,
        longitude: -117.569250,
        address: "7447 Scholar Way, Eastvale, CA 92880",
        tags: ["School", "Risky"])
    
    @Published var mapLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 33.963251, longitude: -117.588717), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))

}

struct ContentView: View {
    private var selectColor = Color.green
    @State var places: [placesModel] = []
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    private let defaults = UserDefaults.standard
    @State var shownList: [Location] = locationList().list.sorted { $0.name < $1.name }
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    @ObservedObject var filter: currentFilter
    @ObservedObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 33.9525, longitude: -117.5848), span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
    @State private var centerCoordinate = CLLocationCoordinate2D()

    @State var annotations = [MKPointAnnotation]()
    @State var mapView = true
    @State var listView = false
    @State var changeName = false
    @EnvironmentObject var userData: mainModel
    @State var filterView = false
    

    func load() {
        let savedFilterList = defaults.array(forKey: "Favorites") as? [String]
        filter.favoriteList = savedFilterList ?? [""]
    }
    
    func filterTagResults(item: Location) -> Bool {
        var isShown = false

        for tag in 0...filter.filterTagList.count-1 {
            if ((filter.filterTagList[tag] != "") && (filter.filterTagList.count > 1)) {
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

    public func updateAnnotations() {

        annotations.removeAll()
        
        
        if filter.showUserPlaces {
            if places.count != 0 {
                for i in 0...places.count-1 {
                let newLocation = MKPointAnnotation()
                newLocation.coordinate = CLLocationCoordinate2D(latitude: places[i].Latitude, longitude: places[i].Longitude)
                newLocation.title = places[i].placeName
                annotations.append(newLocation)
            }
        }
        }
        for i in 0...shownList.count-1 {
            if filterTagResults(item: shownList[i]) {
                if (filter.searchText != "") {
                    
                    if ((shownList[i].name.contains(filter.searchText)) || (shownList[i].nickName.contains(filter.searchText))) {
                        
                        if filter.isFavorite {
                        if filter.favoriteList.contains(shownList[i].name) {
                        let newLocation = MKPointAnnotation()
                        newLocation.coordinate = shownList[i].getCoordinate()
                        newLocation.title = shownList[i].name
                       annotations.append(newLocation)
                
                   
                        }
                        } else {
                            let newLocation = MKPointAnnotation()
                            newLocation.coordinate = shownList[i].getCoordinate()
                            newLocation.title = shownList[i].name
                           annotations.append(newLocation)
                 
                        }
                    }
                } else {
                    if filter.isFavorite {
                    if filter.favoriteList.contains(shownList[i].name) {
                    let newLocation = MKPointAnnotation()
                    newLocation.coordinate = shownList[i].getCoordinate()
                    newLocation.title = shownList[i].name
                   annotations.append(newLocation)
            
               
                    }
                    } else {
                        let newLocation = MKPointAnnotation()
                        newLocation.coordinate = shownList[i].getCoordinate()
                        newLocation.title = shownList[i].name
                       annotations.append(newLocation)
             
                    }
                }
            
        }
     
        }
        places.removeAll()
        
    }
    
    public func updateList() {
        let db = Firestore.firestore()
        //Load Places
        let ref = db.collection("Places")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let PlaceName = data["placeName"] as? String ?? ""
                    let UserName = data["userName"] as? String ?? ""
                    let longitude = data["Longitude"] as? Double ?? 1.0
                    let latitude = data["Latitude"] as? Double ?? 1.0
                    let tags = data["tags"] as? Array<String> ?? [""]
                    
                    let location = Location(name: PlaceName, nickName: UserName, latitude: latitude, longitude: longitude, address: "16321 Aviano Ln, Chino Hills, CA 9170", tags: tags)
                    
                    var duplicate = false
                    for i in shownList {
                        if i.name == PlaceName {
                            duplicate = true
                        }
                    }
                    if duplicate == false {
                        shownList.append(location)
                    }
                }
            }
        }
        shownList = shownList.sorted { $0.name < $1.name }
    }
    init() {
        
        
    filter = currentFilter()
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "HelveticaNeue", size: 40)!]
        
        UITabBarItem.appearance().setTitleTextAttributes([.font : UIFont(name: "HelveticaNeue", size: 15)!], for: [])
        UITabBar.appearance().isTranslucent = false
        load()
 
        
    }
    func getButton(Item: Location) -> Button<HStack<TupleView<(Text, Spacer, Image)>>> {
       return (Button(action: {
            viewControllerHolder?.present(style: .overFullScreen, builder: {
                PlaceView(filter: filter, mainModel: userData, listItem: Item)
                            })
        }) {
            HStack() {
                Text(Item.name)
                Spacer()
                Image(systemName: "chevron.right")
             }
        })
    }
    
    var body: some View {
        
        return ZStack() {
            NavigationView() {
            
                ZStack() {
                 
                        
                        
                        
                    if mapView {
                        ZStack() {
                            MapView(annotations: annotations, selectedPlace: $selectedPlace,showingPlaceDetails: $showingPlaceDetails, filter: filter ).ignoresSafeArea(.all).environmentObject(userData).onAppear(perform: {
                                
                                updateList()
                                updateAnnotations()
                                
                            })
                            
                        }.sheet(isPresented: self.$filter.yes, content: {
                            PlaceView(filter: filter, mainModel: userData, listItem: filter.selectedLocation)
                            
                        })
                    }
                    if listView {
                        VStack(spacing: 20) {
                       
                            Spacer()
                    List() {
                        
                        
                        
                        ForEach(shownList) { item in
                            
                      
                           
                            if filterTagResults(item: item) {
                                if (filter.searchText != "") {
                                    if ((item.name.contains(filter.searchText)) || (item.nickName.contains(filter.searchText))) {
             
                                        if filter.isFavorite {
                                        if filter.favoriteList.contains(item.name) {
          
                                            getButton(Item: item)
                                    }
                                        } else {
                                           getButton(Item: item)
                                        }
                                    }
                                } else {
                                    if filter.isFavorite {
                                    if filter.favoriteList.contains(item.name) {
                                        Button(action: {
                                            viewControllerHolder?.present(style: .overFullScreen, builder: {
                                                PlaceView(filter: filter, mainModel: userData, listItem: item)
                                                            })
                                        }) {
                                            HStack() {
                                                Text(item.name)
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                            }
                                        }
                                }
                                    } else {
                                        Button(action: {
                                            viewControllerHolder?.present(style: .overFullScreen, builder: {
                                                PlaceView(filter: filter, mainModel: userData, listItem: item)
                                                            })
                                        }) {
                                            HStack() {
                                                Text(item.name)
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                            }
                                        }
                                    }
                                }
                            
                            }
                        }.onAppear(perform: {
                            
                            updateList()
                            
                        })
                    }.navigationTitle("List")
                        }
                    }
                    if changeName {
                        SendLocationView(filter: filter).environmentObject(filter)
                    }
                    
              
                    
                    
            VStack() {
                if mapView || listView {
                    VStack {
                    HStack() {
                        
                        ZStack {
                            Rectangle()
                                .background(Color(UIColor.quaternaryLabel))
                            HStack {
                                Image(systemName: "magnifyingglass")
                                if #available(iOS 15.0, *) {
                                    TextField("Search ..", text: $filter.searchText).onChange(of: filter.searchText) { text in
                                        
                                        updateAnnotations()
                                    }.submitLabel(.done)
                                } else {
                                    TextField("Search ..", text: $filter.searchText).onChange(of: filter.searchText) { text in
                                        
                                        updateAnnotations()
                                    }
                                }
                                
                            }
                            .foregroundColor(.gray)
                            .padding(.leading)
                            
                        }
                        .frame(height: 35)
                        .cornerRadius(13)
                        .padding(.leading)
                        
                        
                    
                        
                        ZStack() {
                            HStack {
                                Text("Filter")
                                    .font(.title3)
                                    .foregroundColor(Color.primary)
                                Image(systemName: self.filterView ? "chevron.down" : "chevron.up").padding(.trailing)
                            }
                            Rectangle()
                                .foregroundColor(Color(UIColor.quaternaryLabel))
                                .frame(width: 100, height: 40)
                                .cornerRadius(16).padding(.trailing)
                        }.onTapGesture(perform: {
                            filterView.toggle()
                            updateAnnotations()
                        })
                    }.animation(.none)
                        if filterView {
                          
                                
                                VStack() {

                                    HStack() {
                                    Text("Tags:")
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .padding(.top)
                                        .padding(.leading)
                                    Spacer()
                                    }
                                        
                                    HStack() {
                                        VStack(alignment: .leading) {
                                            
                                            Button(action: {
                                                        
                                                        if !filter.isAbandoned {
                                                            filter.isAbandoned = true
                                                        filter.filterTagList.append("Abandoned")
                                                        } else {
                                                            filter.isAbandoned = false
                                                            if let index = filter.filterTagList.firstIndex(of: "Abandoned") {
                                                                filter.filterTagList.remove(at: index)
                                                            }
                                                        }
                                                updateAnnotations()
                                                    }) {
                                                        if !filter.isAbandoned {
                                                            HStack() {
                                                                ZStack() {
                                                                    Circle()
                                                                        .stroke(Color.primary, lineWidth: 2)
                                                                        .frame(width: 30, height: 30)
                                                                    
                                                                }
                                                                Text("Abandoned")
                                                                    .bold()
                                                                    .foregroundColor(.primary)
                                                                    .font(.title3)
                                                            }
                                                        } else {
                                                            ZStack() {
                                                                
                                                                Circle()
                                                                    .stroke(Color.primary, lineWidth: 2)
                                                                    .frame(width: 30, height: 30)
                                                                    .background(Circle()
                                                                                    .fill(selectColor))
                                                                Image(systemName: "checkmark")
                                                                    .frame(width: 10, height: 10)
                                                                    .foregroundColor(.primary)
                                                                
                                                            }
                                                            Text("Abandoned")
                                                                .bold()
                                                                .foregroundColor(selectColor)
                                                                .font(.title3)
                                                        }
                                                    }
                                            
                                            Button(action: {
                                                filter.isFavorite.toggle()
                                                updateAnnotations()
                                            }) {
                                                if !filter.isFavorite {
                                                    HStack() {
                                                        ZStack() {
                                                            Circle()
                                                                .stroke(Color.primary, lineWidth: 2)
                                                                .frame(width: 30, height: 30)
                                                            
                                                        }
                                                        Text("Favorites")
                                                            .bold()
                                                            .foregroundColor(.primary)
                                                            .font(.title3)
                                                    }
                                                } else {
                                                    ZStack() {
                                                        
                                                        Circle()
                                                            .stroke(Color.primary, lineWidth: 2)
                                                            .frame(width: 30, height: 30)
                                                            .background(Circle()
                                                                            .fill(selectColor))
                                                        Image(systemName: "checkmark")
                                                            .frame(width: 10, height: 10)
                                                            .foregroundColor(.primary)
                                                        
                                                    }
                                                    Text("Favorite")
                                                        .bold()
                                                        .foregroundColor(selectColor)
                                                        .font(.title3)
                                                }
                                            }

                                            Button(action: {
                                                        
                                                        if !filter.userLocation {
                                                            filter.userLocation = true
                                                        filter.filterTagList.append("userLocation")
                                                        } else {
                                                            filter.userLocation = false
                                                            if let index = filter.filterTagList.firstIndex(of: "userLocation") {
                                                                filter.filterTagList.remove(at: index)
                                                            }
                                                        }
                                                updateAnnotations()
                                                    }) {
                                                        if !filter.userLocation {
                                                            HStack() {
                                                                ZStack() {
                                                                    Circle()
                                                                        .stroke(Color.primary, lineWidth: 2)
                                                                        .frame(width: 30, height: 30)
                                                                    
                                                                }
                                                                Text("User Discovered")
                                                                    .bold()
                                                                    .foregroundColor(.primary)
                                                                    .font(.title3)
                                                            }
                                                        } else {
                                                            ZStack() {
                                                                
                                                                Circle()
                                                                    .stroke(Color.primary, lineWidth: 2)
                                                                    .frame(width: 30, height: 30)
                                                                    .background(Circle()
                                                                                    .fill(selectColor))
                                                                Image(systemName: "checkmark")
                                                                    .frame(width: 10, height: 10)
                                                                    .foregroundColor(.primary)
                                                                
                                                            }
                                                            Text("User Discovered")
                                                                .bold()
                                                                .foregroundColor(selectColor)
                                                                .font(.title3)
                                                        }
                                                    }
                                            
                                        }.padding(.leading)
                                        Spacer()
                                        VStack(alignment: .leading) {

                                            Button(action: {
                                                        
                                                        if !filter.isView {
                                                            filter.isView = true
                                                        filter.filterTagList.append("View")
                                                        } else {
                                                            filter.isView = false
                                                            if let index = filter.filterTagList.firstIndex(of: "View") {
                                                                filter.filterTagList.remove(at: index)
                                                            }
                                                        }
                                                updateAnnotations()
                                                    }) {
                                                        if !filter.isView {
                                                            HStack() {
                                                                ZStack() {
                                                                    Circle()
                                                                        .stroke(Color.primary, lineWidth: 2)
                                                                        .frame(width: 30, height: 30)
                                                                    
                                                                }
                                                                Text("View")
                                                                    .bold()
                                                                    .foregroundColor(.primary)
                                                                    .font(.title3)
                                                            }
                                                        } else {
                                                            ZStack() {
                                                                
                                                                Circle()
                                                                    .stroke(Color.primary, lineWidth: 2)
                                                                    .frame(width: 30, height: 30)
                                                                    .background(Circle()
                                                                                    .fill(selectColor))
                                                                Image(systemName: "checkmark")
                                                                    .frame(width: 10, height: 10)
                                                                    .foregroundColor(.primary)
                                                                
                                                            }
                                                            Text("View")
                                                                .bold()
                                                                .foregroundColor(selectColor)
                                                                .font(.title3)
                                                        }
                                                    }
                                            
                                            Button(action: {
                                                        
                                                        if !filter.isFood {
                                                            filter.isFood = true
                                                        filter.filterTagList.append("Food")
                                                        } else {
                                                            filter.isFood = false
                                                            if let index = filter.filterTagList.firstIndex(of: "Food") {
                                                                filter.filterTagList.remove(at: index)
                                                            }
                                                        }
                                                updateAnnotations()
                                                    }) {
                                                        if !filter.isFood {
                                                            HStack() {
                                                                ZStack() {
                                                                    Circle()
                                                                        .stroke(Color.primary, lineWidth: 2)
                                                                        .frame(width: 30, height: 30)
                                                                    
                                                                }
                                                                Text("Food")
                                                                    .bold()
                                                                    .foregroundColor(.primary)
                                                                    .font(.title3)
                                                            }
                                                        } else {
                                                            ZStack() {
                                                                
                                                                Circle()
                                                                    .stroke(Color.primary, lineWidth: 2)
                                                                    .frame(width: 30, height: 30)
                                                                    .background(Circle()
                                                                                    .fill(selectColor))
                                                                Image(systemName: "checkmark")
                                                                    .frame(width: 10, height: 10)
                                                                    .foregroundColor(.primary)
                                                                
                                                            }
                                                            Text("Food")
                                                                .bold()
                                                                .foregroundColor(selectColor)
                                                                .font(.title3)
                                                        }
                                                    }
                                            
                                            Button(action: {
                                                        
                                                        if !filter.isRoad {
                                                            filter.isRoad = true
                                                        filter.filterTagList.append("Road")
                                                        } else {
                                                            filter.isRoad = false
                                                            if let index = filter.filterTagList.firstIndex(of: "Road") {
                                                                filter.filterTagList.remove(at: index)
                                                            }
                                                        }
                                                updateAnnotations()
                                                    }) {
                                                        if !filter.isRoad {
                                                            HStack() {
                                                                ZStack() {
                                                                    Circle()
                                                                        .stroke(Color.primary, lineWidth: 2)
                                                                        .frame(width: 30, height: 30)
                                                                    
                                                                }
                                                                Text("Road")
                                                                    .bold()
                                                                    .foregroundColor(.primary)
                                                                    .font(.title3)
                                                            }
                                                        } else {
                                                            ZStack() {
                                                                
                                                                Circle()
                                                                    .stroke(Color.primary, lineWidth: 2)
                                                                    .frame(width: 30, height: 30)
                                                                    .background(Circle()
                                                                                    .fill(selectColor))
                                                                Image(systemName: "checkmark")
                                                                    .frame(width: 10, height: 10)
                                                                    .foregroundColor(.primary)
                                                                
                                                            }
                                                            Text("Road")
                                                                .bold()
                                                                .foregroundColor(selectColor)
                                                                .font(.title3)
                                                        }
                                                    }
                                            

                                        }
                                        Spacer()
                                    
                                    }.padding(.bottom)

                                    
                                        .navigationTitle("Filter")
                                }.background(RoundedRectangle(cornerRadius: 15).foregroundColor(Color(UIColor.secondarySystemBackground)).opacity( self.listView ? 1 : 0.7)).padding(.horizontal)
                            
                          
                        }
                    Spacer()
                    Spacer()
                    }.animation(.spring())
                }
                Spacer()

                Spacer()
                ZStack() {
                    Rectangle().fill(Color.gray).opacity(0.6).frame(width: UIScreen.main.bounds.width-40, height: 60).cornerRadius(40).multilineTextAlignment(.center)
                    HStack() {
                        Spacer()
                        Button {
                            changeName = false
                            mapView = true
                            listView = false
                            
                        } label: {
                      
                            Image(systemName: "map.fill").font(.largeTitle).foregroundColor(.white)
                              
                        }
                        Spacer()
                        Button {
                            changeName = false
                            listView = true
                            mapView = false
                            
                        } label: {
                            Image(systemName: "list.bullet").font(.largeTitle).foregroundColor(.white)
                        }
                        Spacer()
                        Button {
                            changeName = true
                            listView = false
                            mapView = false
                        } label: {
                            Image(systemName: "figure.stand").font(.largeTitle).foregroundColor(.white)
                        }
                        Spacer()
                    }
                }
                   
            }.navigationBarHidden(true)
                    
            }
            }.onAppear() {
              
                updateAnnotations()
            } .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
       
        
        }
       
        .ignoresSafeArea(.keyboard)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





 

struct ViewControllerHolder {
    weak var value: UIViewController?
}

struct ViewControllerKey: EnvironmentKey {
    static var defaultValue: ViewControllerHolder {
        return ViewControllerHolder(value: UIApplication.shared.windows.first?.rootViewController)
    }
}

extension EnvironmentValues {
    var viewController: UIViewController? {
        get { return self[ViewControllerKey.self].value }
        set { self[ViewControllerKey.self].value = newValue }
    }
}

extension UIViewController {
    func present<Content: View>(style: UIModalPresentationStyle = .automatic, @ViewBuilder builder: () -> Content) {
        let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
        toPresent.modalPresentationStyle = style
        toPresent.rootView = AnyView(
            builder()
                .environment(\.viewController, toPresent)
        )
        self.presentController(toPresent)
    }
    
    func presentController(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.17
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    
    func dismissController() {
        let transition = CATransition()
        transition.duration = 0.17
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false)
    }
}
