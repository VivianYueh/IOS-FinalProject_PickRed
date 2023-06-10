//
//  BuildRoom.swift
//  Final_project
//
//  Created by 岳紀伶 on 2023/5/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreSwift
struct BuildRoom: View {
    let RoomFunc = RoomFunction()
    @Binding var build:Bool
    @Binding var suc:Bool
    @State var user_nam=""
    @State var RoomNum = ""
    @State var nxt = false
    var body: some View {
        Text("建立房間")
            .foregroundColor(.blue)
            .onTapGesture {
                if suc {
                    RoomNum="\(Int.random(in: 0...9))"+"\(Int.random(in: 0...9))"+"\(Int.random(in: 0...9))"+"\(Int.random(in: 0...9))"
                    if let user = Auth.auth().currentUser {
                        user_nam = user.displayName!
                        
                    }
                    print(user_nam)
                    self.RoomFunc.createRoom(people: user_nam,RoomNum:RoomNum)
                    nxt = true
                    
                }
            }
            .fullScreenCover(isPresented: $nxt, content: {
                RoomMem(RoomNum: $RoomNum, nxt: $nxt)
            })
        Button("返回"){
            build = false
        }
    }
}

struct BuildRoom_Previews: PreviewProvider {
    static var previews: some View {
        BuildRoom(build: .constant(true), suc: .constant(true))
    }
}
