//
//  MultiStopMonitoringViewModel.swift
//  BusTime
//
//  Created by Anderson Li on 11/24/25.
//

import Foundation
@preconcurrency import Shared
import Combine

class MultiStopMonitoringViewModel: ObservableObject {
    enum FilterOption: Hashable {
        case all
        case stop(name: String)
        
        var name: String {
            switch self {
            case .all: "All"
            case .stop(let name): name
            }
        }
    }
    
    var stopJourneys: [Siri.MonitoredVehicleJourney] = [] {
        didSet {
            shouldShowArrivalTimesCard = stopJourneys.shouldShowArrivalTimesCard
            journeysForHighestPriorityLine = stopJourneys.journeysForHighestPriorityLine
            stopNamesByLineRef = stopJourneys.stopNamesByLineRef
            buildFilterOptions()
            filterDisplayedJourneys(by: selectedFilterOption)
        }
    }
    @Published var displayedStopJourneys: [Siri.MonitoredVehicleJourney] = []
    
    @Published var error: BusTimeError
    @Published var navBarTitle: String = ""
    @Published var lastUpdated: String = ""
    @Published var filterOptions: [FilterOption] = []
    @Published var selectedFilterOption: FilterOption = .all {
        didSet {
            filterDisplayedJourneys(by: selectedFilterOption)
        }
    }

    var firstServiceDelivery: Siri.ServiceDelivery = .empty
    var secondServiceDelivery: Siri.ServiceDelivery = .empty
    var cancellables: [AnyCancellable] = []
    var receivedError: ((Bool) -> Void)?
    let firstBusStop: BusStop
    let secondBusStop: BusStop
    let hideNavigationView: Bool
    var shouldShowArrivalTimesCard: Bool = false
    var journeysForHighestPriorityLine: [Siri.MonitoredVehicleJourney] = []
    var stopNamesByLineRef: [String: String] = [:]
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm"
        return formatter
    }()
    
    init(firstBusStop: BusStop,
         secondBusStop: BusStop,
         name: String,
         hideNavigationView: Bool = false) {
        self.firstBusStop = firstBusStop
        self.secondBusStop = secondBusStop
        self.error = .none
        self.hideNavigationView = hideNavigationView
        self.navBarTitle = name
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
        vehicleJourney.hasSituations(serviceDelivery: firstServiceDelivery)
            || vehicleJourney.hasSituations(serviceDelivery: secondServiceDelivery)
    }
    
    func refreshAsync() async {
        do {
            let journeys = try await refresh()
            DispatchQueue.main.async {
                self.error = .none
                (self.firstServiceDelivery, self.secondServiceDelivery) = journeys
                self.stopJourneys = self.combinedJournies(for: [
                    self.firstServiceDelivery,
                    self.secondServiceDelivery
                ])
                self.lastUpdated = self.dateFormatter.string(from: Date())
            }
        } catch let errors {
            DispatchQueue.main.async {
                self.error = .error(error: errors)
            }
        }
    }
    
    func refresh() async throws -> (Siri.ServiceDelivery, Siri.ServiceDelivery) {
        try await withCheckedThrowingContinuation { continuation in
            getData()
                .sink(receiveCompletion: { completionHandler in
                    if case .failure(let error) = completionHandler {
                        print(error)
                        continuation.resume(with: .failure(error))
                    }
                }, receiveValue: { [weak self] result in
                    guard let self = self else { return }
                    let (firstBusStop, secondBusStop) = result
                    guard let firstJourney = validServiceDelivery(for: firstBusStop),
                          let secondJourney = validServiceDelivery(for: secondBusStop) else {
                        continuation.resume(with: .failure(NSError(domain: "Received no data", code: 0)))
                        return
                    }
                    continuation.resume(with: .success((firstJourney, secondJourney)))
                })
                .store(in: &cancellables)
        }
    }
    
    private func validServiceDelivery(for serviceDelivery: Siri.ServiceDelivery) -> Siri.ServiceDelivery? {
        guard let journeys = serviceDelivery
            .StopMonitoringDelivery.first?.MonitoredStopVisit?
            .map(\.MonitoredVehicleJourney), !journeys.isEmpty else {
            return nil
        }
        return serviceDelivery
    }
    
    var combinedSituationDelivery: Siri.SituationExchangeDelivery? {
        let situtationsElements = Set(
            [firstServiceDelivery, secondServiceDelivery]
                .flatMap {
                    $0.SituationExchangeDelivery?.first?.Situations.situationElement ?? []
                }
        )
        return .init(
            Situations: .init(situationElement: Array(situtationsElements))
        )
    }
    
    private func combinedJournies(
        for serviceDeliveries: [Siri.ServiceDelivery]
    ) -> [Siri.MonitoredVehicleJourney] {
        serviceDeliveries
            .flatMap {
                $0.StopMonitoringDelivery.first?.MonitoredStopVisit?.map(\.MonitoredVehicleJourney) ?? []
            }
            .sorted(by: {
                ($0.monitoredCall.expectedArrivalTime ?? .distantFuture)
                < ($1.monitoredCall.expectedArrivalTime ?? .distantFuture)
            })
    }
    
    private func buildFilterOptions() {
        filterOptions = [.all] +
            Set(stopNamesByLineRef.values)
            .map { FilterOption.stop(name: $0) }
    }
    
    private func filterDisplayedJourneys(by filterOption: FilterOption) {
        switch filterOption {
        case .all:
            displayedStopJourneys = stopJourneys
        case .stop(let name):
            displayedStopJourneys = stopJourneys.filter { journey in
                journey.monitoredCall.stopPointName?.first == name
            }
        }
    }
    
    // MARK: API
    
    func getData() -> AnyPublisher<(Siri.ServiceDelivery, Siri.ServiceDelivery), Error> {
        Publishers.Zip(
            BustimeAPI.getBusTime(stopId: firstBusStop.stopId)
                .replaceEmpty(with: .empty),
            BustimeAPI.getBusTime(stopId: secondBusStop.stopId)
                .replaceEmpty(with: .empty)
        )
        .eraseToAnyPublisher()
    }
}
