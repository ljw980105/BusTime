//
//  BusTimeApp.swift
//  BusTime
//
//  Created by Jing Wei Li on 2/18/23.
//

import SwiftUI
import Shared

@main
struct BusTimeApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                StopMonitoringView(viewModel: .init(busStop: .whitestone, showStopName: false))
                    .tabItem {
                        Label(BusStop.whitestone.title, systemImage: "mountain.2")
                    }
                StopMonitoringView(viewModel: .init(busStop: .flushing, showStopName: false))
                    .tabItem {
                        Label(BusStop.flushing.title, systemImage: "toilet")
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
