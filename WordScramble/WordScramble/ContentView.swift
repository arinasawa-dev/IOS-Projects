//
//  ContentView.swift
//  WordScramble
//
//  Created by Arin Asawa on 9/4/20.
//  Copyright © 2020 Arin Asawa. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var newWord = ""
    @State private var rootWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var playerScore = 0
    
    var body: some View {
        NavigationView{
            VStack {
                TextField("Enter Your Word", text: $newWord,onCommit: addNewWord)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Section(header: Text("Words Created")){
                    List(usedWords,id: \.self){
                        Image(systemName: "\($0.count).circle")
                        Text($0)
                    }
                }
                Text("Score-\(playerScore)")
            }
            .navigationBarTitle(rootWord)
            .navigationBarItems(leading: Button(action: startGame) {
                    Text("New Word")
                })
            .onAppear {
                self.startGame()
            }
            .alert(isPresented: $showingError){
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            
        }
    }
    
    func addNewWord(){
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        newWord = ""
        guard answer.count>2 else {wordError(title: "Too Short!", message: "Try to come up with a longer word");return}
        guard answer != rootWord.lowercased() else {wordError(title: "Clever but not clever enough", message: "You can't just use the given word!");return}
        guard isOriginal(word: answer) else {wordError(title: "Word used already!", message: "Be more original");return}
        guard isPossible(word: answer) else{wordError(title: "Word not recognized", message: "You cant't just make them up, you know!");return}
        guard isReal(word: answer) else{wordError(title: "Word not possible", message: "That isn't a real world");return}
        updatePlayerScore(word: answer)
        usedWords.insert(answer, at: 0)
    }
    
    //Checking functions
    
    func isOriginal(word:String)->Bool{
        !usedWords.contains(word)
    }
    
    func isPossible(word:String)->Bool{
        var rootWordCopy = rootWord.lowercased()
        for letter in word{
            if let index = rootWordCopy.firstIndex(of: letter){
                rootWordCopy.remove(at: index)
            }else{
                return false
            }
        }
        return true
    }
    
    func isReal(word:String)->Bool{
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    
    func startGame(){
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL){
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle!")
    }
    
    func wordError(title:String,message:String){
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func updatePlayerScore(word:String){
        playerScore = playerScore + (word.count*10)
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
