//
//  BusTimeAPI.swift
//  BusTime
//
//  Created by Jing Wei Li on 2/18/23.
//

import Combine
import Foundation

enum BustimeAPI {
    
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateFormatter = ISO8601DateFormatter()
        decoder.dateDecodingStrategy = .custom { decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = (try container.decode(String.self))
                .appending("Z")
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [
                .withInternetDateTime,
                .withFractionalSeconds
            ]
            guard let date = formatter.date(from: dateStr) else {
                throw NSError(domain: "Unable to decode date", code: 0)
            }
            return date
        }
        return decoder
    }()
    
    static func getBusTime(stopId: Int) -> AnyPublisher<Siri.ServiceDelivery, Error> {
        GetRequest(endpoint: "https://bustime.mta.info/api/siri/stop-monitoring.json")
            .setDecoder(decoder)
            .addParameter(.init(name: "key", value: "5bfdcd1c-f5bd-4489-959d-2a4dbe5d48a4"))
            .addParameter(.init(name: "version", value: "2"))
            .addParameter(.init(name: "MonitoringRef", value: String(stopId)))
            .addParameter(.init(name: "StopMonitoringDetailLevel", value: "minimum"))
            .get(resultType: SiriObject.self)
            .map(\.Siri.ServiceDelivery)
            .eraseToAnyPublisher()
    }
}
