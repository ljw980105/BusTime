//
//  ServiceDelivery.swift
//  BusTime
//
//  Created by Jing Wei Li on 2/18/23.
//

import Foundation

struct SiriObject: Codable {
    let Siri: Siri
}

struct Siri: Codable {
    let ServiceDelivery: ServiceDelivery
}

extension Siri {
    struct ServiceDelivery: Codable {
        let ResponseTimestamp: Date
        let StopMonitoringDelivery: [StopMonitoringDelivery]
        
        static var empty: ServiceDelivery {
            .init(ResponseTimestamp: Date(), StopMonitoringDelivery: [])
        }
    }
}

extension Siri {
    struct StopMonitoringDelivery: Codable {
        let MonitoredStopVisit: [MonitoredStopVisit]
        let ResponseTimestamp: Date?
        let ValidUntil: Date?
    }
}

extension Siri {
    struct MonitoredStopVisit: Codable {
        let MonitoredVehicleJourney: MonitoredVehicleJourney
    }
}

extension Siri {
    struct MonitoredVehicleJourney: Codable {
        var id: Int {
            var hasher = Hasher()
            hasher.combine(publishedLineName.first ?? "")
            hasher.combine(vehicleRef)
            hasher.combine(bearing)
            return hasher.finalize()
        }
        
        let publishedLineName: [String]
        let destinationName: [String]
        let situationRef: [SituationRef]?
        let monitored: Bool
        let vehicleLocation: VehicleLocation
        let bearing: Double
        let vehicleRef: String
        let monitoredCall: MonitoredCall
        
        
        enum CodingKeys: String, CodingKey {
            case publishedLineName = "PublishedLineName"
            case destinationName = "DestinationName"
            case situationRef = "SituationRef"
            case monitored = "Monitored"
            case vehicleLocation = "VehicleLocation"
            case bearing = "Bearing"
            case vehicleRef = "VehicleRef"
            case monitoredCall = "MonitoredCall"
        }
    }
}

extension Siri {
    struct SituationRef: Codable {
        let SituationSimpleRef: String
    }
}

extension Siri {
    struct VehicleLocation: Codable {
        let longitude: Double
        let latitude: Double
        
        enum CodingKeys: String, CodingKey {
            case longitude = "Longitude"
            case latitude = "Latitude"
        }
    }
}

extension Siri {
    struct MonitoredCall: Codable {
        let aimedArrivalTime: Date?
        let expectedArrivalTime: Date?
        let arrivalProximityText: String?
        let expectedDepartureTime: Date?
        let distanceFromStop: Int?
        let numberOfStopsAway: Int?
        let visitNumber: Int?
        
        enum CodingKeys: String, CodingKey {
            case aimedArrivalTime = "AimedArrivalTime"
            case expectedArrivalTime = "ExpectedArrivalTime"
            case arrivalProximityText = "ArrivalProximityText"
            case expectedDepartureTime = "ExpectedDepartureTime"
            case distanceFromStop = "DistanceFromStop"
            case numberOfStopsAway = "NumberOfStopsAway"
            case visitNumber = "VisitNumber"
        }
    }
}

extension Siri.MonitoredCall {
    var timeToArrival: String {
        guard let arrivalTime = expectedArrivalTime else {
            return "Unknown"
        }
        let dateDiff = arrivalTime.timeIntervalSince(Date())
        let minutes = Int(dateDiff / 60)
        let seconds = Int(dateDiff) % 60
        if minutes > 0 {
            return "\(minutes) minute(s)"
        }
        if seconds <= 0 {
            return "Now"
        }
        return "\(seconds) second(s)"
    }
}
