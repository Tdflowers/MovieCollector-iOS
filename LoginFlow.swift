//
//  LoginFlow.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 8/31/21.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginFlow: View {
    
    var dismiss: (() -> Void)?
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorString: String = ""
    
    @State var selected = 0
    
    @State var ref: Firestore!
    
    var body: some View {
        
        VStack (){
            
            HStack {
                Spacer()
                Button(action: {
                    self.dismiss?()
                }, label: {
                    Text("x")
                    .font(.system(.largeTitle))
                    .frame(width: 38, height: 32)
                    .foregroundColor(Color.white)
                    .padding(.bottom, 7)
                })
                .background(Color.black)
                .cornerRadius(19)
                .padding()
                .shadow(color: Color.black.opacity(0.3),
                        radius: 3, x: 3, y: 3)
            }
            Spacer()
            Text("Enter Username") .foregroundColor(.primary)
//                .padding(0)
            TextField("Email", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle.init())
                .padding(EdgeInsets.init(top: -5, leading: 20, bottom: 20, trailing: 20))
                .autocapitalization(.none)
                .disableAutocorrection(true)
            Text("Enter Password") .foregroundColor(.primary)
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle.init())
                .padding(EdgeInsets.init(top: -5, leading: 20, bottom: 20, trailing: 20))
            Picker(selection: $selected, label: Text(""), content: {
                           Text("Sign Up").tag(0)
                           Text("Login").tag(1)
                       }).pickerStyle(SegmentedPickerStyle())
                .padding(EdgeInsets.init(top: -5, leading: 20, bottom: 20, trailing: 20))
            Spacer()
            Button(action: {self.submitSignUp()}, label: {
                Text("Submit")
            })
            Text("\(errorString)")
                .lineLimit(2)
                .padding()

        }
    }
    
    func submitSignUp() {
        let tempUser = "\(username)"
        let tempPass = "\(password)"
        
        errorString = ""
        
        if selected == 0 {
            ref = Firestore.firestore()
            
            Auth.auth().createUser(withEmail: tempUser, password: tempPass) { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                    errorString = "Signup error: " + error.localizedDescription
                    return
                } else {
                    if let authResult = authResult {
                        self.ref.collection("users").document(authResult.user.uid).setData(["username":username]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                    }
                    self.dismiss?()
                }

            }
        } else {
            
            Auth.auth().signIn(withEmail: tempUser, password: tempPass) {
    //            [ self] authResult, error in
    //          guard let strongSelf = self else { return }
            
    //        Auth.auth().createUser(withEmail: tempUser, password: tempPass) {
                authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                    errorString = "Signup error: " + error.localizedDescription
                    return
                } else {
                    self.dismiss?()
                }
        }
       
        }
    }
    
}



struct LoginFlow_Previews: PreviewProvider {
    static var previews: some View {
        LoginFlow()
    }
}
