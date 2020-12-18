//
//  AddBook.swift
//  Bookworm
//
//  Created by Arin Asawa on 11/20/20.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext)  var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    let dateOfEntry = Date()
    var isValidEntry : Bool{
        if title.trimmingCharacters(in: .whitespaces).isEmpty || author.trimmingCharacters(in: .whitespaces).isEmpty || genre.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        return true
    }
    let genres = ["Fantasy","Horror","Kids","Mystery","Poetry","Romance","Thriller"]

    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Date Of Entry : \(DateHelper.date2String(date: self.dateOfEntry))")){
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    Picker("Genre", selection: $genre){
                        ForEach(genres,id:\.self){
                            Text($0)
                        }
                    }
                }
                Section{
                    HStack{
                        Spacer()
                        RatingView(rating: $rating)
                        Spacer()
                    }
                    
                    TextField("Write A Review",text:$review)
                }
                
                Section{
                    Button("Save"){
                        let newBook = Book(context: moc)
                        newBook.title = title
                        newBook.author = author
                        newBook.rating = Int16(rating)
                        newBook.genre = genre
                        newBook.review = review
                        try? self.moc.save()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(!isValidEntry)
                }
            }
            .navigationBarTitle(Text("Add A Book"))
        }
    }
    
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
