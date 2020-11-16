//
//  ContentView.swift
//  iExpense
//
//  Created by Arin Asawa on 9/22/20.
//

import SwiftUI


struct ExpenseItem:Identifiable,Codable{
    let id = UUID()
    let name:String
    let type:String
    let amount:Int
}

class Expenses:ObservableObject{
    @Published var items = [ExpenseItem](){
        didSet{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let encodedItems = UserDefaults.standard.data(forKey: "Items"){
            let decoder = JSONDecoder()
            if let decodedItems = try? decoder.decode(Array<ExpenseItem>.self, from: encodedItems){
                self.items = decodedItems
                return
            }
        }
        self.items = []
    }
}

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    @State private var filteringOption = "All"
    let filteringOptions = ["All","Personal","Business"]
    var body: some View {
        NavigationView{
            VStack {
                Picker(selection: $filteringOption.animation(), label: Text("Filter")){
                    ForEach(filteringOptions,id:\.self){option in
                        Text(option)
                    }
                }
                
                .padding()
                .pickerStyle(SegmentedPickerStyle())
                
                List{
                    ForEach(expenses.items){item in
                        if filteringOption == "All" || item.type == filteringOption{
                        HStack{
                            VStack(alignment:.leading){
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            Spacer()
                            Text("$\(item.amount)")
                                .foregroundColor(colorForExpenseAmount(item.amount))
                        }
                        }
                    }
                    .onDelete(perform: { indexSet in
                        removeItems(at: indexSet)
                    })
                }
                .navigationBarTitle("iExpense")
                .navigationBarItems(leading: EditButton(), trailing: Button(action: {self.showingAddExpense = true}) {
                    Image(systemName: "plus")
            })
            }
        }
        
        .sheet(isPresented: $showingAddExpense, content: {
            AddView(expenses: self.expenses)
        })
    }
    
    func removeItems(at offsets:IndexSet){
        self.expenses.items.remove(atOffsets: offsets)
    }
    func colorForExpenseAmount(_ amount:Int)->Color{
        if amount < 10{
            return .green
        }else if amount < 100{
            return .yellow
        }else{
            return .red
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
