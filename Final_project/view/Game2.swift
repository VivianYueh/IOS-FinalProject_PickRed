//
//  Game2.swift
//  Final_project
//
//  Created by 岳紀伶 on 2023/5/31.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreSwift
struct Card :Codable,Identifiable{
    @DocumentID var id: String?
    var suit:String
    var color:String
    var num:Int
}

struct Player2{
    var cards: [Card]
    var point: Int
    var eatCard: [Card]
    //var coin: Int
    var result: Int
}
struct Game2: View {
    @EnvironmentObject var gameObject:GameObject
    @State var top=0
    @State var tacard=[Card]()
    @State var p1card=[Card]()
    @State var p2card=[Card]()
    @State var p3card=[Card]()
    @State var p4card=[Card]()
    @State var cardDeck=[Card]()
    @State var t=0
    @State var set=false
    @State var maxPoint = 0
    @State var maxIndex = 0
    @State var win = false
    @State var isPresented = false
    @State private var isRotated = false
    @State var rule = false
    @Binding var start:Bool
    @Binding var room:String
    @Binding var idx:Int
    func cleanShowCard(){
        for cardIndex in 0...51{
            gameObject.showCard[cardIndex] = true
        }
    }
    func endGame(){
        var points = [0, 0, 0, 0]
        let db = Firestore.firestore()
        db.collection("Card").document(room).getDocument { document, error in
            
            guard let document=document,
                  document.exists,
                  let c = try? document.data(as: PlayerCard.self) else {
                return
            }
            
            points[0]=c.p1point
            points[1]=c.p2point
            points[2]=c.p3point
            points[3]=c.p4point
            
        }
        
        
        maxPoint = points.max()!
        
        if(gameObject.players[idx-1].point==maxPoint){
            maxIndex = idx
            win = true
        }
        
        
        
    }
    var body: some View {
        ZStack{
            Image("back")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                .opacity(0.8)
                .onAppear{
                    let db = Firestore.firestore()
                    db.collection("Card").document(room).addSnapshotListener { snapshot, error in
                        guard let snapshot=snapshot else { return }
                        guard let data = try? snapshot.data(as: PlayerCard.self) else { return }
                        tacard=data.tacard
                        top=data.topindex
                        cardDeck=data.cardDeck
                        if (idx==1){
                            p1card=data.p1card
                            p2card=data.p2card
                            p3card=data.p3card
                            p4card=data.p4card
                        }
                        else if (idx==2){
                            p1card=data.p2card
                            p2card=data.p3card
                            p3card=data.p4card
                            p4card=data.p1card
                        }
                        else if (idx==3){
                            p1card=data.p3card
                            p2card=data.p4card
                            p3card=data.p1card
                            p4card=data.p2card
                        }
                        else if(idx==4){
                            p1card=data.p4card
                            p2card=data.p1card
                            p3card=data.p2card
                            p4card=data.p3card
                        }
                        print(p1card)
                        print(p2card)
                        print(p3card)
                        print(p4card)
                        if(top==51){
                            endGame()
                            isPresented = true
                            //print(isPresented)
                        }
                        /*DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            
                        }*/
                        
                    }
                    
                }
            HStack{
                Image(systemName: "gearshape.fill")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        set=true
                    }
                    .sheet(isPresented: $set, content: {
                        Set(set: $set)
                    })
                
                Image(systemName: "house")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        cleanShowCard()
                        gameObject.start=false
                        
                    }
                Image(systemName: "questionmark")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        rule=true
                        
                    }
                    .sheet(isPresented: $rule, content: {
                        Rule(rule: $rule)
                    })
                
                
            }
            .offset(x:250,y:-140)
            
            VStack{
                if(set==false&&rule==false){
                    PlayerCardsView2( cards: $p3card, tcards: $tacard, cardDeck: $cardDeck, idx:$idx, topIdx: $top, playerNum: 1, direction: 1, room: room)
                    .offset(y: 10)
                    Spacer()
                    
                    HStack{
                        PlayerCardsView2( cards: $p2card, tcards: $tacard, cardDeck: $cardDeck,idx: $idx, topIdx: $top, playerNum: 1, direction: 0, room: room)
                            .offset(x: 50)
                        Spacer()
                        
                        VStack{
                            Text("剩下：\(52 - top - 1)張")
                            /*
                             Image("cardback")
                             .resizable()
                             .frame(width: 50, height: 75)
                             .rotationEffect(Angle.degrees(isRotated ? 90 : 0))
                             .animation(.easeIn)
                             */
                            PlayerCardsView2( cards: $tacard, tcards: $tacard, cardDeck: $cardDeck,idx:$idx, topIdx: $top, playerNum: 5, direction: 1,room:room)
                        }
                        //.offset(y: -50)
                        
                        Spacer()
                        PlayerCardsView2( cards: $p4card, tcards: $tacard, cardDeck: $cardDeck,idx:$idx, topIdx: $top, playerNum: 1, direction: 0, room: room)
                            .offset(x: -50)
                    }
                    Spacer()
                    PlayerCardsView2( cards: $p1card, tcards: $tacard,cardDeck: $cardDeck, idx:$idx, topIdx: $top, playerNum: 0, direction: 1, room: room)
                        .offset(y: -10)
                
                }
                
            }
        }
        .fullScreenCover(isPresented: $isPresented, content: {FullScreenView2(room:$room,idx:$idx,maxPoint:$maxPoint)})
        /*.alert("win", isPresented: $win, actions: {
                    Button("OK") { }
                })*/
        .onAppear{
            isRotated = true
            
            
        }
    }
}

struct Game2_Previews: PreviewProvider {
    static var previews: some View {
        Game2(start: .constant(true), room: .constant(""), idx: .constant(0))
    }
}
