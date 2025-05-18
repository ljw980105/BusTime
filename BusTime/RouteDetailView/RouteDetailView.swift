//
//  RouteDetailView.swift
//  BusTime
//
//  Created by Jing Wei Li on 2/18/23.
//

import SwiftUI
import MapKit

struct RouteDetailView: View {
    @ObservedObject var viewModel: RouteDetailViewModel
    
    init(viewModel: RouteDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Info")) {
                    if case .situations(let situations) = viewModel.situations {
                        NavigationLink {
                            AlertDescriptionView(alerts: situations)
                        } label: {
                            Text("Alerts (\(situations.count))")
                                .foregroundColor(.pink)
                                .font(.caption)
                                .fontWeight(.bold)
                        }
                    }
                    KeyValueCell("Destination", viewModel.destination)
                    KeyValueCell("Aimed Arrival", viewModel.aimedArrival)
                    KeyValueCell("Expected Arrival", viewModel.expectedArrival)
                    KeyValueCell("Proxmity", viewModel.proxmity)
                    KeyValueCell("Stops Away", viewModel.stopsAway)
                    KeyValueCell("Expected Departure", viewModel.expectedDeparture)
                    if let passengerCount = viewModel.numberOfPassengers {
                        KeyValueCell("Number of Passengers", "\(passengerCount)")
                    }
                }
                Section(header: Text("Location")) {
                    Map(position: Binding(get: {
                        viewModel.mapCameraPosition
                    }, set: { _ in })) {
                        Marker("", coordinate: viewModel.coordinate)
                    }
                        .frame(height: 200)
                        .onTapGesture {
                            viewModel.openInMaps()
                        }
                    
                }
            }
            // removes the dropdown arrow in the section headers
            .listStyle(.insetGrouped)
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
