//
//  BusTimeAppleWatchApp.swift
//  BusTimeAppleWatch Watch App
//
//  Created by Anderson Li on 12/8/24.
//

import SwiftUI
import Shared

@main
struct BusTimeAppleWatch_Watch_App: App {
    @State var activeBusStop = BusStop.whitestone
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $activeBusStop) {
                NavigationView {
                    StopMonitoringViewWatch(viewModel: .init(busStop: .whitestone))
                }
                    .navigationTitle {
                        Text(BusStop.whitestone.title)
                    }
                    .tag(BusStop.whitestone)
                NavigationView {
                    StopMonitoringViewWatch(viewModel: .init(busStop: .flushing))
                }
                    .navigationTitle {
                        Text(BusStop.flushing.title)
                    }
                    .tag(BusStop.flushing)
            }
            .tabViewStyle(.verticalPage)
            .onOpenURL { url in
                // Deeplink handling
                guard url.scheme == "bustime",
                      let stopId = Int(url.lastPathComponent) else {
                    return
                }
                activeBusStop = BusStop(stopId: stopId)
            }
        }
    }
}
