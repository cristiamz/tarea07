//
//  LoginView.swift
//  Tarea07
//
//  Created by Cristian Zuniga on 28/3/21.
//

import SwiftUI
import Amplify
import SCLAlertView
import LocalAuthentication

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var logWithPass = false
    
    @EnvironmentObject var contentVM: ContentViewModel
    
    
    
    var body: some View {
        
        
        VStack{
            
//            Rectangle()
//                .fill(Color.red)
//                .frame(width: UIScreen.main.bounds.width, height: 200)
            
            Text("Logo of the back").bold().font(.title)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 20, trailing: 0))
            
            HStack{
                VStack(alignment: .leading, spacing: 12, content: {
                    
                    HStack{
                        Image(systemName: "cloud")
                            .font(.title2)
                            .foregroundColor(.black)
                            .frame(width: 35)
                            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                        Text("Buenas noches")
                    }

                    Text("Usuario")
                        .foregroundColor(Color.black)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                    
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color("flash-white"))
                        .cornerRadius(4.0)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                        .autocapitalization(.none)
                })
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            }
          
            if getBiometricStatus() && !logWithPass{
                Text("Ingresar con Face ID")
                Button(
                    action: authenticateUser,
                    label:{
                        Image (systemName: LAContext().biometryType == .faceID ? "faceid" : "touchid")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                )
            }
            
            HStack(spacing: 15){
                if !logWithPass {
                    Button(action: {
                        logWithPass = true
                    }, label:{
                        Text("o ingrese con contraseña")
                            .fontWeight(.heavy)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 150)
                    })
                }
                
            }
            
            if logWithPass {
                SecureField("Password", text: $password)
                    .padding().background(Color("flash-white"))
                    .cornerRadius(4.0)
                    .padding(.bottom, 10)
                    .autocapitalization(.none)
                
                Button(action: signIn) {
                    HStack(alignment: .center) {
                        Spacer()
                        Text("Login").foregroundColor(Color.white).bold()
                        Spacer()
                    }
                }.padding().background(Color.gray).cornerRadius(4.0)
                
                HStack(spacing: 15){
                    Button(action: {
                            logWithPass = false
                        }, label:{
                            Text("Ingresar con Face ID")
                                .fontWeight(.heavy)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 150)
                        })
                }
                
            }
            
            NavigationLink(destination:  SignUpView()) {
                HStack(alignment: .center) {
                    Spacer()
                    Text("¿Primera vez que ingresa?")
                    Text("Registrese aqui").foregroundColor(Color.blue)
                    Spacer()
                }
            }.padding()
            
        }
        .padding(0.0)
        
        
        
    }
    
    func getBiometricStatus()->Bool{
        let scanner = LAContext()
        // Biometry is available on the device
        if scanner.canEvaluatePolicy(.deviceOwnerAuthentication, error: .none){
            return true
        }
        return false
    }
    
    func authenticateUser(){
        let scanner = LAContext()
        scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To Unlock \(username)"){(status, error) in
            if error != nil{
                print("Error")
                print(error!.localizedDescription)
                return
            }
            withAnimation(.easeOut){self.contentVM.logged = true}
        }
    }
    
    
    func signIn() {
        Amplify.Auth.signIn(username: username, password: password) { result in
            switch result {
            
            case .success:
                print("\(username) signed in")
                DispatchQueue.main.async {
                    self.contentVM.logged = true
                    print("Login In")
                }
                
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    SCLAlertView().showError("Error", subTitle: error.errorDescription) // Error
                    
                }
            }
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

