//
//  LineRef.swift
//  Shared
//
//  Created by Anderson Li on 1/10/25.
//

import Foundation

public enum LineRef {
    case q44
    case q20
    case other(lineRef: String)
    
    public init (lineRef: String) {
        switch lineRef {
        case Self.q44.lineRef:
            self = .q44
        case Self.q20.lineRef:
            self = .q20
        default:
            self = .other(lineRef: lineRef)
        }
    }
    
    public var lineRef: String {
        switch self {
        case .q44:
            "MTA NYCT_Q44+"
        case .q20:
            "MTA NYCT_Q20"
        case .other(let lineRef):
            lineRef
        }
    }
    
    public var priority: Int {
        switch self {
        case .q44:
            2
        case .q20:
            1
        default:
            0
        }
    }
}

extension LineRef: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(lineRef)
    }
}
