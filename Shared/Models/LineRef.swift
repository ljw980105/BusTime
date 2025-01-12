//
//  LineRef.swift
//  Shared
//
//  Created by Anderson Li on 1/10/25.
//

import Foundation

public enum LineRef {
    case q44
    case q20b
    case other(lineRef: String)
    
    public init (lineRef: String) {
        switch lineRef {
        case Self.q44.lineRef:
            self = .q44
        case Self.q20b.lineRef:
            self = .q20b
        default:
            self = .other(lineRef: lineRef)
        }
    }
    
    public var lineRef: String {
        switch self {
        case .q44:
            "MTA NYCT_Q44+"
        case .q20b:
            "MTA NYCT_Q20B"
        case .other(let lineRef):
            lineRef
        }
    }
    
    public var priority: Int {
        switch self {
        case .q44:
            2
        case .q20b:
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
