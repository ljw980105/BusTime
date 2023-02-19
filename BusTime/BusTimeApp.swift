//
//  BusTimeApp.swift
//  BusTime
//
//  Created by Jing Wei Li on 2/18/23.
//

import SwiftUI

@main
struct BusTimeApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                StopMonitoringView(viewModel: .init(stopId: 502434, title: "Whitestone"))
                    .tabItem {
                        Label("Whitestone", systemImage: "mountain.2")
                    }
                StopMonitoringView(viewModel: .init(stopId: 502185, title: "Flushing"))
                    .tabItem {
                        Label("Flushing", systemImage: "toilet")
                    }
            }
        }
    }
}
