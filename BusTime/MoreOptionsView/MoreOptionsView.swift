//
//  MoreOptionsView.swift
//  BusTime
//
//  Created by Jing Wei Li on 2/18/23.
//

import SwiftUI
import Shared

struct MoreOptionsView: View {
    @State private var presentAlert = false
    @State private var stopId: String = ""
    @State private var popVc: Bool = false
    
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Button("More Stops") {
                            presentAlert = true
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 7, height: 10)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.gray)
                    }
                    .alert("Enter StopId", isPresented: $presentAlert, actions: {
                        TextField("StopId", text: $stopId)
                            .keyboardType(.numberPad)
                        Button("Cancel") {}
                            .foregroundColor(.red)
                        Button("Done") {
                            popVc = true
                        }
                    }, message: {
                        Text("Enter the 6 digit stopId")
                    })
                    .navigationDestination(isPresented: $popVc) {
                        StopMonitoringView(viewModel: .init(
                            busStop: .custom(stopId: Int(stopId) ?? 0, title: nil),
                            showStopName: true,
                            hideNavigationView: true
                        ))
                    }
                }
                Section("Other Stops") {
                    ForEach(additionalStops) { stop in
                        let viewModel = StopMonitoringViewModel(
                            busStop: stop,
                            showStopName: false,
                            hideNavigationView: true
                        )
                        NavigationLink(destination: StopMonitoringView(viewModel: viewModel)) {
                            Text(stop.title)
                        }
                    }
                }
                
                Section("Extras") {
                    NavigationLink(
                        destination: ItineraryMapView(viewModel: .init(
                            itineraries: Itinerary.edinburghTrip,
                            key: .edinburghTrip
                        ))
                    ) {
                        Text("Edinburgh Trip")
                    }
                    
                    
                    NavigationLink(
                        destination: ItineraryMapView(viewModel: .init(
                            itineraries: Itinerary.londonTrip,
                            key: .londonTrip
                        ))
                    ) {
                        Text("London Trip")
                    }
                    
                    NavigationLink(
                        destination: ItineraryMapView(viewModel: .init(
                            itineraries: Itinerary.philliyTrip,
                            key: .philadelphiaTrip
                        ))
                    ) {
                        Text("Philadelphia Trip")
                    }
                }
            }
            .navigationTitle("More")
        }
    }
    
    let additionalStops: [BusStop] = {
        [
            .mainStQueensLibrary,
            .crossIslandPkwy150St,
            .alleyPondPark,
            .baysideHmart,
            .macysFlushing
        ]
    }()
}
