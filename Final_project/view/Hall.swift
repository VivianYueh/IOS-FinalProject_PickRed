//
//  Hall.swift
//  Final_project
//
//  Created by 岳紀伶 on 2023/5/27.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreSwift
import AVFoundation
struct Hall: View {
    @StateObject  var gameObject=GameObject()
    @EnvironmentObject var RoomFunc:RoomFunction
    @State var add = false
    @State var user_nam=""
    @State var build = false
    @State var set=false
    @Binding var suc:Bool
    var body: some View {
        ZStack{
            Image("back")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                .opacity(0.8)
            if(gameObject.isHome){
                HStack{
                    Text("登出")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            do {
                               try Auth.auth().signOut()
                            } catch {
                               print(error)
                            }
                            RoomFunc.user.name = ""
                            RoomFunc.user.account = ""
                            suc=false
                        }
                        .onAppear{
                            gameObject.gameOver = false
                            gameObject.dealing = false
                            gameObject.loserIsPlayer=false
                        }

                    Text("|")
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.gray)
                        .onTapGesture {
                            set=true
                        }
                        .sheet(isPresented: $set, content: {
                            Set(set: $set)
                        })
                        
                }
                .offset(x:250,y:-140)
                HStack{
                    Text("人         機")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.title)
                        .padding(10)
                        .background(Color.purple)
                        .cornerRadius(40)
                        .padding(5)
                        
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.purple, lineWidth: 5)
                        )
                        .frame(width: 200,height: 50)
                        .onTapGesture {
                            gameObject.isHome = false
                            gameObject.dealing = true
                            /*AVPlayer.bgQueuePlayer.pause()
                            AVPlayer.setupBgMusic1()
                            AVPlayer.bgQueuePlayer.play()*/
                        }
                        .onAppear{
                            makeCards()
                            makePlayers()
                            gameObject.cardDeck.shuffle()
                            dealCards()
                            for _ in 0..<52{
                                gameObject.showCard.append(true)
                            }
                            
                        }
                        
                    Text("加入房間")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.title)
                        .padding(10)
                        .background(Color.purple)
                        .cornerRadius(40)
                        .padding(5)
                        
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.purple, lineWidth: 5)
                        )
                        .frame(width: 200,height: 50)
                        .sheet(isPresented: $add, content: {
                            AddRoom(suc: $suc, user_nam: $user_nam, add: $add)
                                .environmentObject(gameObject)
                        })
                        .onTapGesture {
                            add = true
                            
                        }
                    Text("建立房間")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.title)
                        .padding(10)
                        .background(Color.purple)
                        .cornerRadius(40)
                        .padding(5)
                        
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.purple, lineWidth: 5)
                        )
                        .frame(width: 200,height: 50)
                        .sheet(isPresented: $build, content: {
                            BuildRoom(build:$build,suc: $suc)
                                .environmentObject(gameObject)
                        })
                        .onTapGesture {
                            build = true
                        }
                }
                
            }
            else{
                if(gameObject.dealing){
                    DealAnimationView()
                        .environmentObject(gameObject)
                }
                else{
                    GameView()
                        .environmentObject(gameObject)
                }
                
            }
                
        }
        
        
            
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
        gameObject.players = []
        for _ in 0...3{
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
    }
}

struct Hall_Previews: PreviewProvider {
    static var previews: some View {
        Hall(suc: .constant(true))
    }
}
