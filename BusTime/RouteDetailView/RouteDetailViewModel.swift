//
//  RouteDetailViewModel.swift
//  BusTime
//
//  Created by Jing Wei Li on 2/18/23.
//

import Combine
import Foundation
import MapKit
import SwiftUI
import UIKit
import Shared
import ActivityKit
import SharedIOS

class RouteDetailViewModel: ObservableObject {
    let vehicleJourney: Siri.MonitoredVehicleJourney
    let title: String
    let destination: String
    let aimedArrival: String
    let expectedArrival: String
    let expectedArrivalTime: Date
    let expectedDeparture: String
    let proxmity: String
    let stopsAway: String
    let numberOfPassengers: Int?
    @Published var mapRegion: MKCoordinateRegion
    @Published var shouldRefreshView = UUID()
    var cancellables = [AnyCancellable]()
    
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
        expectedArrivalTime = monitoredCall.expectedArrivalTime ?? .distantFuture
        expectedDeparture = dateFormatter.string(from: monitoredCall.expectedDepartureTime ?? Date())
        proxmity = monitoredCall.arrivalProximityText ?? "Unknown"
        if let stopsAway = monitoredCall.numberOfStopsAway {
            self.stopsAway = String(stopsAway)
        } else {
            stopsAway = "Unknown"
        }
        numberOfPassengers = monitoredCall.extensions?.capacities?.estimatedPassengerCount
        
        mapRegion = MKCoordinateRegion(
            center: vehicleJourney.coordinate,
            span: .init(latitudeDelta: 0.03, longitudeDelta: 0.03)
        )
        
        let formatterForCreatedDate = DateFormatter()
        formatterForCreatedDate.dateFormat = "MMM d YYYY, h:mm"
        
        if let situationElements = situations?.Situations.situationElement,
           let journeySituations = vehicleJourney.situationRef?.first?.SituationSimpleRef,
           situationElements.compactMap(\.situationNumber).contains(journeySituations) {
            let situations = situationElements.compactMap { situation -> Situation? in
                guard let summary = situation.summary?.first,
                      let description = situation.description?.first,
                      let creationTime = situation.creationTime else {
                    return nil
                }
                return Situation(
                    created: formatterForCreatedDate.string(from: creationTime),
                    summary: summary,
                    description: description
                )
                
            }
            self.situations = .situations(situations)
        } else {
            self.situations = .none
        }
        
        LiveActivityManager.shared.onChangePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.shouldRefreshView = $0
            })
            .store(in: &cancellables)
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
    
    var mapCameraPosition: MapCameraPosition {
        .region(mapRegion)
    }
    
    var shouldDisplayLiveActivity: Bool {
        expectedArrivalTime.timeIntervalSince(.now) > 90
    }
    
    var shouldShowCancelLiveAcitivtyButton: Bool {
        LiveActivityManager.shared.hasLiveActivity
    }
    
    func trackAsLiveAcitivty() async {
        do {
            let dateDiff = expectedArrivalTime.timeIntervalSince(.now)
            await cancelLiveActivity()
            let currentLiveActivity = try Activity<LiveActivityAttributes>.request(
                attributes: .init(name: title),
                content: .init(
                    state: .init(countdown: dateDiff),
                    staleDate: nil
                ),
            )
            print("Live activity started: \(currentLiveActivity.id)")
            LiveActivityManager.shared.startLiveActivity(activity: currentLiveActivity)
            
        } catch {
            print("Failed to start live activity: \(error)")
        }
    }
    
    func cancelLiveActivity() async {
        await LiveActivityManager.shared.endLiveActivity()
    }
}

extension RouteDetailViewModel {
    enum Situations {
        case none
        case situations(_ situations: [Situation])
    }
    
    struct Situation: Identifiable {
        let id = UUID()
        
        let created: String
        let summary: String
        let description: String
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
