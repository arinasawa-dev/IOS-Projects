//
//  ContentView.swift
//  WeSplit
//
//  Created by Arin Asawa on 8/26/20.
//  Copyright © 2020 Arin Asawa. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = ""
    @State private var numberOfPeople = ""
    @State private var tipPercentage = 2
    var grandTotal:Double{
       let orderAmount = Double(checkAmount) ?? 0
       let tipSelection = Double(tipPercentages[tipPercentage])
       let grandTotal = (tipSelection/100 + 1) * orderAmount
       return grandTotal
    }
    
    let tipPercentages = [10,15,20,25,0]
    var totalPerPerson: Double{
        let peopleCount = Double(self.numberOfPeople) ?? 2
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        let grandTotal = (tipSelection/100 + 1) * orderAmount
        return grandTotal / peopleCount
    }
    var body: some View {
        NavigationView{
        Form{
            Section{
                TextField("Amount", text: $checkAmount)
                    .keyboardType(.decimalPad)
                TextField("Number Of People", text: $numberOfPeople)
                    .keyboardType(.decimalPad)
            }
            Section(header:Text("How much tip do you want to leave?")){
                Picker("Tip Percentage",selection: $tipPercentage){
                    ForEach(0..<tipPercentages.count){
                        Text("\(self.tipPercentages[$0])%")
                    }
                }
            .pickerStyle(SegmentedPickerStyle())
            }
            Section(header:Text("Amount per person")){
                Text("$\(totalPerPerson, specifier: "%.2f")")
            }
            
            Section(header:Text("Grand Total (including tip)")){
                Text("$\(grandTotal,specifier: "%.2f")")
            }
        }
        .navigationBarTitle("WeSplit")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
