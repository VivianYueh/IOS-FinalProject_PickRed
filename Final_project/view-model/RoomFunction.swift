//
//  RoomFunction.swift
//  Final_project
//
//  Created by 岳紀伶 on 2023/5/8.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreSwift
class RoomFunction:ObservableObject{
    @Published var player:Player = Player()
    @Published var user:User = User()
    @Published var isStart:Bool=false
    @Published var isLogIn:Bool=false
    func createRoom(people:String,RoomNum:String) {
        let db = Firestore.firestore()  
        let room = Room(p1:people,p2:"",p3:"",p4:"",people_num: 1, start: false)
        do {
            try
                
            db.collection("room").document(RoomNum).setData(from: room)
        } catch {
            print(error)
        }
        getInf(room: RoomNum)
    }
    func add(people:String,rooms:String) {
        let db = Firestore.firestore()
            let documentReference = db.collection("room").document(rooms)
            
            documentReference.getDocument { document, error in
                
                guard let document=document,
                      document.exists,
                      var room = try? document.data(as: Room.self)
                else {
                    return
                }
                if(room.people_num<4){
                    if(room.p1==""){
                        room.p1=people
                    }
                    else if(room.p2==""){
                        room.p2=people
                    }
                    else if(room.p3==""){
                        room.p3=people
                    }
                    else{
                        room.p4=people
                    }
                    room.people_num+=1
                    do {
                        try documentReference.setData(from: room)
                    } catch {
                        print(error)
                    }
                }
                else{
                    print("Full")
                }
                
            }
        //getInf(room: rooms)
    }
    func getInf(room:String) {
        let db = Firestore.firestore()
        db.collection("room").document(room).getDocument { [self] document, error in
            
            guard let document=document,
                  document.exists,
                  let rom = try? document.data(as: Room.self) else {
                return
            }
            self.player.p1=rom.p1
            self.player.p2=rom.p2
            self.player.p3=rom.p3
            self.player.p4=rom.p4
            //print(player.p1)
            //print(rom)
            
        }
    }
    func modify(RoomNum:String) {
        let db = Firestore.firestore()
        let documentReference =
        db.collection("room").document(RoomNum)
        documentReference.getDocument { document, error in
            
            guard let document=document,
                  document.exists,
                  var room = try? document.data(as: Room.self)
            else {
                return
            }
            room.start=true
            do {
                try documentReference.setData(from: room)
            } catch {
                print(error)
            }
            
        }
    }
    func deleteMem(RoomNum:String,mem:String) {
        let db = Firestore.firestore()
        let documentReference =
        db.collection("room").document(RoomNum)
        documentReference.getDocument { document, error in
            
            guard let document=document,
                  document.exists,
                  var room = try? document.data(as: Room.self)
            else {
                return
            }
            if mem==room.p1{
                room.p1=""
            }
            else if mem==room.p2{
                room.p2=""
            }
            else if mem==room.p3{
                room.p3=""
            }
            else{
                room.p4=""
            }
            room.people_num-=1
            do {
                try documentReference.setData(from: room)
            } catch {
                print(error)
            }
            
        }
    }
}
