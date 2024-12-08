//
//  BusTimeAPI.swift
//  BusTime
//
//  Created by Jing Wei Li on 2/18/23.
//

import Combine
import Foundation

public enum BustimeAPI {
    
    private enum Keys: String {
        case APIKEY = "API_KEY"
    }
    
    /// Setup a Configurations.xcconfig file including the API_KEY prop to setup this var.
    public static let apiKey: String = {
        guard let infoDict = Bundle.main.infoDictionary,
        let key = infoDict[Keys.APIKEY.rawValue] as? String else {
            fatalError("NO API KEY PROVIDED. SETUP XCCONFIG")
        }
        return key
    }()
    
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
    
    public static func getBusTime(stopId: Int) -> AnyPublisher<Siri.ServiceDelivery, Error> {
        GetRequest(endpoint: "https://bustime.mta.info/api/siri/stop-monitoring.json")
            .setDecoder(decoder)
            .addParameter(.init(name: "key", value: apiKey))
            .addParameter(.init(name: "version", value: "2"))
            .addParameter(.init(name: "MonitoringRef", value: String(stopId)))
            .addParameter(.init(name: "StopMonitoringDetailLevel", value: "basic"))
            .addParameter(.init(name: "MaximumStopVisits", value: "8"))
            .get(resultType: SiriObject.self)
            .map(\.Siri.ServiceDelivery)
            .eraseToAnyPublisher()
    }
}
