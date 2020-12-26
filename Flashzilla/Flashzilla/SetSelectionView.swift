//
//  SetSelectionView.swift
//  Flashzilla
//
//  Created by Arin Asawa on 12/24/20.
//

import SwiftUI

struct SetSelectionView: View {
    @ObservedObject var sets:CardSets
    @State private var selectedSet = 0
    @State var withTimer = false
    @State var numberOfMinutes = 0.5
    @State var recycleCards = false
    @State var showingPracticeScreen = false
    @State var showInPortraitMode:Bool = false
     private var startButtonIsEnabled:Bool{
        if !sets.sets.isEmpty{
           return true
        }else{
            return false
        }
    
    }
    var body: some View {
        NavigationView{
            VStack{
                Form{
                    Section(header:Text("Pick a set to practice with")){
                        Picker("Set: ", selection : $selectedSet){
                            ForEach(0..<sets.sets.count){
                                Text(sets.sets[$0].name)
                            }
                        }
                    }
                    Section{
                        VStack{
                            HStack{
                                Toggle(isOn: $withTimer.animation(), label: {
                                    Text("Timer")
                                })
                            }
                        }
                        if withTimer{
                            HStack{
                                Picker("Minutes: ", selection: $numberOfMinutes) {
                                    ForEach(1..<201){num in
                                        Text("\(Double(num)*0.5,specifier: "%.2f")").tag(Double(num)*0.5)
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    Section{
                        Toggle("Recycle Cards", isOn: $recycleCards)
                    }
                    
                    Section{
                        Toggle("Portrait Mode", isOn: $showInPortraitMode)
                    }
                    
                    Section{
                        HStack{
                            Spacer()
                            Button("Start!"){
                                print(sets.sets[selectedSet].name)
                                self.showingPracticeScreen = true
                            }
                            .disabled(!startButtonIsEnabled)
                            Spacer()
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $showingPracticeScreen, content: {
                PracticeView(cards: sets.sets[selectedSet].cards, showingTimer: withTimer, timeRemaining:
                                withTimer ?  Int(numberOfMinutes*60) : 10, recylingCards: recycleCards, showingInPortraitMode: showInPortraitMode)
            })
            .navigationBarTitle("Configure Practice")
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
    }


