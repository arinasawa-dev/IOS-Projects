//
//  DetailVie.swift
//  Bookworm
//
//  Created by Arin Asawa on 11/21/20.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment (\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    let book:Book
    var body: some View {
        GeometryReader{geometry in
            VStack{
                ZStack(alignment:.bottomTrailing){
                    Image(self.book.genre ?? "Fantasy")
                        .frame(maxWidth: geometry.size.width)
                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x:-5,y:-5)
                }
                Text(self.book.author ?? "Unknown Author")
                    .font(.title)
                    .italic()
                    .foregroundColor(.secondary)
                Text(self.book.review ?? "No Review")
                    .padding()
                RatingView(rating: .constant(Int(book.rating)))
                    .font(.largeTitle)
                Text("Date Of Entry: \(DateHelper.date2String(date: book.date ?? Date()))")
                    .foregroundColor(.secondary)
                    .font(.body)
                    .padding(.top)
                Spacer()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {self.showingDeleteAlert = true}){
            Image(systemName: "trash")
        })
        .alert(isPresented: $showingDeleteAlert, content: {
            Alert(title: Text("Delete Book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete"), action: deleteBook), secondaryButton: .cancel())
        })
    }
    
    func deleteBook(){
        self.moc.delete(book)
        try? self.moc.save()
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType:.mainQueueConcurrencyType)

    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test Book"
        book.author = "Test Author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This was a great book; I really enjoyed it."
        return NavigationView{
            DetailView(book:book)
        }
    }
}
