//
//  Forget.swift
//  Final_project
//
//  Created by 岳紀伶 on 2023/6/12.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreSwift
struct Forget: View {
    @StateObject var logFunc = LogFunc()
    @State var email=""
    @Binding var forget:Bool
    var body: some View {
        TextField("Email", text: $email)
            .keyboardType(.numberPad)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
        Button("送出"){
            logFunc.checkAccount(email: email)
        }
        .alert(isPresented: $logFunc.showalert) {
                        Alert(
                            title: Text("確認帳號"),
                            message: Text("此帳號存在"),
                            dismissButton: .default(Text("確定"))
                        )
                    }
        .alert(isPresented: $logFunc.sendPas) {
                        Alert(
                            title: Text("重設密碼"),
                            message: Text("重設密碼連結已經寄送至您的信箱"),
                            dismissButton: .default(Text("確定"),action: {forget=false})
                        )
                    }
        
    }
}

struct Forget_Previews: PreviewProvider {
    static var previews: some View {
        Forget(forget: .constant(true))
    }
}
