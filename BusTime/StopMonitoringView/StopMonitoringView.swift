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
    var cancellables: [AnyCancellable] = []
    
    init(viewModel: StopMonitoringViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if viewModel.hideNavigationView {
            contentView
        } else {
            NavigationView {
                contentView
            }
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        if case .error(let error) = viewModel.error {
            VStack(spacing: 20) {
                Spacer()
                Text(error.localizedDescription)
                    .foregroundColor(.red)
                retryButton
                Spacer()
            }
            .padding(16)
        } else {
            listView
        }
    }
    
    var retryButton: some View {
        Button(action: {
            Task {
                await viewModel.refreshAsync()
            }
        }, label: {
            ZStack {
                Capsule()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                Text("Retry")
            }
            .frame(height: 40)
        })
    }
    
    var listView: some View {
        List {
            Section {
                ForEach(viewModel.stopJourneys, id: \.id) { stopJourney in
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
                                        Image(systemName: "info.circle")
                                            .foregroundStyle(.red)
                                            .frame(width: 15, height: 15)
                                    }
                                    if viewModel.isHighOccupancy(vehicleJourney: stopJourney) {
                                        Tag(text: "BUSY")
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
                                Text(stopJourney.monitoredCall.timeToArrival())
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                }
            } footer: {
                HStack {
                    Text("Last Updated: \(viewModel.lastUpdated)")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
        .navigationTitle(viewModel.navBarTitle)
        .navigationBarTitleDisplayMode(viewModel.showStopName ? .inline : .large)
        .refreshable {
            await viewModel.refreshAsync()
        }
    }
}
