//
//  RouteDetailViewModel.swift
//  BusTime
//
//  Created by Jing Wei Li on 2/18/23.
//

import Foundation
import MapKit
import SwiftUI

class RouteDetailViewModel {
    let vehicleJourney: Siri.MonitoredVehicleJourney
    let title: String
    let destination: String
    let aimedArrival: String
    let expectedArrival: String
    let expectedDeparture: String
    let proxmity: String
    let stopsAway: String
    let mapRegion: MKCoordinateRegion
    let situations: Situations
    
    init(vehicleJourney: Siri.MonitoredVehicleJourney, situations: Siri.SituationExchangeDelivery?) {
        self.vehicleJourney = vehicleJourney
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        title = vehicleJourney.publishedLineName.first ?? "Unknown"
        destination = vehicleJourney.destinationName.first ?? "Unknown"
        let monitoredCall = vehicleJourney.monitoredCall
        aimedArrival = dateFormatter.string(from: monitoredCall.aimedArrivalTime ?? Date())
        expectedArrival = dateFormatter.string(from: monitoredCall.expectedArrivalTime ?? Date())
        expectedDeparture = dateFormatter.string(from: monitoredCall.expectedDepartureTime ?? Date())
        proxmity = monitoredCall.arrivalProximityText ?? "Unknown"
        if let stopsAway = monitoredCall.numberOfStopsAway {
            self.stopsAway = String(stopsAway)
        } else {
            stopsAway = "Unknown"
        }
        
        mapRegion = MKCoordinateRegion(
            center: vehicleJourney.coordinate,
            span: .init(latitudeDelta: 0.03, longitudeDelta: 0.03)
        )
        
        if let situationElements = situations?.Situations.situationElement,
           let journeySituations = vehicleJourney.situationRef?.first?.SituationSimpleRef,
           situationElements.compactMap(\.situationNumber).contains(journeySituations) {
            self.situations = .situations(situationsText: situationElements
                .compactMap(\.summary)
                .flatMap { $0 }
                .joined(separator: "\n\n")
            )
        } else {
            self.situations = .none
        }
        
    }
    
    func openInMaps() {
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: mapRegion.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: mapRegion.span)
        ]
        let placemark = MKPlacemark(coordinate: mapRegion.center, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.openInMaps(launchOptions: options)
    }
}

extension RouteDetailViewModel {
    enum Situations {
        case none
        case situations(situationsText: String)
    }
}

extension RouteDetailViewModel: Identifiable {
    var id: UUID {
        .init()
    }
}

extension RouteDetailViewModel {
    var coordinate: CLLocationCoordinate2D {
        vehicleJourney.coordinate
    }
}

extension Siri.MonitoredVehicleJourney {
    var coordinate: CLLocationCoordinate2D {
        .init(
            latitude: vehicleLocation.latitude,
            longitude: vehicleLocation.longitude
        )
    }
}