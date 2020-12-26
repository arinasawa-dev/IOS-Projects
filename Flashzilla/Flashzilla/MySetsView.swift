//
//  mySetsView.swift
//  Flashzilla
//
//  Created by Arin Asawa on 12/24/20.
//

import SwiftUI

struct MySetsView: View {
    @ObservedObject  var cardSets = CardSets()
    @State var showingEditSetScreen = false
    
    
    var body: some View {
        NavigationView{
                List{
                    ForEach(cardSets.sets){set in
                        NavigationLink(destination: EditSetView(set: set, cards: set.cards, cardSets: cardSets, name: set.name, date: set
                                                                    .date, isAdding: false)) {
                            Text(set.name)
                                .fontWeight(.heavy)
                                .foregroundColor( Color.blue)
                                
                        }
                    }
                    .onDelete(perform: { indexSet in
                        cardSets.deleteSet(at: indexSet)
                    })
                }
               
            .navigationBarItems(leading: EditButton().foregroundColor(.red), trailing:
                                    Button(action: {
                                        self.showingEditSetScreen = true
                                    }, label: {
                                        Image(systemName: "plus.app")
                                            .font(.title)
                                            .foregroundColor(.green)
                                    })
                                
            )
            .navigationBarTitle(Text("My Sets"))
            .sheet(isPresented: $showingEditSetScreen, content: {
                EditSetView( cardSets: cardSets,  isAdding: true)
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
}

struct mySetsView_Previews: PreviewProvider {
    static var previews: some View {
        MySetsView()
    }
}
