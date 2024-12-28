//
//  BusStop.swift
//  BusTime
//
//  Created by Anderson Li on 12/8/24.
//

public enum BusStop {
    case whitestone
    case flushing
    case mainStQueensLibrary
    case crossIslandPkwy150St
    case alleyPondPark
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
