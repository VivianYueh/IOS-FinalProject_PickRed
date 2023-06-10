//
//  FullScreenView.swift
//  PickRed
//
//  Created by User15 on 2021/3/17.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreSwift
import AVFoundation
struct FullScreenView2: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gameObject: GameObject
    @State private var selectCard: Card = Card(suit: "heart", color: "red", num: 0)
    @State private var pointTable: [Int] = [20, 2, 3, 4, 5, 6, 7, 8, 10, 10, 10, 10, 10]
    @State var points=[0,0,0,0]
    @State var nxt = false
    @Binding var room:String
    @Binding var idx:Int
    @Binding var maxPoint:Int
    var body: some View {
        ZStack{
            
            VStack{
                if(gameObject.gameOver){
                    VStack{
                        Text("遊戲結束")
                            .font(.system(size: 40, weight: .bold))
                    }
                }
                //Text(room)
                VStack{
                    HStack{
                        Text("Player")
                            .font(.system(size: 18, weight: .bold))
                            .frame(width: 125, height: 30, alignment: .center)
                        Text("Point")
                            .font(.system(size: 18, weight: .bold))
                            .frame(width: 125, height: 30, alignment: .center)
                        Text("Result")
                            .font(.system(size: 18, weight: .bold))
                            .frame(width: 125, height: 30, alignment: .center)
                    }
                    ForEach(0..<4){(index) in
                        
                        let tmpPlayerNum = index
                        let point = points[index]
                        let result = (maxPoint - points[index]) * (-10)
                        
                        ResultRow2(playerNum: tmpPlayerNum, point: point, result: result, idx: idx, room: $room)
                    }
                }
                .offset(y: 40)
                
                HStack{
                    if(!gameObject.gameOver){
                        Button{
                            presentationMode.wrappedValue.dismiss()
                            makeCards()
                            makePlayers()
                            gameObject.cardDeck.shuffle()
                            dealCards()
                            nxt = true
                            //computerPlayCard()
                            //gameObject.dealing = true
                        } label: {
                            Text("下一局")
                        }
                        .fullScreenCover(isPresented: $nxt, content:{ Game2(start: $nxt,  room: $room, idx: $idx)
                                .environmentObject(gameObject)
                        })
                    }
                    Button{
                        cleanShowCard()
                        gameObject.start=false
                        /*AVPlayer.bgQueuePlayer.pause()
                        AVPlayer.setupBgMusic()
                        AVPlayer.bgQueuePlayer.play()*/
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("回到主畫面")
                    }
                }
                .offset(y: 60)
            }
            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height, alignment: .center)
            .background(
                Image("back")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.8)
                
            )
            .onAppear{
                 
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
            }
            /*if(gameObject.loserIsPlayer){
                Image("sadImage")
                    .resizable()
                    .frame(width: 120, height: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .offset(x: -350, y: 100)
            }*/
        }
        .ignoresSafeArea(.all)
        
    }
    
    func makeCards(){
        let suits = ["clubs", "diamond", "heart", "spade"]//梅花 方塊 紅心 黑桃
        gameObject.cardDeck = []
        for suitIndex in 0...3{
            for num in 1...13{
                if(suitIndex==0||suitIndex==3){
                    gameObject.cardDeck.append(Card(suit: suits[suitIndex], color: "black", num: num))
                }//黑
                else{
                    gameObject.cardDeck.append(Card(suit: suits[suitIndex], color: "red", num: num))
                }//紅
            }
        }
    }
    
    func makePlayers(){
        var coins = [0, 0, 0, 0]
        
        gameObject.players = []
        for index in 0...3{
            gameObject.players.append(Player2(cards: [], point: 0, eatCard: [], result: 0))
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
        gameObject.createCard(idx:"0",room:room,cards: gameObject.players[0].cards,tacards: gameObject.tableCards, cardDeck: gameObject.cardDeck, top: gameObject.topCardIndex)
        
        gameObject.addCard(room:room,card1: gameObject.players[1].cards,card2: gameObject.players[2].cards,card3: gameObject.players[3].cards)
        
    }
    
    func cleanShowCard(){
        for cardIndex in 0...51{
            gameObject.showCard[cardIndex] = true
        }
    }
    
    func computerPlayCard(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            computerTurns()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                computerTurns()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    computerTurns()
                }
            }
        }
    }
    
    func eatCard(tableCard: Card, selectCard: Card, cardIndex: Int, isFirst: Bool, eatRed: Bool){
        gameObject.players[gameObject.turn].eatCard.append(tableCard)
        gameObject.players[gameObject.turn].eatCard.append(selectCard)
        if(eatRed){
            gameObject.players[gameObject.turn].point+=pointTable[tableCard.num-1]
        }
        if(selectCard.color=="red"){
            gameObject.players[gameObject.turn].point+=pointTable[selectCard.num-1]
        }
        gameObject.tableCards.remove(at: cardIndex)
        if(!isFirst){
            gameObject.tableCards.remove(at: gameObject.tableCards.count-1)
        }
        print("player\(gameObject.turn) 吃了牌面的\(tableCard.suit)\(tableCard.num)")
        
        if(isFirst){
            getTopCard()
        }
    }
    
    func judgeTable(isFirst: Bool, count: Int){
        if(isFirst) {print("player\(gameObject.turn) 出了\(selectCard.suit)\(selectCard.num)")}
        for index in 0..<count{
            if(gameObject.tableCards[index].color=="red"){
                if(gameObject.tableCards[index].num+selectCard.num==10){
                    eatCard(tableCard: gameObject.tableCards[index], selectCard: selectCard, cardIndex: index, isFirst: isFirst, eatRed: true)
                    return
                }
                else if(selectCard.num>=10 && gameObject.tableCards[index].num==selectCard.num){
                    eatCard(tableCard: gameObject.tableCards[index], selectCard: selectCard, cardIndex: index, isFirst: isFirst, eatRed: true)
                    return
                }
            }//優先吃紅的
            else{
                if(gameObject.tableCards[index].num+selectCard.num==10){
                    eatCard(tableCard: gameObject.tableCards[index], selectCard: selectCard, cardIndex: index, isFirst: isFirst, eatRed: false)
                    return
                }
                else if(selectCard.num>=10 && gameObject.tableCards[index].num==selectCard.num){
                    eatCard(tableCard: gameObject.tableCards[index], selectCard: selectCard, cardIndex: index, isFirst: isFirst, eatRed: false)
                    return
                }
            }//再吃黑的
        }
        
        //沒得吃
        if(isFirst){
            print("player\(gameObject.turn) 的 \(selectCard.suit)\(selectCard.num)放到桌上")
            gameObject.tableCards.append(selectCard)
            getTopCard()
        }//再翻一張
    }
    
    func getTopCard(){
        print("player\(gameObject.turn) 翻牌")
        gameObject.topCardIndex+=1
        print("player\(gameObject.turn) 翻到 \(gameObject.cardDeck[gameObject.topCardIndex].suit) \(gameObject.cardDeck[gameObject.topCardIndex].num)")
        gameObject.tableCards.append(gameObject.cardDeck[gameObject.topCardIndex])
        selectCard = gameObject.cardDeck[gameObject.topCardIndex]
        print("剩下\(52-gameObject.topCardIndex-1)張")
        judgeTable(isFirst: false, count: gameObject.tableCards.count-1)
    }//翻牌
    
    //DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
    
    func computerTurns(){
        
        if(gameObject.turn != 0 && gameObject.topCardIndex < 51){
            
            let selectCardIndex = Int.random(in: 0..<gameObject.players[gameObject.turn].cards.count)
            
            selectCard = gameObject.players[gameObject.turn].cards.remove(at: selectCardIndex)
            judgeTable(isFirst: true, count: gameObject.tableCards.count)
            
            gameObject.turn=(gameObject.turn+1)%gameObject.players.count
        }
        
    }
    
    func endGame(){
        var points = [0, 0, 0, 0]
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
        }
        for index in 0..<4{
            if(index != maxIndex){
                
                gameObject.players[maxIndex].result-=gameObject.players[index].result
            }
            
            
            
        }
        
        
    }
    
}


struct FullScreenView2_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenView2(room: .constant(""), idx: .constant(0), maxPoint: .constant(0))
    }
}
