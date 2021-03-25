//
//  TaskRepository.swift
//  RemindersFirebaseApp
//
//  Created by Arin Asawa on 3/22/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class TaskRepository:ObservableObject{
    let db = Firestore.firestore()
    @Published var tasks = [Task]()
    var currentSnapshotListener:ListenerRegistration?
    init() {
        loadData()
    }
    
    func addTask(_ task:Task){
        var task = task
        let userID = Auth.auth().currentUser?.uid
        do{
            task.userID = userID
            let _ = try  db.collection("Tasks").addDocument(from: task)
        }catch{
            fatalError("Unable to add task: \(error.localizedDescription)")
        }
    }
    
    func removeTask(_ task:Task){
        if let id = task.id{
            db.collection("Tasks").document(id).delete()
        }
    }
    
    func updateTask(_ task:Task){
        if let id = task.id{
            do{
              try db.collection("Tasks").document(id).setData(from: task)
            }catch{
                fatalError("Unable to update task \(error.localizedDescription)")
            }
        }
    }

    
    func loadData(){
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let listener = self.currentSnapshotListener{
                print("executed")
                listener.remove()
            }
            if user != nil{
                let userID = Auth.auth().currentUser?.uid
                self.currentSnapshotListener =  self.db.collection("Tasks").order(by: "createdTime").whereField("userID", isEqualTo: userID).addSnapshotListener { (querySnapshot, error) in
                    if let querySnapshot = querySnapshot{
                        self.tasks = querySnapshot.documents.compactMap{document in
                            do{
                                let x = try document.data(as: Task.self)
                                return x
                            }catch{
                                print(error.localizedDescription)
                            }
                            return nil

                        }
                    }
                }
            }
        }
    }
}
