//
//  ModifiedMapView.swift
//  BucketList
//
//  Created by Arin Asawa on 12/17/20.
//

import SwiftUI
import MapKit

struct ModifiedMapView: View {
    @Binding var  centerCoordinate:CLLocationCoordinate2D
    @Binding var selectedPlace:MKPointAnnotation?
    @Binding var showingPlaceDetails:Bool
    @Binding var currentFilter:String
    @Binding var locations:[Location]
    @Binding  var showingEditScreen:Bool
    var annotations:[MKPointAnnotation]
    var body: some View {
        ZStack{
            MapView(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: annotations)
                .edgesIgnoringSafeArea(.all)
            Circle()
                .fill(Color.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)

            VStack {
                Button(currentFilter) {
                    currentFilter = currentFilter == "BucketList" ? "Visited" : "BucketList"
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(Color.white)
                .clipShape(Capsule())
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        let newLocation = Location(annotation: CodableMKPointAnnotation(), type: currentFilter)
                        newLocation.annotation.coordinate = self.centerCoordinate
                        self.locations.append(newLocation)
                        self.selectedPlace = newLocation.annotation
                        self.showingEditScreen = true
                    }) {
                        Image(systemName: "plus")
                            .padding()
                            .background(Color.black.opacity(0.75))
                            .foregroundColor(.white)
                            .font(.title)
                            .clipShape(Circle())
                            .padding(.trailing)
                    }
                   
                }
            }
        }
    }
}

