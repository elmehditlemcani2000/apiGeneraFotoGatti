//
//  ContentView.swift
//  apiGeneraFotoGatti
//
//  Created by user on 23/06/22.
//

import SwiftUI
import SwiftyJSON

struct ContentView: View {
    @ObservedObject var cat = gattoParser()
    
    var body: some View {
        NavigationView {
                VStack {
                    List(cat.gatto) { i in
                        Text("CAT : \(i.name)")
                        Text("DESCRIPTION BREED : \(i.description)").background(.white)
                        Text("ORIGIN : \(i.origin)").background(.white)
                        Text("IMAGE: ")
                        
                        AsyncImage(url: URL(string: i.image)) {
                        phase in
                            //Text (i.image)
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .padding()
                                    .aspectRatio(contentMode: .fit)
                            case .failure:
                                Image(systemName: "image")
                            default:
                                ProgressView("loading")
                            }
                        }
                    }
                    
                    /*
                    NavigationLink(destination: secondView("caccapupu")) {
                        Text("Hit Me!")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(.white),Color(.blue)]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(40)
                    }
                   
                    AsyncImage(url: URL(string: url)){ phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                                .cornerRadius(20)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300, height: 350)
                                .shadow(color: .gray, radius: 10)
                                .offset(x: 0, y: -50)
                        case .failure:
                            Image(systemName: "image")
                        default:
                            EmptyView()
                        }
                    }*/
                }
        }
    }
}

                


/*struct secondView: View {
    @State var quote = Text("dio")
    var test: String
    var body: some View {
        VStack {
            quote
        }
    }
  
    init(_ test: String) {
        self.test = test
    }
}
 */
/*
 "Scientific Name": "Pristipomoides filamentosus"
 "Species Name": "Crimson Jobfish"
 */

struct fotoBase: Identifiable {
    var id: String
    var name: String
    var description: String
    var origin : String
    var image : String = ""
}

class gattoParser: ObservableObject {
    @Published var gatto = [fotoBase]()
    
    init() {
        let url = URL(string: "https://api.thecatapi.com/v1/breeds")!
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, _, err) in
            if err != nil {
                print(err.debugDescription)
            }
            let json = try! JSON(data: data!)
            print(json)
            for i in json {
                let name = i.1["name"].stringValue
                let description = i.1["description"].stringValue
                let origin = i.1["origin"].stringValue
                let image = i.1["image"]["url"].stringValue
                print(i.1["image"]["url"].stringValue)
                DispatchQueue.main.async {
                    self.gatto.append(fotoBase(id: name, name: name, description: description,origin: origin,image: image))
                    
                }
            }
        }.resume()
    }
}
