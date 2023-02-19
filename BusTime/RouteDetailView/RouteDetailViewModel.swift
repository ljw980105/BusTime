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
    
    init(vehicleJourney: Siri.MonitoredVehicleJourney) {
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
