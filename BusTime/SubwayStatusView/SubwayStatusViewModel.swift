//
//  SubwayStatusViewModel.swift
//  BusTime
//
//  Created by Anderson Li on 12/1/24.
//

import Combine
import Foundation
import SwiftUI

class SubwayStatusViewModel: ObservableObject {
    @Published var subwayAlerts: [GTFSRealTime.Entity] = []
    var cancellables: [AnyCancellable] = []
    let subwayRoutes: [SubwayRoute]
    let dateFormatter: DateFormatter
    
    init(subwayRoutes: [SubwayRoute] = [.seven]) {
        self.subwayRoutes = subwayRoutes
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        self.dateFormatter = formatter
    }
    
    func refresh() async throws -> [GTFSRealTime.Entity] {
        try await withCheckedThrowingContinuation { continuation in
            getData()
                .sink(receiveCompletion: { completionHandler in
                    if case .failure(let error) = completionHandler {
                        print(error)
                        continuation.resume(with: .failure(error))
                    }
                }, receiveValue: { [weak self] result in
                    guard let self = self else { return }
                    self.subwayAlerts = result
                    continuation.resume(with: .success(result))
                })
                .store(in: &cancellables)
        }
    }
    
    
    func getData() -> AnyPublisher<[GTFSRealTime.Entity], Error> {
        SubwayStatusAPI
            .getSubwayAlerts(routes: subwayRoutes)
    }
    
    var title: String {
        "Subway Status for \(subwayRoutes.map(\.rawValue).joined(separator: ", "))"
    }
    
    func formattedActivePeriod(_ activePeriods: [GTFSRealTime.ActivePeriod]) -> String? {
        guard let activePeriod = activePeriods.first else { return nil }
        var results: [String] = [dateFormatter.string(from: activePeriod.startDate)]
        if let endDate = activePeriod.endDate {
            results.append(" to \(dateFormatter.string(from: endDate))")
        }
        return "Active Date: \(results.joined(separator: ""))"
    }
}
