//
//  Itinerary.swift
//  BusTime
//
//  Created by Anderson Li on 7/11/24.
//

import Foundation
import MapKit

public struct Itinerary {
    public  struct Stop: Identifiable {
        public let id = UUID()
        
        public let location: CLLocationCoordinate2D
        public let name: String
    }
    
    public let description: String
    public let region: MKCoordinateRegion
    public let stops: [Stop]
    public let path: [CLLocationCoordinate2D]?
    
    public init(description: String,
         region: MKCoordinateRegion,
         stops: [Stop],
         path: [CLLocationCoordinate2D]? = nil) {
        self.description = description
        self.region = region
        self.stops = stops
        self.path = path
    }
    
    public var id: String {
        description
    }
}

extension Itinerary: Hashable, Equatable {
    public static func == (lhs: Itinerary, rhs: Itinerary) -> Bool {
        return lhs.description == rhs.description
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }
}

public extension Itinerary {
    
    static var stub: Itinerary {
        Itinerary(
            description: "Test",
            region: .init(
                center: .init(latitude: 0, longitude: 0), 
                span: .init(latitudeDelta: 10, longitudeDelta: 10)
            ),
            stops: []
        )
    }
}
