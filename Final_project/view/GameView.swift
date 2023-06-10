//
//  GameView.swift
//  PickRed
//
//  Created by User15 on 2021/3/10.
//

import SwiftUI
import AVFoundation
struct GameView: View {
    @EnvironmentObject var gameObject: GameObject
    @State private var isRotated = false
    @State var set=false
    @State var rule=false
    func cleanShowCard(){
        for cardIndex in 0...51{
            gameObject.showCard[cardIndex] = true
        }
    }
    var body: some View {
        ZStack{
            Image("back")
                .resizable()
                .scaledToFill()
                .opacity(0.8)
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
                        gameObject.dealing = false
                        gameObject.isHome = true
                        gameObject.gameOver = false
                        
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
                    PlayerCardsView( cards: gameObject.players[2].cards, playerNum: 1, direction: 1)
                    .offset(y: 10)
                    Spacer()
                    
                    HStack{
                        PlayerCardsView( cards: gameObject.players[1].cards, playerNum: 1, direction: 0)
                            .offset(x: 50)
                        Spacer()
                        
                        VStack{
                            Text("剩下：\(52 - gameObject.topCardIndex - 1)張")
                            /*
                             Image("cardback")
                             .resizable()
                             .frame(width: 50, height: 75)
                             .rotationEffect(Angle.degrees(isRotated ? 90 : 0))
                             .animation(.easeIn)
                             */
                            PlayerCardsView( cards: gameObject.tableCards, playerNum: 5, direction: 1)
                        }
                        //.offset(y: -50)
                        
                        Spacer()
                        PlayerCardsView( cards: gameObject.players[3].cards, playerNum: 1, direction: 0)
                            .offset(x: -50)
                    }
                    Spacer()
                    PlayerCardsView( cards: gameObject.players[0].cards, playerNum: 0, direction: 1)
                        .offset(y: -10)
                }
                
            }
            .ignoresSafeArea()
            .onAppear{
                isRotated = true
                
            }
        }
        
        
        
        
    }
    
    
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

