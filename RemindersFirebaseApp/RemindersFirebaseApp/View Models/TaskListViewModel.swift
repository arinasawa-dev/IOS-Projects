
import Foundation
import Combine

class TaskListViewModel: ObservableObject { // (1)
  @Published var taskRepository = TaskRepository()
  @Published var taskCellViewModels = [TaskCellViewModel]() // (3)
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    taskRepository.$tasks
        .map{tasks in
            tasks.map { task in
                TaskCellViewModel(task: task)
            }
        }
        .assign(to: \.taskCellViewModels, on: self)
        .store(in: &cancellables)
  }
  
  func removeTasks(atOffsets indexSet: IndexSet) { // (4)
    taskRepository.removeTask(taskCellViewModels[indexSet.first!].task)
  }
  
  func addTask(task: Task) { // (5)
    taskRepository.addTask(task)
  }
}

