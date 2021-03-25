//
//  PriorityConfigurationView.swift
//  RemindersFirebaseApp
//
//  Created by Arin Asawa on 3/22/21.
//

import SwiftUI

struct PriorityConfigurationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var priorityTypes:[TaskPriority] = [.none, .low, .medium, .high]
    @ObservedObject var taskCellVM: TaskCellViewModel
    var body: some View {
        NavigationView{
            VStack{
                List{
                    ForEach(priorityTypes, id: \.self){type in
                        Button(action: {taskCellVM.task.priority = type.rawValue}){
                            HStack{
                                Text(type.rawValue)
                                Spacer()
                                if taskCellVM.task.priority == type.rawValue{
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing)
                                        .foregroundColor(.blue)
                                }
                            }

                        }
                       
                    }
                }
            }
            .navigationBarTitle("Priority")
            .navigationBarItems(trailing: Button("Done"){
                presentationMode.wrappedValue.dismiss()
            }.foregroundColor(.red))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct PriorityConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        PriorityConfigurationView(taskCellVM: TaskCellViewModel(task: testDataTasks.randomElement()!))
    }
}

