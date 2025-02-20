//
//  StopMonitoringViewModel.swift
//  BusTime
//
//  Created by Jing Wei Li on 2/18/23.
//

import Foundation
import SwiftUI
import Combine
import Shared

enum BusTimeError: Error {
    case none
    case error(error: Error)
    
    var localizedDescription: String {
        switch self {
        case .none:
            return "None"
        case .error(let error):
            return error.localizedDescription
        }
    }
}

class StopMonitoringViewModel: ObservableObject {
    @Published var stopJourneys: [Siri.MonitoredVehicleJourney] = []
    @Published var error: BusTimeError
    @Published var navBarTitle: String = ""
    @Published var lastUpdated: String = ""
    var serviceDelivery: Siri.ServiceDelivery = .empty
    var cancellables: [AnyCancellable] = []
    var receivedError: ((Bool) -> Void)?
    let busStop: BusStop
    let showStopName: Bool
    let hideNavigationView: Bool
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm"
        return formatter
    }()
    
    /// - Parameters:
    ///   - showStopName: If true, uses small nav bar and also adds stop names in parenthesis for the nav bar.
    ///   otherwise, uses large navbar
    ///   - hideNavigationView: Set this to true if this view is used inside another NavigationView
    init(busStop: BusStop,
         showStopName: Bool,
         hideNavigationView: Bool = false) {
        self.busStop = busStop
        self.error = .none
        self.hideNavigationView = hideNavigationView
        self.showStopName = showStopName
        $error
            .map {
                switch $0 {
                case .none:
                    return false
                case .error:
                    return true
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] val in
                self?.receivedError?(val)
            }
            .store(in: &cancellables)
        Task {
            await refreshAsync()
        }
    }
    
    func hasSituations(vehicleJourney: Siri.MonitoredVehicleJourney) -> Bool {
        return vehicleJourney.hasSituations(serviceDelivery: serviceDelivery)
    }
    
    func refreshAsync() async {
        do {
            let journeys = try await refresh()
            DispatchQueue.main.async {
                self.error = .none
                self.stopJourneys = journeys
                self.lastUpdated = self.dateFormatter.string(from: Date())
            }
        } catch let errors {
            DispatchQueue.main.async {
                self.error = .error(error: errors)
            }
        }
    }
    
    func refresh() async throws -> [Siri.MonitoredVehicleJourney] {
        try await withCheckedThrowingContinuation { continuation in
            getData()
                .sink(receiveCompletion: { completionHandler in
                    if case .failure(let error) = completionHandler {
                        print(error)
                        continuation.resume(with: .failure(error))
                    }
                }, receiveValue: { [weak self] result in
                    guard let self = self else { return }
                    if let journeys = result
                        .StopMonitoringDelivery.first?.MonitoredStopVisit
                        .map(\.MonitoredVehicleJourney), !journeys.isEmpty {
                        continuation.resume(with: .success(journeys))
                        if let stopName = journeys.map(\.monitoredCall).first?.stopPointName?.first,
                           self.showStopName {
                            self.navBarTitle = "\(self.busStop.title) (\(stopName))"
                        } else {
                            self.navBarTitle = self.busStop.title
                        }
                    } else {
                        continuation.resume(with: .failure(NSError(domain: "Received no data", code: 0)))
                    }
                    self.serviceDelivery = result
                })
                .store(in: &cancellables)
        }
    }
    
    func getData() -> AnyPublisher<Siri.ServiceDelivery, Error> {
        BustimeAPI.getBusTime(stopId: busStop.stopId)
    }
    
}

extension StopMonitoringViewModel: Identifiable {}
