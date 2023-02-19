//
//  RouteDetailView.swift
//  BusTime
//
//  Created by Jing Wei Li on 2/18/23.
//

import SwiftUI
import MapKit

struct RouteDetailView: View {
    let viewModel: RouteDetailViewModel
    @State var mapRegion: MKCoordinateRegion
    
    
    init(viewModel: RouteDetailViewModel) {
        self.viewModel = viewModel
        self.mapRegion = viewModel.mapRegion
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    if viewModel.hasSituations {
                        HStack {
                            Text("Alerts")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.pink)
                            Text(viewModel.situationsText)
                                .font(.caption)
                                .foregroundColor(.pink)
                                .multilineTextAlignment(.leading)
                        }.padding(5)
                    }
                    KeyValueCell("Destination", viewModel.destination)
                    KeyValueCell("Aimed Arrival", viewModel.aimedArrival)
                    KeyValueCell("Expected Arrival", viewModel.expectedArrival)
                    KeyValueCell("Proxmity", viewModel.proxmity)
                    KeyValueCell("Stops Away", viewModel.stopsAway)
                    KeyValueCell("Expected Departure", viewModel.expectedDeparture)
                    Map(
                        coordinateRegion: $mapRegion,
                        interactionModes: [],
                        annotationItems: [viewModel]
                    ) { place in
                        MapMarker(coordinate: place.coordinate)
                    }
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: 200)
                        .onTapGesture {
                            viewModel.openInMaps()
                        }
                }
            }
        }
        .navigationTitle(viewModel.title)
    }
}
