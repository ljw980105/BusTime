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
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    StopMonitoringViewWatch(viewModel: .init(busStop: .whitestone))
                }
                .navigationTitle {
                    Text(BusStop.whitestone.title)
                }
                NavigationView {
                    StopMonitoringViewWatch(viewModel: .init(busStop: .flushing))
                }
                .navigationTitle {
                    Text(BusStop.flushing.title)
                }
            }
            .tabViewStyle(.verticalPage)
        }
    }
}
