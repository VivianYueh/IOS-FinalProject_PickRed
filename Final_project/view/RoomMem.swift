//
//  RoomMem.swift
//  Final_project
//
//  Created by 岳紀伶 on 2023/5/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreSwift
struct PlayerCard :Codable,Identifiable{
    @DocumentID var id: String?
    var p1card:[Card]
    var p2card:[Card]
    var p3card:[Card]
    var p4card:[Card]
    var tacard:[Card]
    var cardDeck:[Card]
    var topindex:Int
    var p1point:Int
    var p2point:Int
    var p3point:Int
    var p4point:Int
    
}
struct RoomMem: View {
    @EnvironmentObject var gameObject:GameObject
    @EnvironmentObject var RoomFunc:RoomFunction
    @StateObject var player = Player()
    @Binding var RoomNum:String
    @Binding var nxt:Bool
    @State var user_nam=""
    @State var set = false
    //@State var start=false
    @State var idx=0
    var body: some View {
        VStack{
            HStack{
                
                Text("房號: "+RoomNum)
                    .onAppear{
                        let db = Firestore.firestore()
                            db.collection("room").document(RoomNum).addSnapshotListener { snapshot, error in
                                guard let snapshot=snapshot else { return }
                                guard let mem = try? snapshot.data(as: Room.self) else { return }
                                player.p1 = mem.p1
                                player.p2 = mem.p2
                                player.p3 = mem.p3
                                player.p4 = mem.p4
                                /*if gameObject.start==false{
                                    gameObject.start = mem.start
                                }*/
                                //print(mem)
                            }
                    }
                Image(systemName: "gearshape.fill")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        set=true
                    }
                    .sheet(isPresented: $set, content: {
                        Set(set: $set)
                    })
                    .offset(x:250)
            }
            
            HStack{
                Text("Player1:\n\(player.p1)")
                    //.fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color(hue: 0.691, saturation: 0.656, brightness: 0.935))
                    .lineLimit(2)
                    .bold()
                    .fontWeight(.bold)
                    .font(.title)
                    .frame(width: 150,height: 200)
                    .background(Color(hue: 0.594, saturation: 0.33, brightness: 0.989))
                    .cornerRadius(40)
                Text("Player2:\n\(player.p2)")
                    .lineLimit(2)
                    .foregroundColor(Color(hue: 0.691, saturation: 0.656, brightness: 0.935))
                    .bold()
                    .fontWeight(.bold)
                    .font(.title)
                    .frame(width: 150,height: 200)
                    .background(Color(hue: 0.594, saturation: 0.33, brightness: 0.989))
                    .cornerRadius(40)
                Text("Player3:\n\(player.p3)")
                    .lineLimit(2)
                    .foregroundColor(Color(hue: 0.691, saturation: 0.656, brightness: 0.935))
                    .bold()
                    .fontWeight(.bold)
                    .font(.title)
                    .frame(width: 150,height: 200)
                    .background(Color(hue: 0.594, saturation: 0.33, brightness: 0.989))
                    .cornerRadius(40)
                Text("Player4:\n\(player.p4)")
                    .lineLimit(2)
                    .foregroundColor(Color(hue: 0.691, saturation: 0.656, brightness: 0.935))
                    .bold()
                    .fontWeight(.bold)
                    .font(.title)
                    .frame(width: 150,height: 200)
                    .background(Color(hue: 0.594, saturation: 0.33, brightness: 0.989))
                    .cornerRadius(40)
            }
            
            
            HStack{
                Button("退出"){
                    nxt = false
                    
                    RoomFunc.deleteMem(RoomNum: RoomNum, mem: user_nam)
                    
                }
                Button("開始"){
                    gameObject.start=true
                    if (user_nam == player.p1){
                        idx = 1
                        gameObject.turn=1
                    }
                    else if (user_nam == player.p2){
                        idx = 2
                        gameObject.turn=2
                    }
                    else if (user_nam == player.p3){
                        idx=3
                        gameObject.turn=3
                    }
                    else if (user_nam == player.p4){
                        idx=4
                        gameObject.turn=4
                    }
                    print(idx)
                }
            }
            .onAppear{
                if let user = Auth.auth().currentUser {
                    user_nam = user.displayName!
                    
                }
                print("*"+user_nam)
                makeCard()
                makePlayer()
                gameObject.cardDeck.shuffle()
                dealCards()
                for _ in 0..<52{
                    gameObject.showCard.append(true)
                }
                
                
                
            }
            .fullScreenCover(isPresented: $gameObject.start, content:{ Game2(start: $gameObject.start,  room: $RoomNum, idx: $idx)
                    .environmentObject(gameObject)
            })
            
        }
        
        
        
        
    }
    func makeCard() {
        let suits = ["clubs", "diamond", "heart", "spade"]//梅花 方塊 紅心 黑桃
        gameObject.cardDeck=[]
        for suitIdx in 0...3{
            for num in 1...13{
                if suitIdx==0||suitIdx==3{
                    gameObject.cardDeck.append(Card(suit: suits[suitIdx], color: "black", num: num))
                }else{
                    gameObject.cardDeck.append(Card(suit: suits[suitIdx], color: "red", num: num))
                }
            }
        }
    }
    func makePlayer() {
        gameObject.players = []
        for _ in 0...3{
            gameObject.players.append(Player2(cards: [], point: 0, eatCard: [],result: 0))
        }
    }
    func dealCards(){
        gameObject.topCardIndex = 0
        for cardIndex in 0...5{
            for playerIndex in 0...3{
                gameObject.topCardIndex = 4*cardIndex+playerIndex
                gameObject.players[playerIndex].cards.append(gameObject.cardDeck[gameObject.topCardIndex])
                
                
            }
        }
        
        gameObject.tableCards = []
        for _ in 0...3{
            gameObject.topCardIndex+=1
            gameObject.tableCards.append(gameObject.cardDeck[gameObject.topCardIndex])
        }
        gameObject.createCard(idx:"0",room:RoomNum,cards: gameObject.players[0].cards,tacards: gameObject.tableCards, cardDeck: gameObject.cardDeck, top: gameObject.topCardIndex)
        
        gameObject.addCard(room:RoomNum,card1: gameObject.players[1].cards,card2: gameObject.players[2].cards,card3: gameObject.players[3].cards)
        
        
    }
    
}

struct RoomMem_Previews: PreviewProvider {
    static var previews: some View {
        RoomMem(RoomNum: .constant(""), nxt: .constant(true))
    }
}
