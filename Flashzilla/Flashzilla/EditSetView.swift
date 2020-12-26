//
//  AddSetView.swift
//  Flashzilla
//
//  Created by Arin Asawa on 12/24/20.
//

import SwiftUI

struct EditSetView: View {
    var set:CardSet = CardSet(cards: [], name: "")
    @State var cards = [Card]()
    @Environment(\.presentationMode) var presentationMode
     var cardSets:CardSets
    @State var name = ""
    @State var date = Date()
    @State private var newPrompt = ""
    var isAdding:Bool
    @State private var newAnswer = ""
    private var addCardButtonDisabled:Bool{
        return newPrompt.trimmingCharacters(in: .whitespaces).isEmpty || newAnswer.trimmingCharacters(in: .whitespaces).isEmpty
    }
    private var saveSetButtonDisabled:Bool{
        return name.trimmingCharacters(in: .whitespaces).isEmpty || cards.isEmpty
    }
   
    var body: some View {
        VStack{
            Form{
                Section(header: Text(" Date created: \(date2String(date: date))")){
                }
                Section(header: Text("Name")){
                    TextField("Name",text: $name)
                }
                Section(header: Text("Add Cards")){
                    TextField("Prompt",text: $newPrompt)
                    TextField("Answer",text: $newAnswer)
                    HStack{
                        Spacer()
                        Button("Add"){
                            let card = Card(prompt: newPrompt, answer: newAnswer)
                            self.cards.insert(card, at: 0)
                            self.newAnswer = ""
                            self.newPrompt = ""
                        }
                        .disabled(addCardButtonDisabled)
                        Spacer()
                    }
                }
             
                    Section{
                        HStack{
                            Spacer()
                            Button(isAdding ? "Add Set" : "Save Changes"){
                                if isAdding{
                                    set.name = name
                                    set.cards = cards
                                    self.cardSets.add(set: set)
                                }else{
                                    self.cardSets.changeName(of: set, to: name)
                                    cardSets.setCards(of: set, to: cards)
                                }
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            .foregroundColor(Color.orange)
                            .disabled(saveSetButtonDisabled)
                            Spacer()

                        }
                    }
                
                Section{
                    if isAdding{
                        Button("Dismiss"){
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.red)
                    }
                }
                
                Section(header: Text("Cards")){
                    ForEach(cards){card in
                        VStack(alignment: .leading){
                            Text(card.prompt)
                                .font(.headline)
                            Text(card.answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        cards.remove(atOffsets: indexSet)
                    })
                }
            }
        }
        .navigationBarTitle(isAdding  ? "Add Set":name)
    
        
      
    }
    func date2String(date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}

struct EditSetView_Previews: PreviewProvider {
    static var previews: some View {
        EditSetView(cardSets: CardSets(), isAdding: true)
    }
}
