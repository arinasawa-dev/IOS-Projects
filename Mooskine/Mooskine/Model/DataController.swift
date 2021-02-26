//
//  DataController.swift
//  Mooskine
//
//  Created by Arin Asawa on 11/25/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import CoreData

class DataController{
    let persistentContainer:NSPersistentContainer
    var viewContext:NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    var backgroundContext:NSManagedObjectContext!
    init(modelName:String) {
        self.persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion : (() -> Void)? = nil){
        persistentContainer.loadPersistentStores{storeDescription, error in
            guard error == nil else {fatalError(error!.localizedDescription)}
            self.autoSaveViewContext()
            self.configureContexts()
            completion?()
            
        }
        
    }
    
    func configureContexts(){
        backgroundContext = persistentContainer.newBackgroundContext()
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
}

extension DataController{
    func autoSaveViewContext(interval:TimeInterval = 30){
        guard interval > 0 else {print("cannot set a negative auto-set interval");return}
        if viewContext.hasChanges{
            try? viewContext.save()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}
