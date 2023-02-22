//
//  StopMonitoringView.swift
//  BusTime
//
//  Created by Jing Wei Li on 2/18/23.
//

import SwiftUI
import Combine

struct StopMonitoringView: View {
    @ObservedObject var viewModel: StopMonitoringViewModel
    @State var hasError: Bool = false
    var cancellables: [AnyCancellable] = []
    
    init(viewModel: StopMonitoringViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        viewModel.receivedError = { e in
            hasError = e
        }
        
        return NavigationView {
            List(viewModel.stopJourneys, id: \.id) { stopJourney in
                NavigationLink(destination: RouteDetailView(
                    viewModel: .init(
                        vehicleJourney: stopJourney,
                        situations: viewModel.serviceDelivery.SituationExchangeDelivery?.first
                    )
                )) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            HStack {
                                if viewModel.hasSituations(vehicleJourney: stopJourney) {
                                    Image(systemName: "info.circle").foregroundColor(.red)
                                        .frame(width: 15, height: 15)
                                }
                                Text(stopJourney.publishedLineName.first ?? "Unknown")
                                    .font(.title)
                            }
                            Text(stopJourney.destinationName.first ?? "Unknown")
                                .font(.caption)
                            Text(stopJourney.monitoredCall.arrivalProximityText ?? "Unknown")
                                .font(.caption)
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(stopJourney.monitoredCall.timeToArrival)
                                .font(.caption)
                                .fontWeight(.bold)
                        }
                    }
                }
                .alert("Error", isPresented: $hasError, actions: {
                    Button("OK") {}
                }, message: {
                    Text("Encountered error: \(viewModel.error.localizedDescription)")
                })
            }
            .navigationTitle(viewModel.title)
            .refreshable {
                viewModel.refresh()
            }
        }
    }
}
