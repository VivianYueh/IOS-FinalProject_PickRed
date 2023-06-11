//
//  GameObject.swift
//  Final_project
//
//  Created by 岳紀伶 on 2023/5/28.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreSwift
class GameObject: ObservableObject {
    @Published var cardDeck: [Card] = []
    @Published var players: [Player2] = []
    @Published var topCardIndex: Int = 0
    @Published var tableCards: [Card] = []
    @Published var bankerNum: Int = 0
    @Published var turn: Int = Int.random(in: 0...3)
    @Published var isHome = true
    @Published var gameOver = false
    @Published var dealing = false
    @Published var showCard: [Bool] = [true]
    @Published var loserIsPlayer: Bool = false
    @Published var cardBack = "redBack"
    @Published var isChoosingCard = false
    @Published var start = false
    //@Published var idx = 0
    func createCard(idx:String,room:String,cards:[Card],tacards:[Card],cardDeck:[Card],top:Int){
        let db = Firestore.firestore()
        let playercard = PlayerCard(p1card: cards, p2card: [], p3card: [], p4card: [], tacard: tacards, cardDeck: cardDeck, topindex: top,p1point: 0,p2point: 0,p3point: 0,p4point: 0)
        do {
            try
                
            db.collection("Card").document(room).setData(from: playercard)
        } catch {
            print(error)
        }
    }
    func addCard(room:String,card1:[Card],card2:[Card],card3:[Card]) {
        let db = Firestore.firestore()
            let documentReference = db.collection("Card").document(room)
            
            documentReference.getDocument { document, error in
                
                guard let document=document,
                      document.exists,
                      var c = try? document.data(as: PlayerCard.self)
                else {
                    return
                }
                c.p2card=card1
                c.p3card=card2
                c.p4card=card3
                do {
                    try documentReference.setData(from: c)
                } catch {
                    print(error)
                }
            }
    }
    
    func modifyCard(RoomNum:String,card:[Card],tcard:[Card],top:Int,idx:Int,point:Int) {
        print(RoomNum)
        print(idx)
        let db = Firestore.firestore()
        let documentReference =
        db.collection("Card").document(RoomNum)
        documentReference.getDocument { document, error in
            
            guard let document=document,
                  document.exists,
                  var c = try? document.data(as: PlayerCard.self)
            else {
                return
            }
            c.topindex=top
            c.tacard=tcard
            if(idx==1){
                c.p1card=card
                c.p1point=point
            }
            else if(idx==2){
                c.p2card=card
                c.p2point=point
            }
            else if(idx==3){
                c.p3card=card
                c.p3point=point
            }
            else if(idx==4){
                c.p4card=card
                c.p4point=point
            }
            do {
                try documentReference.setData(from: c)
            } catch {
                print(error)
            }
            print("~~\(c)")
            self.getInf(room: RoomNum)
        }
        
    }
  
    func getInf(room:String) {
        let db = Firestore.firestore()
        db.collection("Card").document(room).getDocument { document, error in
            
            guard let document=document,
                  document.exists,
                  let c = try? document.data(as: PlayerCard.self) else {
                return
            }
            
            print("***\(c)")
            
        }
    }
    /*func modifyTableCard(RoomNum:String,card:[Card]) {
        let db = Firestore.firestore()
        let documentReference =
        db.collection("Card").document(RoomNum)
        documentReference.getDocument { document, error in
            
            guard let document=document,
                  document.exists,
                  var c = try? document.data(as: PlayerCard.self)
            else {
                return
            }
            c.tacard=card
            do {
                try documentReference.setData(from: c)
            } catch {
                print(error)
            }
            
        }
    }
    func modifyTop(RoomNum:String,idx:Int) {
        let db = Firestore.firestore()
        let documentReference =
        db.collection("Card").document(RoomNum)
        documentReference.getDocument { document, error in
            
            guard let document=document,
                  document.exists,
                  var c = try? document.data(as: PlayerCard.self)
            else {
                return
            }
            c.topindex=idx
            do {
                try documentReference.setData(from: c)
            } catch {
                print(error)
            }
            print(c.topindex)
        }
    }*/
}
