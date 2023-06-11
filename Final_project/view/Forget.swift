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
      
        .alert(isPresented: $logFunc.sendPas) {
                        Alert(
                            title: Text("重設密碼"),
                            message: Text(logFunc.senMes),
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
