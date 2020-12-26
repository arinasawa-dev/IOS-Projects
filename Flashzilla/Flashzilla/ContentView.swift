//
//  ContentView.swift
//  Flashzilla
//
//  Created by Arin Asawa on 12/24/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var sets = CardSets()
    var body: some View {
        TabView{
            MySetsView(cardSets: sets)
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("My Sets")
                }
            SetSelectionView(sets: sets)
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Practice")
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
