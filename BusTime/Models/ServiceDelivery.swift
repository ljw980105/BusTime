//
//  ServiceDelivery.swift
//  BusTime
//
//  Created by Jing Wei Li on 2/18/23.
//

import Foundation

/// [Documentation](https://bustime.mta.info/wiki/Developers/SIRIStopMonitoring)
struct SiriObject: Codable {
    let Siri: Siri
}

struct Siri: Codable {
    let ServiceDelivery: ServiceDelivery
}

extension Siri {
    struct ServiceDelivery: Codable {
        let ResponseTimestamp: Date
        let StopMonitoringDelivery: [StopMonitoringDelivery]?
        let SituationExchangeDelivery: [SituationExchangeDelivery]?
        let VehicleMonitoringDelivery: [VehicleMonitoringDelivery]?
        
        static var empty: ServiceDelivery {
            .init(
                ResponseTimestamp: Date(),
                StopMonitoringDelivery: [],
                SituationExchangeDelivery: [],
                VehicleMonitoringDelivery: []
            )
        }
    }
}

// MARK: - Stop Monitoring
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
        let stopPointName: [String]?
        let extensions: Extensions?
        
        enum CodingKeys: String, CodingKey {
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

extension Siri {
    struct Extensions: Codable {
        let capacities: Capacities?
        
        enum CodingKeys: String, CodingKey {
            case capacities = "Capacities"
        }
    }
}

extension Siri {
    struct Capacities: Codable {
        let estimatedPassengerCount: Int?
        let estimatedPassengerCapacity: Int?
        
        enum CodingKeys: String, CodingKey {
            case estimatedPassengerCount = "EstimatedPassengerCount"
            case estimatedPassengerCapacity = "EstimatedPassengerCapacity"
        }
    }
}



// MARK: Situations
extension Siri {
    struct SituationExchangeDelivery: Codable {
        let Situations: Situations
    }
}

extension Siri {
    struct Situations: Codable {
        let situationElement: [SituationElement]
        
        enum CodingKeys: String, CodingKey {
            case situationElement = "PtSituationElement"
        }
    }
}

extension Siri {
    struct SituationElement: Codable {
        let publicationWindow: PublicationWindow?
        let severity: String?
        let summary: [String]?
        let description: [String]?
        let affects: Affects?
        let creationTime: Date?
        let situationNumber: String?
        
        enum CodingKeys: String, CodingKey {
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

extension Siri {
    struct PublicationWindow: Codable {
        let startTime: Date
        let endTime: Date
        
        enum CodingKeys: String, CodingKey {
            case startTime = "StartTime"
            case endTime = "EndTime"
        }
    }
}

extension Siri {
    struct Affects: Codable {
        let vehicleJourneys: VehicleJourneys
        
        enum CodingKeys: String, CodingKey {
            case vehicleJourneys = "VehicleJourneys"
        }
    }
}

extension Siri {
    struct VehicleJourneys: Codable {
        let affectedVehicleJourney: [AffectedVehicleJourney]
        
        enum CodingKeys: String, CodingKey {
            case affectedVehicleJourney = "AffectedVehicleJourney"
        }
    }
}

extension Siri {
    struct AffectedVehicleJourney: Codable {
        let lineRef: String
        let directionRef: String?
        
        enum CodingKeys: String, CodingKey {
            case lineRef = "LineRef"
            case directionRef = "DirectionRef"
        }
    }
}

// MARK: Vehicle Monitoring
extension Siri {
    struct VehicleMonitoringDelivery: Codable {
        let vehicleActivity: [VehicleActivity]
        
        enum CodingKeys: String, CodingKey {
            case vehicleActivity = "VehicleActivity"
        }
    }
}

extension Siri {
    struct VehicleActivity: Codable {
        let monitoredVehicleJourney: [MonitoredVehicleJourney]
        
        enum CodingKeys: String, CodingKey {
            case monitoredVehicleJourney = "MonitoredVehicleJourney"
        }
    }
}
// MARK: Helpers

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

extension Siri.MonitoredVehicleJourney {
    func hasSituations(serviceDelivery: Siri.ServiceDelivery) -> Bool {
        guard let situationRef = situationRef?.first,
              let situations = serviceDelivery.SituationExchangeDelivery?.first?.Situations.situationElement.compactMap(\.situationNumber) else {
            return false
        }
        return situations.contains(situationRef.SituationSimpleRef)
    }
}
