//
//  ServiceDelivery.swift
//  BusTime
//
//  Created by Jing Wei Li on 2/18/23.
//

import Foundation

/// [Documentation](https://bustime.mta.info/wiki/Developers/SIRIStopMonitoring)
public struct SiriObject: Codable {
    public let Siri: Siri
}

public struct Siri: Codable {
    public let ServiceDelivery: ServiceDelivery
}

public extension Siri {
    struct ServiceDelivery: Codable {
        public let ResponseTimestamp: Date
        public let StopMonitoringDelivery: [StopMonitoringDelivery]
        public let SituationExchangeDelivery: [SituationExchangeDelivery]?
        
        public static var empty: ServiceDelivery {
            .init(
                ResponseTimestamp: Date(),
                StopMonitoringDelivery: [],
                SituationExchangeDelivery: []
            )
        }
    }
}

// MARK: - Stop Monitoring
public extension Siri {
    struct StopMonitoringDelivery: Codable {
        public let MonitoredStopVisit: [MonitoredStopVisit]
        public let ResponseTimestamp: Date?
        public let ValidUntil: Date?
    }
}

public extension Siri {
    struct MonitoredStopVisit: Codable {
        public let MonitoredVehicleJourney: MonitoredVehicleJourney
    }
}

public extension Siri {
    struct MonitoredVehicleJourney: Codable {
        public var id: Int {
            var hasher = Hasher()
            hasher.combine(publishedLineName.first ?? "")
            hasher.combine(vehicleRef)
            hasher.combine(bearing)
            return hasher.finalize()
        }
        
        public let publishedLineName: [String]
        public let destinationName: [String]
        public let situationRef: [SituationRef]?
        public let monitored: Bool
        public let vehicleLocation: VehicleLocation
        public let bearing: Double
        public let vehicleRef: String
        public let monitoredCall: MonitoredCall
        
        
        public enum CodingKeys: String, CodingKey {
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

public extension Siri {
    struct SituationRef: Codable {
        public let SituationSimpleRef: String
    }
}

public extension Siri {
    struct VehicleLocation: Codable {
        public let longitude: Double
        public let latitude: Double
        
        public enum CodingKeys: String, CodingKey {
            case longitude = "Longitude"
            case latitude = "Latitude"
        }
    }
}

public extension Siri {
    struct MonitoredCall: Codable {
        public let aimedArrivalTime: Date?
        public let expectedArrivalTime: Date?
        public let arrivalProximityText: String?
        public let expectedDepartureTime: Date?
        public let distanceFromStop: Int?
        public let numberOfStopsAway: Int?
        public let visitNumber: Int?
        public let stopPointName: [String]?
        public let extensions: Extensions?
        
        public enum CodingKeys: String, CodingKey {
            case aimedArrivalTime = "AimedArrivalTime"
            case expectedArrivalTime = "ExpectedArrivalTime"
            case arrivalProximityText = "ArrivalProximityText"
            case expectedDepartureTime = "ExpectedDepartureTime"
            case distanceFromStop = "DistanceFromStop"
            case numberOfStopsAway = "NumberOfStopsAway"
            case visitNumber = "VisitNumber"
            case stopPointName = "StopPointName"
            case extensions = "Extensions"
        }
    }
}

public extension Siri {
    struct Extensions: Codable {
        public let capacities: Capacities?
        
        public enum CodingKeys: String, CodingKey {
            case capacities = "Capacities"
        }
    }
}

public extension Siri {
    struct Capacities: Codable {
        public let estimatedPassengerCount: Int?
        public let estimatedPassengerCapacity: Int?
        
        public enum CodingKeys: String, CodingKey {
            case estimatedPassengerCount = "EstimatedPassengerCount"
            case estimatedPassengerCapacity = "EstimatedPassengerCapacity"
        }
    }
}



// MARK: Situations
public extension Siri {
    struct SituationExchangeDelivery: Codable {
        public let Situations: Situations
    }
}

public extension Siri {
    struct Situations: Codable {
        public let situationElement: [SituationElement]
        
        public enum CodingKeys: String, CodingKey {
            case situationElement = "PtSituationElement"
        }
    }
}

public extension Siri {
    struct SituationElement: Codable {
        public let publicationWindow: PublicationWindow?
        public let severity: String?
        public let summary: [String]?
        public let description: [String]?
        public let affects: Affects?
        public let creationTime: Date?
        public let situationNumber: String?
        
        public enum CodingKeys: String, CodingKey {
            case publicationWindow = "PublicationWindow"
            case severity = "Severity"
            case summary = "Summary"
            case description = "Description"
            case affects = "Affects"
            case creationTime = "CreationTime"
            case situationNumber = "SituationNumber"
        }
    }
}

public extension Siri {
    struct PublicationWindow: Codable {
        public let startTime: Date
        public let endTime: Date
        
        public enum CodingKeys: String, CodingKey {
            case startTime = "StartTime"
            case endTime = "EndTime"
        }
    }
}

public extension Siri {
    struct Affects: Codable {
        public let vehicleJourneys: VehicleJourneys
        
        public enum CodingKeys: String, CodingKey {
            case vehicleJourneys = "VehicleJourneys"
        }
    }
}

public extension Siri {
    struct VehicleJourneys: Codable {
        public let affectedVehicleJourney: [AffectedVehicleJourney]
        
        public enum CodingKeys: String, CodingKey {
            case affectedVehicleJourney = "AffectedVehicleJourney"
        }
    }
}

public extension Siri {
    struct AffectedVehicleJourney: Codable {
        public let lineRef: String
        public let directionRef: String?
        
        public enum CodingKeys: String, CodingKey {
            case lineRef = "LineRef"
            case directionRef = "DirectionRef"
        }
    }
}

// MARK: Helpers

public extension Siri.MonitoredCall {
    func timeToArrival(isMinimal: Bool = false) -> String {
        var arrivalTime: Date? = aimedArrivalTime
        if let expectedArrivalTime, expectedArrivalTime >= Date() {
            arrivalTime = expectedArrivalTime
        }
        guard let arrivalTime else {
            return isMinimal ? "--" : "Unknown"
        }
        let dateDiff = arrivalTime.timeIntervalSince(Date())
        let minutes = Int(dateDiff / 60)
        let seconds = Int(dateDiff) % 60
        if minutes > 0 {
            return isMinimal ? "\(minutes)M" : "\(minutes) minute(s)"
        }
        if seconds <= 0 {
            return "Now"
        }
        return isMinimal ? "\(seconds)S" : "\(seconds) second(s)"
    }
}

public extension Siri.MonitoredVehicleJourney {
    func hasSituations(serviceDelivery: Siri.ServiceDelivery) -> Bool {
        guard let situationRef = situationRef?.first,
              let situations = serviceDelivery.SituationExchangeDelivery?.first?.Situations.situationElement.compactMap(\.situationNumber) else {
            return false
        }
        return situations.contains(situationRef.SituationSimpleRef)
    }
}
