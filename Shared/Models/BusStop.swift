//
//  BusStop.swift
//  BusTime
//
//  Created by Anderson Li on 12/8/24.
//

public enum BusStop {
    /// Parsons Blvd / 14Av
    case whitestone
    /// Main St / 39 Av
    case flushing
    /// Main St / Kissena Blvd
    case mainStQueensLibrary
    /// Cross Island Pkwy / 150th St
    case crossIslandPkwy150St
    /// Springfield Blvd / 73 Av
    case alleyPondPark
    /// Francis Lewis Blvd / 47 Av
    case baysideHmart
    case custom(stopId: Int, title: String?)
    
    public var stopId: Int {
        switch self {
        case .whitestone:
            502434
        case .flushing:
            502185
        case .mainStQueensLibrary:
            502184
        case .crossIslandPkwy150St:
            505059
        case .alleyPondPark:
            501660
        case .baysideHmart:
            502697
        case .custom(let stopId, _):
            stopId
        }
    }
    
    public var title: String {
        switch self {
        case .whitestone:
            "Whitestone"
        case .flushing:
            "Flushing"
        case .mainStQueensLibrary:
            "Main St / Queens Library"
        case .crossIslandPkwy150St:
            "Cross Island Pkwy / 150th St"
        case .alleyPondPark:
            "Alley Pond Park"
        case .baysideHmart:
            "Q76 - Hmart"
        case .custom(_, let title):
            title ?? String(stopId)
        }
    }
    
    public var shortTitle: String {
        switch self {
        case .whitestone:
            "WHI"
        case .flushing:
            "FLU"
        case .mainStQueensLibrary:
            "LIB"
        case .crossIslandPkwy150St:
            "CRO"
        case .alleyPondPark:
            "ALY"
        default:
            "--"
        }
    }
    
    public init(stopId: Int) {
        switch stopId {
        case BusStop.whitestone.stopId:
            self = .whitestone
        case BusStop.flushing.stopId:
            self = .flushing
        case BusStop.mainStQueensLibrary.stopId:
            self = .mainStQueensLibrary
        case BusStop.crossIslandPkwy150St.stopId:
            self = .crossIslandPkwy150St
        case BusStop.alleyPondPark.stopId:
            self = .alleyPondPark
        case BusStop.baysideHmart.stopId:
            self = .baysideHmart
        default:
            self = .custom(stopId: stopId, title: nil)
        }
    }
}

extension BusStop: Identifiable {
    public var id: Int { stopId }
}

extension BusStop: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(stopId)
    }
}
