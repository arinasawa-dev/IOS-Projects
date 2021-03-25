
import SwiftUI
import FirebaseAuth

class UserState:ObservableObject{
    @Published var state:authenticationStatus
    init() {
        if Auth.auth().currentUser == nil || Auth.auth().currentUser!.isAnonymous{
            self.state = .anonymousAccount
        }else{
            self.state = .loggedIn
        }
    }
    enum authenticationStatus{
        case anonymousAccount
        case loggedIn
    }
}


struct TaskListView: View {
  @StateObject var taskListVM = TaskListViewModel() // (7)
  @StateObject var userState = UserState()
  @State var presentAddNewItem = false
  @State var showSignInForm = false
  
  var body: some View {
    NavigationView {
      VStack(alignment: .leading) {
        List {
          ForEach (taskListVM.taskCellViewModels) { taskCellVM in // (8)
            TaskCell(taskCellVM: taskCellVM) // (1)
          }
          .onDelete { indexSet in
            self.taskListVM.removeTasks(atOffsets: indexSet)
          }
          if presentAddNewItem { // (5)
            TaskCell(taskCellVM: TaskCellViewModel.newTask()) { result in // (2)
              if case .success(let task) = result {
                self.taskListVM.addTask(task: task) // (3)
              }
              self.presentAddNewItem.toggle() // (4)
            }
          }
        }
        Button(action: { self.presentAddNewItem.toggle() }) { // (6)
          HStack {
            Image(systemName: "plus.circle.fill")
              .resizable()
              .frame(width: 20, height: 20)
            Text("New Task")
          }
        }
        .padding()
        .accentColor(Color(UIColor.systemRed))
      }
      .sheet(isPresented: $showSignInForm, content: {
        SignInView()
      })
      .navigationBarItems(trailing: Button(action:{self.showSignInForm = true}){
            Image(systemName: "person.circle")
                .font(.title)
      })
      .navigationBarTitle("Tasks")
    }
    .environmentObject(userState)
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct TaskListView_Previews: PreviewProvider {
  static var previews: some View {
    TaskListView()
  }
}

