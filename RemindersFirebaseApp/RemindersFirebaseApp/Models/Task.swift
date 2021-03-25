//
//  Task.swift
//  RemindersFirebaseApp
//
//  Created by Arin Asawa on 3/22/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum TaskPriority:String,Codable{
    case high = "High"
    case medium = "Medium"
    case low = "Low"
    case none = "None"
}

struct Task:Identifiable,Codable{
    @DocumentID var id:String?
    var title:String
    var priority:String
    var completed:Bool
    var userID:String?
    @ServerTimestamp var createdTime:Timestamp?
}

#if DEBUG
let testDataTasks = [
    Task(title: "Implement UI", priority: TaskPriority.medium.rawValue, completed: false),
  Task(title: "Connect to Firebase", priority: TaskPriority.medium.rawValue, completed: false),
    Task(title: "????", priority: TaskPriority.high.rawValue, completed: false),
  Task(title: "PROFIT!!!", priority: TaskPriority.high.rawValue, completed: false)
]
#endif
