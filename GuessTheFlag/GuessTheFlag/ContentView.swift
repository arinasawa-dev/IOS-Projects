//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Arin Asawa on 8/27/20.
//  Copyright © 2020 Arin Asawa. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia","France","Germany","Ireland","Italy","Nigeria","Poland","Russia","Spain","UK","US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue,.black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing:20){
                VStack{
                    Text("Tap the flag of")
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                .foregroundColor(.white)
                ForEach(0..<3){number in
                    Button(action: {self.flagTapped(number)}) {
                        FlagImage(name:self.countries[number])
                }

                }
                Text("Your Score Is \(score)")
                    .foregroundColor(Color.white)
                    .font(.body)
                    .fontWeight(.semibold)
                    .padding(.top)
                Spacer()
            }
            .padding()
            
      }
        .alert(isPresented: $showingScore){
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")){
                    self.askQuestion()
                })
        }
    }
    func flagTapped(_ number:Int){
        if number == correctAnswer{
            scoreTitle = "Correct! That is indeed the flag of \(countries[correctAnswer])"
            score += 1
        }else{
            scoreTitle = "Wrong! That is not the flag of \(countries[correctAnswer]), but that of \(countries[number])"
            score -= 1
        }
        showingScore = true
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
