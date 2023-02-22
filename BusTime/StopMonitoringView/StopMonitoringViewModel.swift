//
//  StopMonitoringViewModel.swift
//  BusTime
//
//  Created by Jing Wei Li on 2/18/23.
//

import SwiftUI
import Combine

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
    var serviceDelivery: Siri.ServiceDelivery = .empty
    var cancellables: [AnyCancellable] = []
    var receivedError: ((Bool) -> Void)?
    let stopId: Int
    let title: String
    
    init(stopId: Int, title: String) {
        self.stopId = stopId
        self.title = title
        self.error = .none
        $error
            .map {
                switch $0 {
                case .none:
                    return false
                case .error:
                    return true
                }
            }
            .sink { [weak self] val in
                self?.receivedError?(val)
            }
            .store(in: &cancellables)
        refresh()
    }
    
    func hasSituations(vehicleJourney: Siri.MonitoredVehicleJourney) -> Bool {
        return vehicleJourney.hasSituations(serviceDelivery: serviceDelivery)
    }
    
    func refresh() {
        getData()
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    print(error)
                    self?.error = .error(error: error)
                }
            }, receiveValue: { [weak self] result in
                if let journeys = result
                    .StopMonitoringDelivery.first?.MonitoredStopVisit
                    .map(\.MonitoredVehicleJourney) {
                    self?.stopJourneys = journeys
                } else {
                    self?.stopJourneys = []
                    self?.error = .error(error: NSError(domain: "Received no data", code: 0))
                }
                self?.serviceDelivery = result
            })
            .store(in: &cancellables)
    }
    
    func getData() -> AnyPublisher<Siri.ServiceDelivery, Error> {
        BustimeAPI.getBusTime(stopId: stopId)
            .eraseToAnyPublisher()
    }
    
}
