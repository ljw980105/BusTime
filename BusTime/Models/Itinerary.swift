//
//  Itinerary.swift
//  BusTime
//
//  Created by Anderson Li on 7/11/24.
//

import Foundation
import MapKit

struct Itinerary {
    struct Stop: Identifiable {
        let id = UUID()
        
        let location: CLLocationCoordinate2D
        let name: String
    }
    
    let description: String
    let region: MKCoordinateRegion
    let stops: [Stop]
    let path: [CLLocationCoordinate2D]?
    
    init(description: String, 
         region: MKCoordinateRegion,
         stops: [Stop],
         path: [CLLocationCoordinate2D]? = nil) {
        self.description = description
        self.region = region
        self.stops = stops
        self.path = path
    }
    
    var id: String {
        description
    }
}

extension Itinerary: Hashable, Equatable {
    static func == (lhs: Itinerary, rhs: Itinerary) -> Bool {
        return lhs.description == rhs.description
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(description)
    }
}

extension Itinerary {
    static let londonTrip: [Itinerary] = [
        Itinerary(
            description: "London Day 1",
            region: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 51.50780, longitude: -0.12770),
                latitudinalMeters: 2200,
                longitudinalMeters: 3000
            ),
            stops: [
                .init(location: .init(latitude: 51.49974, longitude: -0.12473), name: "Parliament Building"),
                .init(location: .init(latitude: 51.49938, longitude: -0.12651), name: "Westminster Abbey"),
                .init(location: .init(latitude: 51.50090, longitude: -0.12471), name: "Big Ben"),
                .init(location: .init(latitude: 51.50176, longitude: -0.14055), name: "Buckingham Palace"),
                .init(location: .init(latitude: 51.50780, longitude: -0.12770), name: "Trafalgar Square"),
                .init(location: .init(latitude: 51.50885, longitude: -0.12831), name: "National Gallery"),
                .init(location: .init(latitude: 51.51007, longitude: -0.13432), name: "Piccadilly Circus"),
                .init(location: .init(latitude: 51.51033, longitude: -0.13029), name: "Leicester Square"),
                .init(location: .init(latitude: 51.51305, longitude: -0.13626), name: "Soho"),
                .init(location: .init(latitude: 51.51201, longitude: -0.12371), name: "Covent Garden, Transit Museum"),
            ],
            path: [
                .init(latitude: 51.50103, longitude: -0.12622),
                .init(latitude: 51.50030, longitude: -0.14003),
                .init(latitude: 51.50216, longitude: -0.14008),
                .init(latitude: 51.50748, longitude: -0.12751),
                .init(latitude: 51.50773, longitude: -0.13114),
                .init(latitude: 51.51012, longitude: -0.13340),
                .init(latitude: 51.51055, longitude: -0.12978),
                .init(latitude: 51.51055, longitude: -0.12978),
                .init(latitude: 51.51204, longitude: -0.13136),
            ]
        ),
        Itinerary(
            description: "London Day 2",
            region: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 51.50592, longitude: -0.08767),
                latitudinalMeters: 2200,
                longitudinalMeters: 3000
            ),
            stops: [
                .init(location: .init(latitude: 51.50592, longitude: -0.07513), name: "Tower Bridge"),
                .init(location: .init(latitude: 51.50792, longitude: -0.07609), name: "Tower of London (Castle)"),
                .init(location: .init(latitude: 51.50548, longitude: -0.09056), name: "Borough Market"),
                .init(location: .init(latitude: 51.50755, longitude: -0.09861), name: "Tate Modern/Shakespeare's Globe"),
                .init(location: .init(latitude: 51.50934, longitude: -0.09854), name: "Millennium Bridge"),
                .init(location: .init(latitude: 51.51372, longitude: -0.09828), name: "St Paul's Cathedral"),
            ],
            path: [
                .init(latitude: 51.50592, longitude: -0.07513),
                .init(latitude: 51.50231, longitude: -0.07759),
                .init(latitude: 51.50755, longitude: -0.09861),
                .init(latitude: 51.51347, longitude: -0.09837)
                
            ]
        ),
        Itinerary(
            description: "London Day 3",
            region: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 51.50524, longitude: -0.18905),
                latitudinalMeters: 2200,
                longitudinalMeters: 3000
            ),
            stops: [
                .init(location: .init(latitude: 51.49657, longitude: -0.17639), name: "Natural History Museum"),
                .init(location: .init(latitude: 51.50562, longitude: -0.18578), name: "Kensington Palace"),
                .init(location: .init(latitude: 51.50617, longitude: -0.17763), name: "Hyde Park"),
                .init(location: .init(latitude: 51.51354, longitude: -0.20304), name: "Notting Hill/Portobello Rd Mkt"),
                .init(location: .init(latitude: 51.50691, longitude: -0.19477), name: "Churchill Arms Pub"),
                .init(location: .init(latitude: 51.54757, longitude: -0.26042), name: "Swaminarayan Temple")
            ]
        )
    ]
    
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
