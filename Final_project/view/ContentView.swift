//
//  ContentView.swift
//  Final_project
//
//  Created by 岳紀伶 on 2023/5/5.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreSwift
import AVFoundation

extension AVPlayer {
    
    func playFromStart() {
        seek(to: .zero)
        play()
    }
    
    static var bgQueuePlayer = AVQueuePlayer()
    static var bgPlayerLooper: AVPlayerLooper!
    static func setupBgMusic() {
        guard let url = Bundle.main.url(forResource: "bgm",
        withExtension: "mp3") else { fatalError("Failed to find sound file.") }
        let item = AVPlayerItem(url: url)
        bgPlayerLooper = AVPlayerLooper(player: bgQueuePlayer, templateItem: item)
    }
    static func setupBgMusic1() {
        guard let url = Bundle.main.url(forResource: "bgm2",
        withExtension: "mp3") else { fatalError("Failed to find sound file.") }
        let item = AVPlayerItem(url: url)
        bgPlayerLooper = AVPlayerLooper(player: bgQueuePlayer, templateItem: item)
    }
}
struct Room: Codable, Identifiable {
    @DocumentID var id: String?
    var p1: String
    var p2: String
    var p3: String
    var p4: String
    var people_num: Int
    var start:Bool
}
struct ContentView: View {
    @StateObject var RoomFunc = RoomFunction()
    @State var user_acc=""
    @State var user_pas=""
    @State var user_nam=""
    @State var user_rom=""
    @State var RoomNum = ""
    @State var people_number=0
    @State var reg = false
    @State var log = false
    @State var suc = false
    @State var set=false
    var body: some View {
        VStack{
            Group{
                Text(RoomFunc.user.account)
                Text(RoomFunc.user.name)
            }
            Group{
                ZStack{
                    Image("back")
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                        .opacity(0.8)
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.gray)
                        .onTapGesture {
                            set=true
                        }
                        .sheet(isPresented: $set, content: {
                            Set(set: $set)
                        })
                        .offset(x:250,y:-100)
                    VStack{
                        Text("撿紅點")
                            .foregroundColor(.black)
                            .font(.system(.largeTitle, design: .rounded))
                        HStack{
                            Text("登入")
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
                                .frame(width: 100,height: 50)
                                .sheet(isPresented: $log, content: {
                                    Log(log: $log, suc: $suc)
                                })
                                .onTapGesture {
                                    log = true
                                    if let user1 = Auth.auth().currentUser {
                                        RoomFunc.user.name = user1.displayName!
                                        RoomFunc.user.account = user1.email!
                                    }
                                }
                            Text("註冊")
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
                                .frame(width: 100,height: 50)
                                .sheet(isPresented: $reg, content: {
                                    Reg(user_acc: $user_acc, user_pas: $user_pas, user_nam: $user_nam, user_rom: $user_rom, suc: $suc,reg:$reg)
                                })
                                .onTapGesture {
                                    reg = true
                                    
                                    
                                }
                        }
                    }
                    
                    
                }
            }
            .onAppear{
                AVPlayer.setupBgMusic()
                AVPlayer.bgQueuePlayer.play()
            }
            .environmentObject(RoomFunc)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
