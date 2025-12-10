//
//  StopMonitoringViewWatchViewModel.swift
//  BusTimeAppleWatch Watch App
//
//  Created by Anderson Li on 12/21/24.
//

import Foundation
import Shared

class StopMonitoringViewWatchViewModel: ObservableObject {
    @Published var stopJourneys: [Siri.MonitoredVehicleJourney] = []
//    @Published var error: BusTimeError
    @Published var navBarTitle: String = ""
    @Published var lastUpdated: String = ""
    var serviceDelivery: Siri.ServiceDelivery = .empty
    var receivedError: ((Bool) -> Void)?
    let busStop: BusStop
    
    init(busStop: BusStop) {
        self.busStop = busStop
        navBarTitle = busStop.title
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm"
        return formatter
    }()
    
    private func getData() async throws -> Siri.ServiceDelivery {
        try await BustimeAPI.getBusTimeAsync(stopId: busStop.stopId, maximumStopVisits: 3)
    }
    
    @MainActor
    func refresh() async {
        let results = try? await getData()
        lastUpdated = dateFormatter.string(from: Date())
        if let journeys = results?.StopMonitoringDelivery.first?.MonitoredStopVisit?
            .map(\.MonitoredVehicleJourney), !journeys.isEmpty {
            stopJourneys = journeys
        } else {
            stopJourneys = []
        }
    }
    
}
