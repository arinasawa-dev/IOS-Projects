//
//  RemindersFirebaseAppApp.swift
//  RemindersFirebaseApp
//
//  Created by Arin Asawa on 3/22/21.
//

import SwiftUI
import Firebase
import FirebaseFirestore

@main
struct RemindersFirebaseAppApp: App {
    init(){
        FirebaseApp.configure()
        Firestore.firestore().settings.isPersistenceEnabled = true
        if Auth.auth().currentUser == nil{
            Auth.auth().signInAnonymously()
        }
    }
    var body: some Scene {
        WindowGroup {
            TaskListView()
        }
    }
    
}

