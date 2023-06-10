//
//  set.swift
//  Final_project
//
//  Created by 岳紀伶 on 2023/6/9.
//

import SwiftUI
import AVFoundation
struct Set: View {
    @Binding var set:Bool
    var body: some View {
        VStack{
            HStack{
                Text("音樂開關")
                    .font(.title)
                    .fontWeight(.bold)
                Text("關")
                    .foregroundColor(.white)
                    .bold()
                    .fontWeight(.bold)
                    .font(.title)
                    .frame(width: 100,height: 50)
                    .background(Color.blue)
                    .cornerRadius(40)

                    .frame(width: 100,height: 40)
                    .onTapGesture {
                        AVPlayer.bgQueuePlayer.pause()
                        
                    }
                Text("開")
                    .foregroundColor(.white)
                    .bold()
                    .fontWeight(.bold)
                    .font(.title)
                    .frame(width: 100,height: 50)
                    .background(Color.blue)
                    .cornerRadius(40)
                    .onTapGesture {
                        AVPlayer.setupBgMusic()
                        AVPlayer.bgQueuePlayer.play()
                    }
            }
            HStack{
                Text("音樂樣式")
                    .font(.title)
                    .fontWeight(.bold)
                Text("１")
                    .foregroundColor(.white)
                    .bold()
                    .fontWeight(.bold)
                    .font(.title)
                    .frame(width: 100,height: 50)
                    .background(Color.blue)
                    .cornerRadius(40)

                    .frame(width: 100,height: 40)
                    .onTapGesture {
                        AVPlayer.bgQueuePlayer.pause()
                        AVPlayer.setupBgMusic()
                        AVPlayer.bgQueuePlayer.play()
                        
                    }
                Text("２")
                    .foregroundColor(.white)
                    .bold()
                    .fontWeight(.bold)
                    .font(.title)
                    .frame(width: 100,height: 50)
                    .background(Color.blue)
                    .cornerRadius(40)
                    .onTapGesture {
                        AVPlayer.bgQueuePlayer.pause()
                        AVPlayer.setupBgMusic1()
                        AVPlayer.bgQueuePlayer.play()
                    }
            }
            Spacer()
            Text("確定")
                .foregroundColor(.white)
                .bold()
                .fontWeight(.bold)
                .font(.title)
                .frame(width: 100,height: 50)
                .background(Color.blue)
                .cornerRadius(40)

                .frame(width: 100,height: 40)
                .onTapGesture {
                    set=false
                }
        }
        .frame(width: 500,height: 200)
    }
}

struct Set_Previews: PreviewProvider {
    static var previews: some View {
        Set(set: .constant(true))
    }
}
