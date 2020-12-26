//
//  ContentView.swift
//  Flashzilla
//
//  Created by Arin Asawa on 12/20/20.
//

import SwiftUI
import CoreHaptics

struct PracticeView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    @Environment(\.presentationMode) var presentationMode
    @State var cards:[Card]
    @State var showingTimer:Bool
    @State private var isActive = true
    @State var timeRemaining:Int
    var recylingCards:Bool
    var showingInPortraitMode:Bool
    let timer = Timer.publish(every: 1, on: .main, in: .common)
    var body: some View{
        ZStack{
            Image(decorative: "background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack{
                if showingTimer{
                    Text("Time: \(timeRemaining)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal,20)
                        .padding(.vertical,5)
                        .background(
                            Capsule()
                                .fill(Color.black)
                                .opacity(0.75)
                        )
                }
                ZStack{
                    ForEach(0..<cards.count,id: \.self){index in
                         CardView(card: cards[index],disableGestures:false,showingInPortraitMode: showingInPortraitMode){
                            withAnimation{
                                removeCard(at: index)
                            }
                        }
                            .stacked(at: index, in: cards.count)
                        .allowsHitTesting(index == cards.count - 1)
                        .accessibility(hidden: index < self.cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                if cards.isEmpty{
                    Button("Exit",action: {self.presentationMode.wrappedValue.dismiss()})
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
           
            
            if differentiateWithoutColor || accessibilityEnabled{
                VStack{
                    Spacer()
                    HStack{
                        Button(action: {
                            withAnimation{
                                self.removeCard(at: cards.count - 1)
                            }
                        }, label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                            
                        })
                        .accessibility(label: Text("Wrong"))
                        .accessibility(hint: Text("Mark your answers as being incorrect"))
                        Spacer()
                        Button(action: {
                            withAnimation{
                                self.removeCard(at: cards.count - 1)
                            }
                        }) {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Right"))
                        .accessibility(hint: Text("Mark your answers as being correct"))
                       
                        
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            
        }
        }
        .onAppear(perform: {
            print(cards[0].prompt)
            if showingTimer{
                startTimer()
            }
        })
    
        .onReceive(timer) { (time) in
            guard self.isActive else {return}
            if self.timeRemaining >  0 {
               timeRemaining -= 1
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)){_ in
            self.isActive = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)){_ in
            guard cards.isEmpty else {return}
            self.isActive = true
        }
    
        .onAppear{
            isActive = true
        }
        
        
    }
    
    func removeCard(at index:Int){
        guard index >= 0 else {return}
        let card = cards[index]
        self.cards.remove(at: index)
        if recylingCards{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                           self.cards.insert(card, at: 0)
                }
        }
        if cards.isEmpty{
            isActive = false
        }
    }
    func startTimer(){
        timer.connect()
    }
}

extension View{
    func stacked(at position:Int, in total:Int)->some View{
        let offset = CGFloat(total-position)
        return self.offset(CGSize(width: 0, height: offset*10))
    }
}

