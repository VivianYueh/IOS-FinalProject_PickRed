//
//  LogFunc.swift
//  Final_project
//
//  Created by 岳紀伶 on 2023/6/12.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreSwift
class LogFunc:ObservableObject{
    @Published var showalert=false
    @Published var sendPas=false
    @Published var senMes=""
    @Published var chMes=""
    func resetPassword(email:String) {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    // 重設密碼發生錯誤，顯示警示框
                    self.sendPas = true
                    self.senMes="帳號不存在，請重新確認或註冊"
                } else {
                    // 重設密碼成功，顯示提示訊息
                    self.sendPas = true
                    self.senMes="重設密碼連結已經寄送至您的信箱"
                }
                print(self.sendPas)
            }
        }
    func checkAccount(email:String) {
        // 執行 Firebase 確認帳號操作
        Auth.auth().fetchSignInMethods(forEmail: email) { signInMethods, error in
            if let signInMethods = signInMethods {
                // 帳號存在，顯示警示框
                self.showalert = true
                self.resetPassword(email: email)
            } else {
                // 帳號不存在，顯示提示訊息
                self.sendPas = true
                self.senMes="帳號不存在，請重新確認或註冊"
            }
        }
        
    }
}
