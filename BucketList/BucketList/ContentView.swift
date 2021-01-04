
import LocalAuthentication
import MapKit
import SwiftUI

struct Location:Codable{
    var annotation:CodableMKPointAnnotation
    var type:String
}


struct ContentView: View {
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [Location]()

    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    @State private var showingEditScreen = false
    @State private var currentFilter = "BucketList"
    var filters = ["BucketList","Visited"]
    @State private var isUnlocked = false
    @State private var showingAuthenticationError = false

    var body: some View {
        ZStack {
            if isUnlocked {
                ModifiedMapView(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, currentFilter: $currentFilter, locations: $locations, showingEditScreen: $showingEditScreen, annotations: getAnnotationsFor(currentFilter))
            } else {
                LinearGradient(gradient: Gradient(colors: [.white, .orange]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
              
                
                
                Button("Unlock Places") {
                    self.authenticate()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .alert(isPresented: $showingPlaceDetails) {
            Alert(title: Text(selectedPlace?.title ?? "Unknown"), message: Text(selectedPlace?.subtitle ?? "Missing place information."), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Edit")) {
                self.showingEditScreen = true
            })
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: {
            if selectedPlace?.title == nil || selectedPlace?.title == ""{
                let index = indexOf(selectedPlace!)
                if !locations.isEmpty{
                    self.locations.remove(at: indexOf(selectedPlace!))
                }
            }
            saveData()
            
        }) {
            if self.selectedPlace != nil {
                let index = indexOf(selectedPlace!)
                EditView(placemark: self.selectedPlace!,locations:$locations,placemarkIndex: index, type: locations[index].type)
            }
        }
        .onAppear(perform: {
            loadData()
        })
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func loadData() {
        let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")

        do {
            let data = try Data(contentsOf: filename)
            locations = try JSONDecoder().decode([Location].self, from: data)
        } catch {
            print("Unable to load saved data.")
        }
    }

    func saveData() {
        do {
            let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
            let data = try JSONEncoder().encode(self.locations)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }

    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                       //handle error
                    }
                }
            }
        } else {
            // no biometrics
        }
    }
    
 
    
    func getAnnotationsFor(_ filter:String)->[CodableMKPointAnnotation]{
        var annotations = [CodableMKPointAnnotation]()
        for location in locations{
            if location.type == filter{
                annotations.append(location.annotation)
            }
        }
        return annotations
    }
    
    func indexOf(_ place:MKPointAnnotation)->Int{
        var index = 0
        for location in locations{
            if location.annotation == place{
                return index
            }
            index = index + 1
        }
        return index
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

