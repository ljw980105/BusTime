//
//  StopMonitoringViewModel.swift
//  BusTime
//
//  Created by Jing Wei Li on 2/18/23.
//

import Combine

class StopMonitoringViewModel: ObservableObject {
    @Published var stopJourneys: [Siri.MonitoredVehicleJourney] = []
    var serviceDelivery: Siri.ServiceDelivery = .empty
    var cancellables: [AnyCancellable] = []
    let stopId: Int
    let title: String
    
    init(stopId: Int, title: String) {
        self.stopId = stopId
        self.title = title
        refresh()
    }
    
    func hasSituations(vehicleJourney: Siri.MonitoredVehicleJourney) -> Bool {
        return vehicleJourney.hasSituations(serviceDelivery: serviceDelivery)
    }
    
    func refresh() {
        getData()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            }, receiveValue: { [weak self] result in
                self?.stopJourneys = result
                    .StopMonitoringDelivery.first?.MonitoredStopVisit
                    .map(\.MonitoredVehicleJourney) ?? []
                self?.serviceDelivery = result
            })
            .store(in: &cancellables)
    }
    
    func getData() -> AnyPublisher<Siri.ServiceDelivery, Error> {
        BustimeAPI.getBusTime(stopId: stopId)
            .eraseToAnyPublisher()
    }
    
}
