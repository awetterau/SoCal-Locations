//
//  SendLocationView.swift
//  Locations
//
//  Created by August Wetterau on 3/18/22.
//

import SwiftUI
import CoreLocation
import CoreLocationUI
import MapKit
import Firebase
import FirebaseCore
import FirebaseStorage
import UIKit



struct SendLocationView: View {
    @StateObject var locationManager = LocationManager()
    @EnvironmentObject var mainModel: mainModel
    @State var placeName = ""
    @State var placeDesc = ""
    @State var annotations = [MKPointAnnotation]()
    @ObservedObject var filter: currentFilter
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    @State private var userCoords = CLLocation()
    @State var requiredColor = Color.clear
    @State var requiredColor2 = Color.clear
    @State var sentText = false
    @State var Tags: [String] = []
    @State var isAbandoned = false
    @State var isView = false
    @State var isRoad = false
    @State var isFood = false
    @State var isShowingMap = false
    @State var wrongCoords = false
    @State private var isImagePickerShown = false
    @State private var selectedImage: UIImage?
    @State var selectColor = Color.green
    @State var shown = false
    @State var showActionSheet = false
    @State var showImagePicker = false
    
    @State var sourceType:UIImagePickerController.SourceType = .camera
    
    @State var upload_image:UIImage?
    @State var download_image:UIImage?
    

    var body: some View {
        
                
        VStack() {
            
            Text("New Location").font(.largeTitle).bold().padding(.horizontal).ignoresSafeArea(.keyboard)
            
            HStack() {
                
                
                Text("Name of location").padding(.leading).padding(.top)
                
                Spacer()
            }.ignoresSafeArea(.keyboard)
            TextField(" ", text: $placeName).border(requiredColor).textFieldStyle(.roundedBorder).padding(.horizontal).ignoresSafeArea(.keyboard)
            
            HStack() {
                
                Text("Your Name:").padding(.leading).padding(.top)
                Spacer()
            }.ignoresSafeArea(.keyboard)
            
            TextField(" ", text: $placeDesc).border(requiredColor2).textFieldStyle(.roundedBorder).padding(.horizontal).ignoresSafeArea(.keyboard)
            
            HStack() {
                Spacer()
                VStack(alignment: .leading) {
                    
                    Button(action: {
                        
                        if !isAbandoned {
                            isAbandoned = true
                            Tags.append("Abandoned")
                        } else {
                            isAbandoned = false
                            if let index = Tags.firstIndex(of: "Abandoned") {
                                Tags.remove(at: index)
                            }
                        }
                    }) {
                        if !isAbandoned {
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
                        
                        if !isRoad {
                            isRoad = true
                            Tags.append("Road")
                        } else {
                            isRoad = false
                            if let index = Tags.firstIndex(of: "Road") {
                                Tags.remove(at: index)
                            }
                        }
                    }) {
                        if !isRoad {
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
                }.padding(.top)
                Spacer()
                VStack(alignment: .leading) {
                    
                    Button(action: {
                        
                        if !isView {
                            isView = true
                            Tags.append("View")
                        } else {
                            isView = false
                            if let index = Tags.firstIndex(of: "View") {
                                Tags.remove(at: index)
                            }
                        }
                    }) {
                        if !isView {
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
                        
                        if !isFood {
                            isFood = true
                            
                            Tags.append("Food")
                        } else {
                            isFood = false
                            if let index = Tags.firstIndex(of: "Food") {
                                Tags.remove(at: index)
                            }
                        }
                    }) {
                        if !isFood {
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
                    
                    
                    
                }
                Spacer()
                
            }
            HStack() {
            if upload_image != nil {
                ZStack() {
                    
                    Circle()
                        .stroke(Color.primary, lineWidth: 2)
                        .frame(width: 20, height: 20)
                        .background(Circle()
                            .fill(selectColor))
                    Image(systemName: "checkmark")
                        .frame(width: 3, height: 3)
                        .foregroundColor(.primary)
                    Image(uiImage: mainModel.image)
                    
                }

            } else {
                Circle()
                    .stroke(Color.primary, lineWidth: 2)
                    .frame(width: 20, height: 20)
            }
            
            Button(action: {
                self.showActionSheet = true
            }) {
                Text("*Optional* Choose Picture")
            }.actionSheet(isPresented: $showActionSheet){
                ActionSheet(title: Text("Add a picture to your post"), message: nil, buttons: [
                    .default(Text("Camera"), action: {
                        self.showImagePicker = true
                        self.sourceType = .camera
                    }),
                    .default(Text("Photo Library"), action: {
                        self.showImagePicker = true
                        self.sourceType = .photoLibrary
                    }),
                    
                    .cancel()
                    
                ])
            }.sheet(isPresented: $showImagePicker){
                imagePicker(image: self.$upload_image, showImagePicker: self.$showImagePicker, sourceType: self.sourceType)
                
            }
        }
                            
            


            ZStack() {
                MapWithUserLocation().cornerRadius(15).padding(.horizontal)
                VStack() {
                    Spacer()
                    HStack() {

                        if #available(iOS 15.0, *) {
                            Button(action: {
                                filter.customLocation = MapLocation(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
                            }) {
                                Text("Use Current Location").font(.footnote)
                            }.buttonStyle(.borderedProminent).padding().padding(.leading)
                        } else {
                        }
                        Spacer()
                    }
                }

            }

            VStack(spacing: 7) {
                if !wrongCoords {
                    Text("Selected Location: \(filter.customLocation.longitude), \(filter.customLocation.latitude)").padding(.top).font(.footnote)
                } else {
                    Text("Selected Location: \(filter.customLocation.longitude), \(filter.customLocation.latitude)").border(Color.red, width: 1).padding(.top).font(.footnote)
                }
                if #available(iOS 15.0, *) {
                    Button(action: {
                        if (placeName == "" && placeDesc == "") {
                            requiredColor = Color.red
                            requiredColor2 = Color.red
                            sentText = false
                        } else if placeName == "" {
                            requiredColor = Color.red
                            requiredColor2 = Color.clear
                            sentText = false
                        } else if placeDesc == "" {
                            requiredColor2 = Color.red
                            requiredColor = Color.clear
                            sentText = false
                        } else if (filter.customLocation.longitude == 0 && filter.customLocation.latitude == 0) {
                            requiredColor2 = Color.clear
                            requiredColor = Color.clear
                            wrongCoords = true
                        } else {
                            Tags.append("user")
                            requiredColor2 = Color.clear
                            requiredColor = Color.clear
                            wrongCoords = false
                            sentText = true
                            userCoords = CLLocation(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
                            annotations.removeAll()

                            let newLocation = MKPointAnnotation()
                            newLocation.coordinate = CLLocationCoordinate2D(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
                            newLocation.title = "Marked Location"
                            
                            
                            if upload_image != nil {
                                if let thisImage = self.upload_image {
                                    uploadImage(image: thisImage, name: placeName)
                                } else {
                                    print("")
                                }
                                
                            }
                            
                            mainModel.addData(placeName: placeName, userName: placeDesc, Longitude: filter.customLocation.longitude, Latitude: filter.customLocation.latitude, tags: Tags)
                            filter.customLocation.longitude = 0
                            filter.customLocation.latitude = 0
                            placeName = ""
                            placeDesc = ""
                            upload_image = nil
                            isAbandoned = false
                            isView = false
                            isFood = false
                            isRoad = false
                            Tags.removeAll()


                        }



                    }) {
                        Text("Send Selected Location")
                    }.buttonStyle(.borderedProminent).alert("Location Sent!", isPresented: $sentText) {
                        Button("OK", role: .cancel) { }
                    }
                } else {
                }
                ZStack() {
                    Rectangle().fill(Color.gray).opacity(0.6).frame(width: UIScreen.main.bounds.width-40, height: 60).cornerRadius(40).multilineTextAlignment(.center)
                    HStack() {
                        Spacer()
                        Button {

                        } label: {

                            Image(systemName: "map.fill").font(.largeTitle).foregroundColor(.white)

                        }
                        Spacer()
                        Button {

                        } label: {
                            Image(systemName: "list.bullet").font(.largeTitle).foregroundColor(.white)
                        }
                        Spacer()
                        Button {
                        } label: {
                            Image(systemName: "figure.stand").font(.largeTitle).foregroundColor(.white)
                        }
                        Spacer()
                    }
                }.opacity(0)
            }




            
        }
        .ignoresSafeArea(.keyboard)
    }
    func uploadImage(image:UIImage, name: String){
        
        if let imageData = image.jpegData(compressionQuality: 1){
            let storage = Storage.storage()
            storage.reference().child("images/\(name)").putData(imageData, metadata: nil){
                (_, err) in
                if let err = err {
                    print("an error has occurred - \(err.localizedDescription)")
                } else {
                    print("image uploaded successfully")
                }
            }
        } else {
            print("coldn't unwrap/case image to data")
        }
    }
 
}

struct SendLocationView_Previews: PreviewProvider {
    static var previews: some View {
        SendLocationView(filter: currentFilter())
           
    }
}




extension MKCoordinateRegion {
    
    static func goldenGateRegion() -> MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.819527098978355, longitude:  -122.47854602016669), latitudinalMeters: 5000, longitudinalMeters: 5000)
    }
    
    func getBinding() -> Binding<MKCoordinateRegion>? {
        return Binding<MKCoordinateRegion>(.constant(self))
    }
}

struct MapWithUserLocation: View {
    
    @EnvironmentObject var filter: currentFilter
    @StateObject private var locationManager = LocationManager()
    @State var longPressLocation = CGPoint.zero
    @State public var customLocation = MapLocation(latitude: 0, longitude: 0)
    
    
    var body: some View {
            GeometryReader { proxy in
                Map(coordinateRegion: $locationManager.region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .none, annotationItems: [customLocation],
                    annotationContent: { location in
                    MapMarker(coordinate: location.coordinate, tint: .red)
                })
                .ignoresSafeArea()
                .gesture(LongPressGesture(
                    minimumDuration: 0.25)
                    .sequenced(before: DragGesture(
                        minimumDistance: 0,
                        coordinateSpace: .local))
                        .onEnded { value in
                            switch value {
                            case .second(true, let drag):
                                longPressLocation = drag?.location ?? .zero
                                customLocation = convertTap(
                                    at: longPressLocation,
                                    for: proxy.size)
                                filter.customLocation = customLocation
                                
                                
                                
                            default:
                                break
                            }
                        })
                .highPriorityGesture(DragGesture(minimumDistance: 10))
                
                
            
        }
        
    }


    }

struct MapWithUserLocation_Previews: PreviewProvider {
    static var previews: some View {
        MapWithUserLocation()
    }
}

struct MapLocation: Identifiable {
    let id = UUID()
    var latitude: Double
    var longitude: Double
}

extension MapLocation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
private extension MapWithUserLocation {
    
    func convertTap(at point: CGPoint, for mapSize: CGSize) -> MapLocation {
        let lat = locationManager.region.center.latitude
        let lon = locationManager.region.center.longitude
        
        let mapCenter = CGPoint(x: mapSize.width/2, y: mapSize.height/2)
        
        let xValue = (point.x - mapCenter.x) / mapCenter.x
        let xSpan = xValue * locationManager.region.span.longitudeDelta/2
    
        let yValue = (point.y - mapCenter.y) / mapCenter.y
        let ySpan = yValue * locationManager.region.span.latitudeDelta/2
        
        return MapLocation(latitude: Double(lat) - ySpan, longitude: Double(lon) + xSpan)
    }
}


struct imagePicker:UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var showImagePicker: Bool
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = imagePickerCoordinator
    
    var sourceType:UIImagePickerController.SourceType = .camera
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<imagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> imagePicker.Coordinator {
        return imagePickerCoordinator(image: $image, showImagePicker: $showImagePicker)
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<imagePicker>) {}
    
    
}



class imagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var image: UIImage?
        @Binding var showImagePicker: Bool
    
    init(image:Binding<UIImage?>, showImagePicker: Binding<Bool>) {
            _image = image
            _showImagePicker = showImagePicker
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = uiimage
            showImagePicker = false
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        showImagePicker = false
    }


}
