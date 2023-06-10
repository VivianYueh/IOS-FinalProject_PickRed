//
//  Final_projectApp.swift
//  Final_project
//
//  Created by 岳紀伶 on 2023/5/5.
//

import SwiftUI
import Firebase
import AVFoundation
@main
struct Final_projectApp: App {
    init() {
            FirebaseApp.configure()
            
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
