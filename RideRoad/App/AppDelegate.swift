//
//  AppDelegate.swift

import SwiftUI

import UserNotifications

@main
struct Ride_App: App {
    
    var body: some Scene {
        WindowGroup {
            Group {
                FirstView()
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}





