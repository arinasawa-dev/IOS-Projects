//
//  LoggedInView.swift
//  RemindersFirebaseApp
//
//  Created by Arin Asawa on 3/23/21.
//

import SwiftUI
import Firebase

struct LoggedInView: View {
    @EnvironmentObject var userState:UserState
    var body: some View {
        VStack{
            Image(systemName: "person.crop.square.fill")
                .font(.system(size: 70))
            Text("Email Address: \(Auth.auth().currentUser?.email ?? "no email")")
                .foregroundColor(.white)
                .bold()
            Button(action: {
                do{
                    try Auth.auth().signOut()
                    Auth.auth().signInAnonymously { (result, error) in
                        if error == nil{
                            withAnimation{
                                userState.state = .anonymousAccount
                            }
                        }
                    }
                }catch{
                    print("Error signing out")
                }
            }){
                Text("Sign out")
                    .bold()
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 5).foregroundColor(Color.white))
                    .foregroundColor(.red)
            }
        }
    }
}

struct LoggedInView_Previews: PreviewProvider {
    static var previews: some View {
        LoggedInView()
    }
}
