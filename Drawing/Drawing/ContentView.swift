//
//  ContentView.swift
//  Drawing
//
//  Created by Arin Asawa on 11/15/20.
//

import SwiftUI


struct ContentView: View {
    @State  var lineWidth = 10.0
    var body: some View {
        NavigationView{
            VStack(alignment: .leading, spacing: 10){
            NavigationLink(destination: Arrow()) {
                Text("Challenge 1 - Arrow With Animatable Thickness")
                    .font(.title)
            }
            .padding(.top)
            NavigationLink(destination: ColorCyclingRectangle()) {
                Text("Challenge 2 - Color Cycling Rectangle")
                    .font(.title)
            }
                
                Spacer()
        }
        .navigationBarTitle("Project 9 - Drawing")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
