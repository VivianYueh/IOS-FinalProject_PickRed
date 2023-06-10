//
//  ResultRow.swift
//  PickRed
//
//  Created by Chase on 2021/3/21.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreSwift
struct ResultRow2: View {
    @State var p=["","","",""]
    
    var playerNum: Int
    var point: Int
    //var coin: Int
    var result: Int
    var idx:Int
    @Binding var room:String
    var body: some View {
        HStack{
            if(playerNum==idx-1){
                Text(p[idx-1])
                    .foregroundColor(.orange)
                    .bold()
                    .frame(width: 125, height: 30, alignment: .center)
            }
            else{
                Text(p[playerNum])
                    .frame(width: 125, height: 30, alignment: .center)
            }
            if(playerNum==idx-1){
                Text("\(point)")
                    .foregroundColor(.orange)
                    .bold()
                    .frame(width: 125, height: 30, alignment: .center)
            }
            else{
                Text("\(point)")
                    .frame(width: 125, height: 30, alignment: .center)
            }
            if(playerNum==idx-1){
                if(result<0){
                    Text("\(result)")
                        .foregroundColor(.orange)
                        .bold()
                        .frame(width: 125, height: 30, alignment: .center)
                }
                else{
                    Text("+\(result)")
                        .foregroundColor(.orange)
                        .frame(width: 125, height: 30, alignment: .center)
                }
            }
            else{
                if(result<0){
                    Text("\(result)")
                        .frame(width: 125, height: 30, alignment: .center)
                }
                else{
                    Text("+\(result)")
                        .frame(width: 125, height: 30, alignment: .center)
                }
            }
            
           
        }
        .onAppear{
            let db = Firestore.firestore()
            db.collection("room").document(room).getDocument { document, error in
                
                guard let document=document,
                      document.exists,
                      let data = try? document.data(as: Room.self) else {
                    return
                }
                p[0]=data.p1
                p[1]=data.p2
                p[2]=data.p3
                p[3]=data.p4
                
                
                
            }
        }
        
    }
}

struct ResultRow2_Previews: PreviewProvider {
    static var previews: some View {
        ResultRow2(playerNum: 0, point: 1000, result: 100, idx: 0, room: .constant(""))
    }
}
