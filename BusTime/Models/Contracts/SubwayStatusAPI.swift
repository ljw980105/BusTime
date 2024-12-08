//
//  SubwayStatusAPI.swift
//  BusTime
//
//  Created by Anderson Li on 12/1/24.
//

import Foundation
import Combine

enum SubwayRoute: String, CaseIterable {
    case seven = "7"
}

enum SubwayStatusAPI {
    static func getSubwayAlerts(routes: [SubwayRoute] = [.seven]) -> AnyPublisher<[GTFSRealTime.Entity], Error> {
        guard let route = routes.first else {
            print("More than 1 route not supported")
            return Fail(error: NSError(domain: "More than 1 route not supported", code: 0))
                .eraseToAnyPublisher()
        }
        
        return GetRequest(endpoint: "https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/camsys%2Fsubway-alerts.json")
            .get(resultType: GTFSRealTime.self)
            .map { result in
                result.entity
                    .filter { entity in
                        entity.alert.informedEntity.compactMap(\.routeId).contains(route.rawValue)
                        && (entity.alert.activePeriod.first?.endDate ?? .distantPast) > Date()
                    }
                    .sorted { lhs, rhs in
                        lhs.alert.activePeriod.first?.startDate ?? .distantFuture
                            < rhs.alert.activePeriod.first?.startDate ?? .distantFuture
                    }
            }
            .eraseToAnyPublisher()
    }
}
