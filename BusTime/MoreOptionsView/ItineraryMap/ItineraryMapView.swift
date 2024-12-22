//
//  ItineraryMapView.swift
//  BusTime
//
//  Created by Anderson Li on 7/11/24.
//

import SwiftUI
import Shared
import MapKit

struct ItineraryMapView: View {
    @ObservedObject var viewModel: ItineraryMapViewModel
    
    init(viewModel: ItineraryMapViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        let binding = Binding<MapCameraPosition> {
            .region(viewModel.activeItinerary.region)
        } set: { _ in }
        NavigationStack {
            Map(position: binding) {
                ForEach(viewModel.activeItinerary.stops) { stop in
                    Marker(stop.name, coordinate: stop.location)
                }
                
                if let path = viewModel.activeItinerary.path {
                    MapPolyline(points: path.map { MKMapPoint($0) })
                        .stroke(.yellow, lineWidth: 2.0)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Picker("Itineraries", selection: $viewModel.activeItinerary) {
                    ForEach(viewModel.itineraries, id: \.self) { itinerary in
                        Text(itinerary.description)
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            viewModel.loadItinerary()
        }
        .onDisappear {
            viewModel.saveItinerary()
        }
    }
    
}

#Preview {
    ItineraryMapView(viewModel: .init(
        itineraries: Itinerary.londonTrip,
        key: .londonTrip
    ))
}
