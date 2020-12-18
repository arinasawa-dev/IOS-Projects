
import MapKit
import SwiftUI

struct EditView: View {
    enum LoadingState {
        case loading, loaded, failed
    }

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var placemark: MKPointAnnotation
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    @Binding var locations:[Location]
    @State var placemarkIndex:Int
    @State  var type:String
    let types = ["BucketList","Visited"]

    var body: some View {
        NavigationView {
            VStack{
                Form {
                    Section {
                        TextField("Place name", text: $placemark.wrappedTitle)
                        TextField("Description", text: $placemark.wrappedSubtitle)
                    }
                    
                    Section(header: Text("Choose The Type")){
                        Picker("", selection: $type) {
                            ForEach(types,id:\.self){type in
                                Text(type)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }

                    Section(header: Text("Nearby…")) {
                        if loadingState == .loaded {
                            List(pages, id: \.pageid) { page in
                                Text(page.title)
                                    .font(.headline)
                                + Text(": ") +
                                Text(page.description)
                                    .italic()
                            }
                        } else if loadingState == .loading {
                            Text("Loading…")
                        } else {
                            Text("Please try again later.")
                        }
                    }
                }
                
                Button("Delete"){
                    self.locations.remove(at: placemarkIndex)
                    self.presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .foregroundColor(Color.white)
                .background(Color.red)
                .clipShape(Capsule())
                .padding(.top)
                .padding(.bottom)

            }
            .navigationBarTitle("Edit place")
            .navigationBarItems(trailing: Button("Done") {
                self.locations[placemarkIndex].type = self.type
                print(self.type)
                self.presentationMode.wrappedValue.dismiss()
            })
            .onAppear(perform: fetchNearbyPlaces)
        }
    }

    func fetchNearbyPlaces() {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(placemark.coordinate.latitude)%7C\(placemark.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                // we got some data back!
                let decoder = JSONDecoder()

                if let items = try? decoder.decode(Result.self, from: data) {
                    // success – convert the array values to our pages array
                    self.pages = Array(items.query.pages.values).sorted()
                    self.loadingState = .loaded
                    return
                }
            }
            // if we're still here it means the request failed somehow
            self.loadingState = .failed
        }.resume()
    }
}

