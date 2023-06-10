import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreSwift
struct Reg: View {
    @Binding var user_acc:String
    @Binding var user_pas:String
    @Binding var user_nam:String
    @Binding var user_rom:String
    @Binding var suc:Bool
    @Binding var reg:Bool
    var body: some View {
        TextField("帳號", text: $user_acc)
            .keyboardType(.numberPad)
            .padding()
        TextField("密碼", text: $user_pas)
            .keyboardType(.numberPad)
            .padding()
        TextField("名字", text: $user_nam)
            .keyboardType(.numberPad)
            .padding()
        HStack{
            Button("註冊"){
                Auth.auth().createUser(withEmail: user_acc, password: user_pas) { result, error in
                     guard error == nil else {
                        print(error?.localizedDescription)
                        return
                     }
                    suc = true
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = user_nam
                    changeRequest?.commitChanges(completion: { error in
                       guard error == nil else {
                           print(error?.localizedDescription)
                           return
                       }
                        print("success")
                    })
                   print("success")
                }
                
            }
            Button("返回"){
                reg = false
            }
        }
        
        .foregroundColor(.blue)
        .fullScreenCover(isPresented: $suc, content: {
            Hall(suc: $suc)
        })
    }
}

struct Reg_Previews: PreviewProvider {
    static var previews: some View {
        Reg(user_acc: .constant(""), user_pas: .constant(""), user_nam: .constant(""), user_rom: .constant(""), suc: .constant(true), reg: .constant(true))
    }
}
