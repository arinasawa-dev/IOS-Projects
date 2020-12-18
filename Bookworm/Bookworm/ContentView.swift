//
//  ContentView.swift
//  Bookworm
//
//  Created by Arin Asawa on 11/19/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
                    NSSortDescriptor(keyPath: \Book.title, ascending: false),
                    NSSortDescriptor(keyPath: \Book.author, ascending: false)
    ]) var books:FetchedResults<Book>
    @State private var showingAddScreen = false
    let filteringOptions = ["Title","Rating","Date Of Entry"]
    @State private var selection = "Title"
    var body: some View {
        NavigationView{
            VStack {
                List{
                    ForEach(books.sorted(by: { (book1, book2) -> Bool in
                        if selection == "Rating"{
                            return book1.rating > book2.rating
                        }else if selection == "Date Of Entry"{
                            return book1.date ?? Date() > book2.date ?? Date()
                        }else{
                            return true
                        }
                    }), id: \.self){book in
                    NavigationLink(
                        destination: DetailView(book:book),
                        label: {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            VStack(alignment: .leading){
                                Text(book.title ?? "Unknown Title")
                                    .font(.headline)
                                    .foregroundColor(Int(book.rating) == 1 ? .red : .black)
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                                
                            }
                        })
                    }
                    .onDelete(perform: deleteBooks)
                }
                    .navigationBarTitle("Bookworm")
                .navigationBarItems(leading: EditButton(),trailing:
                                            Button(action: {self.showingAddScreen.toggle()}, label: {
                            Image(systemName: "plus")
                        }))
                Spacer()
                Text("Filter By:")
                Picker(selection: $selection, label: Text("Filter By: \(selection)")) {
                    ForEach(filteringOptions, id: \.self){option in
                        Text(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

            }
        }
        .sheet(isPresented: $showingAddScreen){
            AddBookView().environment(\.managedObjectContext, moc)
        }
    }
    
    func deleteBooks(at offsets:IndexSet){
        for offset in offsets{
            let book = books[offset]
            moc.delete(book)
        }
        try? moc.save()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
