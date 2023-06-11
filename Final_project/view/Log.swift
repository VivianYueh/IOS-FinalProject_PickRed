//
//  Log.swift
//  Final Project
//
//  Created by User06 on 2023/5/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreSwift
struct Log: View {

    @EnvironmentObject var RoomFunc:RoomFunction
    @State var log_acc=""
    @State var log_pas=""
    @State var al = false
    @State var forget=false
    @Binding var log:Bool
    @Binding var suc:Bool
    var body: some View {
        VStack{
            TextField("帳號", text: $log_acc)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("密碼", text: $log_pas)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            ZStack{
                Color(.white)
                Text("忘記密碼")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        forget=true
                    }
                    .sheet(isPresented: $forget, content: {
                        Forget(forget: $forget)
                    })
            }
            .offset(x:280,y:5)
            .frame(width: 100,height: 20)
            Text("登入")
                .foregroundColor(.blue)
                .fullScreenCover(isPresented: $suc, content: {
                    Hall(suc: $suc)
                })
                .onTapGesture {
                    Auth.auth().signIn(withEmail: log_acc , password: log_pas) { result, error in
                         guard error == nil else {
                            al=true
                             print("al\(al)")
                            print(error?.localizedDescription)
                            return
                         }
                        print("success")
                        suc = true
                        al=false
                    }
                    print(al)
                    print(suc)
                }
                .alert(isPresented: $al) {
                            Alert(
                                title: Text("登入錯誤"),
                                message: Text("The password is invalid or the user does not have a password."),
                                dismissButton: .default(Text("確定")
                                )
                            )
                        }
            
            
                
            Button("返回"){
                log = false
            }
        }
        
        
    }
}

struct Log_Previews: PreviewProvider {
    static var previews: some View {
        Log(log: .constant(true), suc: .constant(true))
    }
}
