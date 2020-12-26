//
//  Card.swift
//  Flashzilla
//
//  Created by Arin Asawa on 12/20/20.
//

import Foundation
struct Card:Codable,Identifiable{
    let prompt:String
    var answer:String
    var id = UUID()
    static func == (lhs: Card, rhs: Card) -> Bool {
        return (lhs.prompt == rhs.prompt) && (lhs.answer == rhs.answer)
    }
    
    static var example:Card{
        Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
    }
}

class CardSet:Codable,Identifiable{
     var cards:[Card]
     var id = UUID()
     var name:String
    var date = Date()
    init(cards:[Card],name:String) {
        self.cards = cards
        self.name = name
    }
    static var example:CardSet{
        CardSet(cards: [Card].init(repeating: Card.example, count: 10), name: "Sample Set")
    }
}

class CardSets:ObservableObject{
    @Published private(set) var sets:[CardSet]
    init() {
        if let data = try? Data(contentsOf: CardSets.getDocumentsDirectory().appendingPathComponent("savedSets")){
            if let decoded = try? JSONDecoder().decode([CardSet].self, from: data){
                self.sets = decoded
                return
            }
        }
        self.sets = [CardSet]()
    }
    private func save(){
        if let encoded = try? JSONEncoder().encode(sets){
            let url = CardSets.getDocumentsDirectory().appendingPathComponent("savedSets")
            do{
                try encoded.write(to: url)
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    static private func getDocumentsDirectory()->URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func add(set:CardSet){
        self.sets.insert(set, at: 0)
        self.save()
    }
    func deleteSet(at IndexSet:IndexSet){
        self.sets.remove(atOffsets: IndexSet)
        self.save()
    }
    
    func changeName(of set:CardSet, to name:String){
        self.objectWillChange.send()
        set.name = name
        self.save()
    }
    func setCards(of set:CardSet, to cards:[Card]){
        set.cards = cards
        self.save()
    }
}


