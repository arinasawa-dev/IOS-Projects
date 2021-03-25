//
//  SignInView.swift
//  RemindersFirebaseApp
//
//  Created by Arin Asawa on 3/23/21.
//

import SwiftUI
import FirebaseAuth
import Firebase

enum Mode:String{
    case signIn = "Sign In"
    case createAnAccount = "Create An Account"
}


struct SignInView: View {
    private let  modes:[Mode] = [.signIn, .createAnAccount]
    private let emailRegularExpression = NSRegularExpression("[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}")
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userState:UserState
    @State var selectedMode = 0
    @State var emailAddress = ""
    @State var password = ""
    @State var showingAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    private var isValidEntry:Bool{
        return isValidEmailAddress && password.count > 0
    }
    private var isValidEmailAddress:Bool{
        return emailRegularExpression.matches(emailAddress)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            if userState.state == .anonymousAccount{
                VStack{
                    Spacer()
                    Picker(selection: $selectedMode.animation(), label: Text(""), content: {
                        ForEach(0..<2){index in
                            Text(modes[index].rawValue)
                        }
                    })
                    .overlay(
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .padding(.bottom)
                    .pickerStyle(SegmentedPickerStyle())
                    Group{
                        TextField("Email Address", text: $emailAddress)
                        SecureField("Password (at least 5 characters long)", text: $password)
                            
                    }
                    .background(Color.clear)
                    .disableAutocorrection(true)
                    Button(action: {
                        if modes[selectedMode] == .createAnAccount{
                            if Auth.auth().currentUser?.isAnonymous ?? false{
                            let credential = EmailAuthProvider.credential(withEmail: emailAddress, password: password)
                            Auth.auth().currentUser?.link(with: credential, completion: { (result, error) in
                                if let error = error{
                                        self.alertTitle = "Error"
                                        if let errCode = AuthErrorCode(rawValue: error._code){
                                            switch errCode{
                                            case .invalidEmail:
                                                alertMessage = "An invalid email was entered"
                                            case .emailAlreadyInUse:
                                                alertMessage = "This email is already in use. Use the Sign In tab."
                                            default:
                                                alertMessage = "Unknown error occured. Please try again."
                                            }
                                        }
                                    }else{
                                        alertTitle = "Success!"
                                        alertMessage = "You have created an account! Please use the Sign In tab to log in!"
                                    }
                                self.emailAddress = ""
                                self.password = ""
                                self.showingAlert = true
                            })
                            }else{
                                Auth.auth().createUser(withEmail: emailAddress, password: password) { (data, error) in
                                    if let error = error{
                                            self.alertTitle = "Error"
                                            if let errCode = AuthErrorCode(rawValue: error._code){
                                                switch errCode{
                                                case .invalidEmail:
                                                    alertMessage = "An invalid email was entered"
                                                case .emailAlreadyInUse:
                                                    alertMessage = "This email is already in use. Use the Sign In tab."
                                                default:
                                                    alertMessage = "Unknown error occured. Please try again."
                                                }
                                            }
                                        }else{
                                            alertTitle = "Success!"
                                            alertMessage = "You have created an account! Please use the Sign In tab to log in!"
                                            try? Auth.auth().signOut()
                                        }
                                    self.emailAddress = ""
                                    self.password = ""
                                    self.showingAlert = true
                                }
                            }
                        }else{
                            Auth.auth().signIn(withEmail: emailAddress, password: password) { (result, error) in
                                if let error = error{
                                    if let errCode = AuthErrorCode(rawValue: error._code){
                                        self.alertTitle = "Error"
                                        switch errCode {
                                        case .invalidEmail:
                                            alertMessage = "An invalid email was entered"
                                        case .userDisabled:
                                            alertMessage = "This account is disabled"
                                        case .wrongPassword:
                                            alertMessage = "The wrong password was entered"
                                        default:
                                            alertMessage = "Unknown error occured"
                                        }
                                    }
                                }else{
                                    alertTitle = "Success!"
                                    alertMessage = "You are signed in!"
                                }
                                self.showingAlert = true
                            }
                        }
                    }){
                        Text(modes[selectedMode].rawValue)
                            .bold()
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 5).foregroundColor(isValidEntry ? .blue : .gray))
                            .foregroundColor(.white)
                    }
                        .disabled(!isValidEntry)
                        .padding(.top)
                    .alert(isPresented: $showingAlert, content: {
                        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK"), action: {
                            if alertMessage.contains("signed in!"){
                                presentationMode.wrappedValue.dismiss()
                                self.userState.state = .loggedIn
                            }
                        })
                    )})
                    if modes[selectedMode] == .signIn{
                        Button(action:{
                            if isValidEmailAddress{
                                Auth.auth().sendPasswordReset(withEmail: emailAddress) { (error) in
                                    if error != nil{
                                        self.alertTitle = "Error"
                                        self.alertMessage = "There was a problem sending a password reset link to the given email. Please try again"
                                        self.showingAlert = true
                                    }else{
                                        self.alertTitle = "Sent!"
                                        self.alertMessage = "Check your email for a password reset link"
                                        self.showingAlert = true
                                    }
                                }
                            }else{
                                self.alertTitle = "Oops!"
                                self.alertMessage = "Looks like the email address you entered is invalid. Please try again."
                                self.showingAlert = true
                            }
                        }){
                            Text("Forgot Password")
                                .bold()
                                .padding(5)
                                .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.red))
                                .foregroundColor(.white)
                        }
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                    }
                    Spacer()
                }
                .padding()
            }else{
                LoggedInView()
            }
        }
        .environmentObject(userState)
    }
}


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
