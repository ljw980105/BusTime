//
//  MoreOptionsView.swift
//  BusTime
//
//  Created by Jing Wei Li on 2/18/23.
//

import SwiftUI

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
                            stopId: Int(stopId) ?? 0,
                            title: stopId,
                            showStopName: true,
                            hideNavigationView: true
                        ))
                    }
                }
                Section("Other Stops") {
                    ForEach(additionalStops) { stop in
                        NavigationLink(destination: StopMonitoringView(viewModel: stop)) {
                            Text(stop.title)
                        }
                    }
                }
                
                Section("Extras") {
                    NavigationLink(
                        destination: ItineraryMapView(viewModel: .init(
                            itineraries: Itinerary.londonTrip,
                            key: .londonTrip
                        ))
                    ) {
                        Text("London Trip")
                    }
                }
            }
            .navigationTitle("More")
        }
    }
    
    var additionalStops: [StopMonitoringViewModel] {
        [
            .init(
                stopId: 502184,
                title: "Main St / Queens Library",
                showStopName: false,
                hideNavigationView: true
            ),
            .init(
                stopId: 505060,
                title: "Q76 / Liola Restaurant",
                showStopName: false,
                hideNavigationView: true
            )
        ]
    }
}
