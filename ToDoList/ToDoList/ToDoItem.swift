//
//  ToDo.swift
//  ToDoList
//
//  Created by Arin Asawa on 7/20/20.
//  Copyright © 2020 Arin Asawa. All rights reserved.
//

import Foundation


struct ToDoItem:Codable {
    var title:String
    var isComplete:Bool
    var dueDate:Date
    var notes:String?
    static func loadToDos()->[ToDoItem]?{
        guard let codedToDos = try? Data(contentsOf: ArchiveUrl) else{return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<ToDoItem>.self, from: codedToDos)
    }
    static func saveToDos(_ todos:[ToDoItem]){
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(todos)
        try? codedToDos?.write(to: ArchiveUrl, options: .noFileProtection)
    }
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveUrl = DocumentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
    static func loadSampleToDos()->[ToDoItem]{
         let todo1 = ToDoItem(title: "ToDo One", isComplete: false, dueDate: Date(), notes: "Notes 1")
         let todo2 = ToDoItem(title: "ToDo Two", isComplete: false, dueDate: Date(), notes: "Notes 2")
         let todo3 = ToDoItem(title: "ToDo Three", isComplete: false, dueDate: Date(), notes: "Notes 3")
        return [todo1,todo2,todo3]
    }
     static let dueDateFormatter: DateFormatter = {
         let formatter = DateFormatter()
         formatter.dateStyle = .short
         formatter.timeStyle = .short
         return formatter
     }()
   
}
