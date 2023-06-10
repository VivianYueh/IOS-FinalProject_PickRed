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
    @Binding var log:Bool
    @Binding var suc:Bool
    var body: some View {
        TextField("帳號", text: $log_acc)
            
            .keyboardType(.numberPad)
            .padding()
        SecureField("密碼", text: $log_pas)
            
            .keyboardType(.numberPad)
            .padding()
        Text("登入")
            .foregroundColor(.blue)
            .fullScreenCover(isPresented: $suc, content: {
                Hall(suc: $suc)
            })
            .onTapGesture {
                Auth.auth().signIn(withEmail: log_acc , password: log_pas) { result, error in
                     guard error == nil else {
                        print(error?.localizedDescription)
                        return
                     }
                    print("success")
                    suc = true
                    
                }
            }
        Button("返回"){
            log = false
        }
    }
}

struct Log_Previews: PreviewProvider {
    static var previews: some View {
        Log(log: .constant(true), suc: .constant(true))
    }
}
