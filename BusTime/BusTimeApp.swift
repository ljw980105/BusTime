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
                StopMonitoringView(viewModel: .init(stopId: 502434, title: "Whitestone", showStopName: false))
                    .tabItem {
                        Label("Whitestone", systemImage: "mountain.2")
                    }
                StopMonitoringView(viewModel: .init(stopId: 502185, title: "Flushing", showStopName: false))
                    .tabItem {
                        Label("Flushing", systemImage: "toilet")
                    }
                SubwayStatusView(viewModel: .init(subwayRoutes: [.seven]))
                    .tabItem {
                        Label("Subway Status", systemImage: "7.circle.fill")
                    }
                MoreOptionsView()
                    .tabItem {
                        Label("More", systemImage: "ellipsis")
                    }
            }
        }
    }
}
