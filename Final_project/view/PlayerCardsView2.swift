//
//  PlayerCardsView2.swift
//  Final_project
//
//  Created by 岳紀伶 on 2023/6/7.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreSwift
struct PlayerCardsView2: View {
    @EnvironmentObject var gameObject: GameObject
    @State private var selectCard: Card = Card(suit: "heart", color: "red", num: 0)
    @State private var pointTable: [Int] = [20, 2, 3, 4, 5, 6, 7, 8, 10, 10, 10, 10, 10]
    //@State private var isPresented = false
    @State var isFin = false
    @State var isFin2 = false
    /*@State var win = false
    @State var maxPoint = 0
    @State var maxIndex = 0*/
    //@State var topIdx = 0
    @Binding var cards:[Card]
    @Binding var tcards:[Card]
    @Binding var cardDeck:[Card]
    @Binding var idx:Int
    @Binding var topIdx:Int
    var playerNum: Int//0: player, 1, 2, 3: computer
    var direction: Int//0: vertical, 1: horizontal
    var room:String
    //var idx:Int
    //var top:Int
    var body: some View {
       ZStack{
            ForEach(0..<cards.count, id: \.self){ (index) in
                if(direction==1 && (playerNum==0 || playerNum==5) ){
                    Button {
                        if(playerNum==0){
                            selectCard = cards.remove(at: index)
                            /*print("*\(idx)")
                            print("*\(cards)")
                            print("*~\(selectCard)")*/
                            /*print(cards)*/
                            judgeTable(isFirst: true, count: tcards.count)
                            
                            if(isFin==true){
                                
                                gameObject.modifyCard(RoomNum: room, card: cards,tcard: tcards,top: topIdx, idx: idx,point: gameObject.players[idx-1].point)
                                //gameObject.modifyTableCard(RoomNum: room, card: tcards)
                                //gameObject.modifyTop(RoomNum: room, idx: topIdx)
                            }
                            /*if(isFin==true && isFin2==true){
                                gameObject.modifyTableCard(RoomNum: room, card: tcards)
                            }*/
                            
                        }
                    } label: {
                        Image("\(cards[index].suit)\(cards[index].num)")
                            .resizable()
                            .transition(.topTransition)
                    }
                    .frame(width: 50, height: 75)
                    .offset(x: CGFloat(index * 20) - 50)
                    
                }//player
                else if (direction==1){
                    Image(gameObject.cardBack)
                        .resizable()
                        .frame(width: 50, height: 75)
                        .offset(x: CGFloat(index * 20) - 50)
                }
                else{
                    Image(gameObject.cardBack)
                        .resizable()
                        .frame(width: 50, height: 75)
                        .rotationEffect(.degrees(90))
                        .offset(y: CGFloat(index * 20) - 50)
                        .ignoresSafeArea()
                }//直的
                
            }
            /*.fullScreenCover(isPresented: $isPresented, content: {FullScreenView2(room:room,idx: $idx, maxPoint:$maxPoint)})
            .onAppear{
                if(topIdx>=51){
                    topIdx=52
                    
                    endGame()
                    isPresented = true
                    print(isPresented)
                }
            }*/
        }
    }
    
    
    func eatCard(tableCard: Card, selectCard: Card, cardIndex: Int, isFirst: Bool, eatRed: Bool){
        gameObject.players[idx-1].eatCard.append(tableCard)
        gameObject.players[idx-1].eatCard.append(selectCard)
        
        if(eatRed){
            gameObject.players[idx-1].point+=pointTable[tableCard.num-1]
        }
        if(selectCard.color=="red"){
            gameObject.players[idx-1].point+=pointTable[selectCard.num-1]
        }
        tcards.remove(at: cardIndex)
        //gameObject.modifyTableCard(RoomNum: room, card: tcards)
        if(!isFirst){
            tcards.remove(at: tcards.count-1)
            //gameObject.modifyTableCard(RoomNum: room, card: tcards)
        }
        print("player\(idx-1) 吃了牌面的\(tableCard.suit)\(tableCard.num)")
        
        if(isFirst){
            getTopCard()
        }
    }
    
    func judgeTable(isFirst: Bool, count: Int){
        if(isFirst) {print("player\(idx-1) 出了\(selectCard.suit)\(selectCard.num)")}
        for index in 0..<count{
            if(tcards[index].color=="red"){
                if(tcards[index].num+selectCard.num==10){
                    eatCard(tableCard: tcards[index], selectCard: selectCard, cardIndex: index, isFirst: isFirst, eatRed: true)
                    return
                }
                else if(selectCard.num>=10 && tcards[index].num==selectCard.num){
                    eatCard(tableCard: tcards[index], selectCard: selectCard, cardIndex: index, isFirst: isFirst, eatRed: true)
                    return
                }
            }//優先吃紅的
            else{
                if(tcards[index].num+selectCard.num==10){
                    eatCard(tableCard: tcards[index], selectCard: selectCard, cardIndex: index, isFirst: isFirst, eatRed: false)
                    return
                }
                else if(selectCard.num>=10 && tcards[index].num==selectCard.num){
                    eatCard(tableCard: tcards[index], selectCard: selectCard, cardIndex: index, isFirst: isFirst, eatRed: false)
                    return
                }
            }//再吃黑的
        }
        
        //沒得吃
        if(isFirst){
            print("player\(idx-1) 的 \(selectCard.suit)\(selectCard.num)放到桌上")
            tcards.append(selectCard)
            //gameObject.modifyTableCard(RoomNum: room, card: tcards)
            getTopCard()
        }//再翻一張
        isFin=true
    }
    
    func getTopCard(){
        print("player\(idx-1) 翻牌")
        topIdx+=1
        print(topIdx)
        print("player\(idx-1) 翻到 \(cardDeck[topIdx].suit) \(cardDeck[topIdx].num)")
        tcards.append(cardDeck[topIdx])
        //gameObject.modifyTableCard(RoomNum: room, card: tcards)
        selectCard = cardDeck[topIdx]
        //gameObject.modifyTop(RoomNum: room, idx: topIdx)
        print("剩下\(52-topIdx-1)張")

        judgeTable(isFirst: false, count: tcards.count-1)
        
    }//翻牌
    
    //DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
    
    /*func computerTurns(){
        
        if(gameObject.turn != 0 && gameObject.topCardIndex < 51){
            
            let selectCardIndex = Int.random(in: 0..<gameObject.players[gameObject.turn].cards.count)
            
            selectCard = gameObject.players[gameObject.turn].cards.remove(at: selectCardIndex)
            judgeTable(isFirst: true, count: gameObject.tableCards.count)
            
            gameObject.turn=(gameObject.turn+1)%gameObject.players.count
        }
        
        if(gameObject.topCardIndex==51){
            gameObject.topCardIndex=52
            endGame()
            isPresented = true
        }
    }*/
    
    /*func endGame(){
        /*var points = [0, 0, 0, 0]
        var maxPoint = 0
        var maxIndex = 0
        for index in 0..<4{
            points[index] = gameObject.players[index].point
        }
        maxPoint = points.max()!
        
        for index in 0..<4{
            if(gameObject.players[index].point==maxPoint){
                maxIndex = index
            }
            gameObject.players[index].result = (maxPoint - gameObject.players[index].point) * (-10)
        }*/
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
        
        //gameObject.players[idx-1].result = (maxPoint - gameObject.players[idx-1].point) * (-10)
        
        
        
    }*/
    
}
