//
//  Itinerary+Extensions.swift
//  BusTime
//
//  Created by Anderson Li on 12/28/24.
//

import MapKit

public extension Itinerary {
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
    
    static let philliyTrip: [Itinerary] = [
        Itinerary(
            description: "Philadelphia Day 1",
            region: .init(
                center: .init(latitude: 39.95179, longitude: -75.15180),
                latitudinalMeters: 2200,
                longitudinalMeters: 3300
            ),
            stops: [
                .init(location: .init(latitude: 39.94918, longitude: -75.15045), name: "Liberty Bell/Independence Hall"),
                .init(location: .init(latitude: 39.95382, longitude: -75.15843), name: "Reading Terminal Market"),
                .init(location: .init(latitude: 39.95282, longitude: -75.14276), name: "Elfreth's Alley"),
                .init(location: .init(latitude: 39.94857, longitude: -75.14568), name: "Museum of American Revolution"),
            ]
        ),
        Itinerary(
            description: "Philadelphia Day 2",
            region: .init(
                center: .init(latitude: 39.96, longitude: -75.173),
                latitudinalMeters: 2200,
                longitudinalMeters: 3300
            ),
            stops: [
                .init(location: .init(latitude: 39.96537, longitude: -75.1808), name: "Philadelphia Museum of Art"),
                .init(location: .init(latitude: 39.96817, longitude: -75.17271), name: "Eastern State Penitentiary"),
                .init(location: .init(latitude: 39.94929, longitude: -75.17192), name: "Rittenhouse Square"),
                .init(location: .init(latitude: 39.95363, longitude: -75.16512), name: "Love Pk/City Hall")
            ]
        )
    ]
    
    static let edinburghTrip: [Itinerary] = [
        Itinerary(
            description: "Edinburgh Day 1",
            region: .init(
                center: .init(latitude: 55.9504, longitude: -3.1877),
                latitudinalMeters: 1500,
                longitudinalMeters: 2250
            ),
            stops: [
                .init(location: .init(latitude: 55.9418, longitude: -3.1786), name: "Old Woods Cafe"),
                .init(location: .init(latitude: 55.952532, longitude: -3.193462), name: "Scott Monument"),
                .init(location: .init(latitude: 55.949730, longitude: -3.19096), name: "St Giles' Cathedral"),
                .init(location: .init(latitude: 55.947193, longitude: -3.190666), name: "National Museum of Scotland"),
                .init(location: .init(latitude: 55.946775, longitude: -3.192640), name: "Greyfriars Kirkyard"),
                .init(location: .init(latitude: 55.947624, longitude: -3.195255), name: "Grassmarket"),
                .init(location: .init(latitude: 55.950615, longitude: -3.189727), name: "Cockburn St"),
                .init(location: .init(latitude: 55.948709, longitude: -3.193348), name: "Victoria St"),
                .init(location: .init(latitude: 55.955014, longitude: -3.183245), name: "Calton Hill")
            ]
        ),
        Itinerary(
            description: "Edinburgh Day 2",
            region: .init(
                center: .init(latitude: 55.955071, longitude: -3.211619),
                latitudinalMeters: 2000,
                longitudinalMeters: 3000
            ),
            stops: [
                .init(location: .init(latitude: 55.950251, longitude: -3.227694), name: "National Galleries of Scotland"),
                .init(location: .init(latitude: 55.951905, longitude: -3.218042), name: "Dean Village/Water of Leith"),
                .init(location: .init(latitude: 55.958073, longitude: -3.205241), name: "Circus Lane"),
                .init(location: .init(latitude: 55.964430, longitude: -3.209231), name: "Royal Botanic Gardens"),
                .init(location: .init(latitude: 55.948477, longitude: -3.200852), name: "Edinburgh Castle"),
                
            ]
        ),
    ]
}
