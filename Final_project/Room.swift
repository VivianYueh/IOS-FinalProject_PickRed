//
//  Room.swift
//  Final_project
//
//  Created by 岳紀伶 on 2023/5/26.
//

import SwiftUI

struct Room: View {
    let RoomFunc=RoomFunction()
    @EnvironmentObject var player:Player
    var body: some View {
        Text(player.p1)
        Text(player.p2)
        Text(player.p3)
        Text(player.p4)
    }
}

struct Room_Previews: PreviewProvider {
    static var previews: some View {
        Room()
    }
}

