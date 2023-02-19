//
//  StopMonitoringViewModel.swift
//  BusTime
//
//  Created by Jing Wei Li on 2/18/23.
//

import Combine

class StopMonitoringViewModel: ObservableObject {
    @Published var stopJourneys: [Siri.MonitoredVehicleJourney] = []
    var cancellables: [AnyCancellable] = []
    let stopId: Int
    let title: String
    
    init(stopId: Int, title: String) {
        self.stopId = stopId
        self.title = title
        refresh()
    }
    
    func refresh() {
        getData()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            }, receiveValue: { result in
                self.stopJourneys = result
            })
            .store(in: &cancellables)
    }
    
    func getData() -> AnyPublisher<[Siri.MonitoredVehicleJourney], Error> {
        BustimeAPI.getBusTime(stopId: stopId)
            .map { $0.StopMonitoringDelivery.first?.MonitoredStopVisit ?? [] }
            .map { (items: [Siri.MonitoredStopVisit]) in items.map(\.MonitoredVehicleJourney) }
            .eraseToAnyPublisher()
    }
    
}
