//
//  mainModel.swift
//  Locations
//
//  Created by August Wetterau on 7/10/22.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import Foundation
import Combine
import FirebaseStorage

class mainModel: ObservableObject {
    @Published var places: [placesModel] = []
    @Published var images: [imagesModel] = []
    @Published var image = UIImage()
    @State var imageURL = ""
    let storage = Storage.storage().reference()
   
    
    init(){
        getData()
    }

    
    public func getData() {
        
        places.removeAll()
        images.removeAll()
        
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
                    
                    let place = placesModel(id: PlaceName, placeName: PlaceName, user: UserName, Latitude: latitude, Longitude: longitude, tags: tags)
                    self.places.append(place)
                    
                    
                    
                    Storage.storage().reference().child("images/\(PlaceName)").getData(maxSize: 15 * 1024 * 1024){
                        (imageData, err) in
                        if let err = err {
                            print("an error has occurred - \(err.localizedDescription)")
                        } else {
                            if let imageData = imageData {
                                self.images.append(imagesModel(id: PlaceName, placeName: PlaceName, image: UIImage(data: imageData)!))
                            } else {
                                print("couldn't unwrap image data image")
                            }
                            
                        }
                    }
                    
                }
            }
        }
        
        
   
        
        
        
        
    }
    
    
    

    
    
    func addData(placeName: String, userName: String, Longitude: Double, Latitude: Double, tags: Array<String>){
        let db = Firestore.firestore()
        let ref = db.collection("Places").document(placeName)
        for _ in db.collection("Places").collectionID {
        }
        ref.setData(["placeName": placeName, "userName": userName, "Longitude": Longitude, "Latitude": Latitude, "tags": tags]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

}

struct imagesModel: Identifiable,Hashable {
    @DocumentID var id: String?
    var placeName: String
    var image: UIImage
    
    enum CodingKeys: String, CodingKey {
        case id
        case placeName
        case image
    }
}
struct placesModel: Codable,Identifiable,Hashable {
    @DocumentID var id: String?
    var placeName: String
    var user: String
    var Latitude: Double
    var Longitude: Double
    var tags: Array<String>
    
    enum CodingKeys: String, CodingKey {
        case id
        case placeName
        case user
        case Latitude
        case Longitude
        case tags
        
        
        
    }
}
struct FirebaseImageView: View {
    @ObservedObject var imageLoader:DataLoader
    @State var image:UIImage = UIImage()
    
    init(imageURL: String) {
        imageLoader = DataLoader(urlString:imageURL)
    }

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:400, height:400)
        }.onReceive(imageLoader.didChange) { data in
            self.image = UIImage(data: data) ?? UIImage()
        }
    }
}

class DataLoader: ObservableObject {
    @Published var didChange = PassthroughSubject<Data, Never>()
    @Published var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        getDataFromURL(urlString: urlString)
    }
    
    func getDataFromURL(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }.resume()
    }
}
