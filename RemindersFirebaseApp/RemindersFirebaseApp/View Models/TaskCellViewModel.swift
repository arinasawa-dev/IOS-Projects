

import Foundation
import Combine

class TaskCellViewModel: ObservableObject, Identifiable  { // (6)
  @Published var task: Task
  @Published var taskRepository = TaskRepository()
  
  var id: String = ""
  @Published var completionStateIconName = ""
  
  private var cancellables = Set<AnyCancellable>()
  
  static func newTask() -> TaskCellViewModel {
    TaskCellViewModel(task: Task(title: "", priority: TaskPriority.none.rawValue, completed: false))
  }
  
  init(task: Task) {
    self.task = task
    $task // (8)
      .map { $0.completed ? "checkmark.circle.fill" : "circle" }
      .assign(to: \.completionStateIconName, on: self)
      .store(in: &cancellables)

    $task // (7)
      .compactMap { $0.id }
      .assign(to: \.id, on: self)
      .store(in: &cancellables)
    
    $task
        .dropFirst()
        .debounce(for: 0.8, scheduler: RunLoop.main)
        .sink { (task) in
            self.taskRepository.updateTask(task)
        }
        .store(in: &cancellables)

  }
  
}
