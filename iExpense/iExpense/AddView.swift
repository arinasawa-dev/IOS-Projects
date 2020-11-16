//
//  AddView.swift
//  iExpense
//
//  Created by Arin Asawa on 9/23/20.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses:Expenses
    @State private var name = ""
    @State private var saveButtonIsEnabled = true
    @State private var type = "Personal"
    @State private var amount = ""{
        didSet{
            updateSaveButtonState()
        }
    }
    static let types = ["Business","Personal"]
    var body: some View {
        NavigationView{
            Form{
                TextField("Name",text:$name)
                    .onChange(of: name, perform: { value in
                        updateSaveButtonState()
                    })
                Picker(selection: $type, label: Text("Type")){
                    ForEach(AddView.types,id:\.self){type in
                        Text(type)
                    }
                }
                TextField("amount",text:$amount)
                    .onChange(of: amount, perform: { value in
                        updateSaveButtonState()
                    })
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle(Text("Add New Expense"))
            .navigationBarItems(trailing: Button(action: {
                if let actualAmount = Int(amount){
                    let expense = ExpenseItem(name: name, type: type, amount: actualAmount)
                    self.expenses.items.append(expense)
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Save")
            }.disabled(saveButtonIsEnabled))
        }
    }
    
    func allFieldsValid()->Bool{
        if !name.isEmpty && Int(amount) != nil{
            return true
        }
        return false
    }
    func updateSaveButtonState(){
        if !name.isEmpty && Int(amount) != nil{
            self.saveButtonIsEnabled = false
        }else{
            self.saveButtonIsEnabled = true
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
