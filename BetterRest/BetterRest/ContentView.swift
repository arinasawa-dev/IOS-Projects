//
//  ContentView.swift
//  BetterRest
//
//  Created by Arin Asawa on 9/2/20.
//  Copyright © 2020 Arin Asawa. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 0

    var body: some View {
        NavigationView{
            VStack{
                Form{
                     Section(header: Text("When do you want to wake up?")){
                        DatePicker("Please enter a time", selection: $wakeUp,displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                    }
                      Section(header: Text("Desired Amount Of Sleep")){
                        Stepper(value: $sleepAmount, in: 4...12,step: 0.25) {
                            Text("\(sleepAmount,specifier: "%g") hours")
                        }
                    }
                      Section(header: Text("Daily Coffee Intake")){
                        Picker(selection: $coffeeAmount, label: Text("Cups Of Coffee: ")) {
                            ForEach(1..<21){number in
                                    Text("\(number)")
                            }
                        }
                    }
                }
                Text(calculateBedTime())
            }
            .navigationBarTitle("Better Rest")
        
        }
    
    }
    
    static var defaultWakeTime:Date{
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedTime()->String{
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp )
        let hour = (components.hour ?? 0) * 3600
        let minute = (components.minute ?? 0) * 60
        do{
            let prediction = try model.prediction(wake: Double(hour+minute), estimatedSleep: Double(sleepAmount), coffee: Double(coffeeAmount+1))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return "Your ideal bedtime is...\(formatter.string(from: sleepTime))"
            
        }
        catch{
            return "Sorry, but it looks like something went wrong!"
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

