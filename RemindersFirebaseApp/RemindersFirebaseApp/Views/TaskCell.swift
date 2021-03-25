//
//  TaskCell.swift
//  RemindersFirebaseApp
//
//  Created by Arin Asawa on 3/22/21.
//

import Foundation
import SwiftUI


struct TaskCell: View {
  @ObservedObject var taskCellVM: TaskCellViewModel // (1)
  var onCommit: (Result<Task, InputError>) -> Void = { _ in } // (5)
  @State var isPresentingPriorityScreen = false
  var body: some View {
    HStack {
      Image(systemName: taskCellVM.completionStateIconName) // (2)
        .resizable()
        .frame(width: 20, height: 20)
        .onTapGesture {
          self.taskCellVM.task.completed.toggle()
        }
      TextField("Enter task title", text: $taskCellVM.task.title, // (3)
                onCommit: { //(4)
                  if !self.taskCellVM.task.title.isEmpty {
                    self.onCommit(.success(self.taskCellVM.task))
                  }
                  else {
                    self.onCommit(.failure(.empty))
                  }
      }).id(taskCellVM.id)
    
            Image(systemName: "info.circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.orange)
                .padding(.trailing)
                .onTapGesture {
                    self.isPresentingPriorityScreen.toggle()
                }
    }
    .sheet(isPresented: $isPresentingPriorityScreen, content: {
        PriorityConfigurationView(taskCellVM: taskCellVM)
    })
  }
}

enum InputError: Error {
  case empty
}

struct TaskCell_Previews: PreviewProvider {
  static var previews: some View {
    TaskCell(taskCellVM: TaskCellViewModel(task: testDataTasks.randomElement()!))
  }
}
