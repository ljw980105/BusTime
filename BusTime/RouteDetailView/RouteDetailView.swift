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
        NavigationView {
            VStack {
                List {
                    if case .situations(let situations) = viewModel.situations {
                        Section(header: Text("Alerts (\(situations.count)):")) {
                            TabView {
                                ForEach(situations) { situation in
                                    VStack(spacing: 0) {
                                        Text(situation.summary)
                                            .font(.caption)
                                            .foregroundColor(.pink)
                                            .multilineTextAlignment(.leading)
                                            .padding(.top, 5)
                                        Spacer()
                                    }
                                    .onTapGesture {
                                        viewModel.showSituationDescription(situation.description)
                                    }
                                }
                            }
                            .tabViewStyle(PageTabViewStyle())
                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                            .frame(height: situations.count > 1 ? 100 : 50)
                            .padding(.bottom, situations.count > 1 ? -15 : -10 )
                        }
                    }
                    Section(header: Text("Info")) {
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
                        Map(
                            coordinateRegion: Binding(get: {
                                viewModel.mapRegion
                            }, set: { _ in }),
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
                    // removes the dropdown arrow in the section headers
                    .listStyle(.insetGrouped)
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
