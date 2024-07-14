//
//  ItineraryMapView.swift
//  BusTime
//
//  Created by Anderson Li on 7/11/24.
//

import SwiftUI
import MapKit

struct ItineraryMapView: View {
    let itineraries: [Itinerary]
    @State var activeItinerary: Itinerary
    
    init(itineraries: [Itinerary]) {
        self.itineraries = itineraries
        _activeItinerary = State(initialValue: itineraries.first ?? .stub)
    }
    
    var body: some View {
        let binding = Binding<MapCameraPosition> {
            .region(activeItinerary.region)
        } set: { _ in }
        NavigationStack {
            Map(position: binding) {
                ForEach(activeItinerary.stops) { stop in
                    Marker(stop.name, coordinate: stop.location)
                }
                
                if let path = activeItinerary.path {
                    MapPolyline(points: path.map { MKMapPoint($0) })
                        .stroke(.yellow, lineWidth: 2.0)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Picker("Itineraries", selection: $activeItinerary) {
                    ForEach(itineraries, id: \.self) { itinerary in
                        Text(itinerary.description)
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
    }
    
}

#Preview {
    ItineraryMapView(itineraries: Itinerary.londonTrip)
}
