//
//  Rule.swift
//  Final_project
//
//  Created by 岳紀伶 on 2023/6/10.
//

import SwiftUI

struct Rule: View {
    @Binding var rule:Bool
    @State var rules=["只有紅色的牌有分數","Ａ值２０分，１～９的分數為各自的數字，Ｊ、Ｑ、Ｋ皆為１０分","若選擇的牌為１～９，則需與檯面上相加為１０的牌配對，若為Ｊ、Ｑ、Ｋ則需與相同符號的牌配對","若選擇的手牌可配對，則拿走檯面上配對的牌，並翻出牌堆最上面的牌，若翻出的牌與檯面上的牌仍可配對，則重複上述步驟直到沒有辦法配對","若選擇的手牌無法配對，則將牌放到檯面上，並翻出牌堆中最上面那張牌","結果計算方式：（分數最高者的分數－玩家分數）* (-10)"]
    @State var idx:Double=5
    var body: some View {
        
        ZStack{
            Color(hue: 0.594, saturation: 0.33, brightness: 0.989)
            Image(systemName: "xmark.circle")
                .onTapGesture {
                    rule=false
                }
                .offset(x:320,y:-170)
            ZStack{
                Color.white
                VStack{
                    Text("RULE")
                        .font(.title)
                        .bold()
                    Spacer()
                    HStack{
                        Text("\(Int(5-idx)+1).")
                        Text("\(rules[Int(5-idx)])")
                            .foregroundColor(Color(hue: 0.691, saturation: 0.656, brightness: 0.935))
                            .padding()
                            .frame(width: 400,height: 200)
                        Spacer()
                        Slider(value: $idx, in: 0...5)
                            .rotationEffect(.degrees(-90.0))
                    }
                    //.frame(width: 500,height: 200)
                }
                .frame(width: 500,height: 200)
            }
            .cornerRadius(20)
            .frame(width: 600,height: 300)
            
        }
        .cornerRadius(20)
        .frame(width: 700,height: 400)
        
        

        
       
        
    }
}

struct Rule_Previews: PreviewProvider {
    static var previews: some View {
        Rule(rule: .constant(true))
    }
}
