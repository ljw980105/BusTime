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
                MultiStopMonitoringView(viewModel: .init(
                    firstBusStop: .flushing,
                    secondBusStop: .macysFlushing,
                    name: "Flushing"
                ))
                    .tabItem {
                        Label(BusStop.flushing.title, systemImage: "toilet")
                    }
                MoreOptionsView()
                    .tabItem {
                        Label("More", systemImage: "ellipsis")
                    }
            }
        }
    }
}
