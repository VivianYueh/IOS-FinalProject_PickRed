//  AddRoom.swift
//  Final Project
//
//  Created by User06 on 2023/5/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreSwift
struct AddRoom: View {
    let RoomFunc = RoomFunction()
    @Binding var suc:Bool
    @Binding var user_nam:String
    @Binding var add:Bool
    @State var user_rom = ""
    @State var mem = false
    var body: some View {
        TextField("房間號", text: $user_rom)
            .keyboardType(.numberPad)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
        Text("加入房間")
            .foregroundColor(.blue)
            .onTapGesture {
                if suc {
                    if let user = Auth.auth().currentUser {
                        user_nam = user.displayName!
                        
                    }
                    //print(user_nam)
                    self.RoomFunc.add(people: user_nam, rooms: user_rom)
                    mem = true
                }
        
            }
            .fullScreenCover(isPresented: $mem, content: {
                RoomMem( RoomNum: $user_rom, nxt: $mem)
            })
        Button("返回"){
            add = false
        }
    }
}
struct AddRoom_Previews: PreviewProvider {
    static var previews: some View {
        AddRoom(suc: .constant(true), user_nam: .constant(""), add: .constant(true))
    }
}
