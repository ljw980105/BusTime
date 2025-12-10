//
//  MultiStopMonitoringView.swift
//  BusTime
//
//  Created by Anderson Li on 11/24/25.
//

import SwiftUI
import Combine

struct MultiStopMonitoringView: View {
    @ObservedObject var viewModel: MultiStopMonitoringViewModel
    var cancellables: [AnyCancellable] = []
    
    init(viewModel: MultiStopMonitoringViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if viewModel.hideNavigationView {
            contentView
        } else {
            NavigationView {
                contentView
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Picker("Routes", selection: $viewModel.selectedFilterOption) {
                                ForEach(viewModel.filterOptions, id: \.self) { filterOption in
                                    Text(filterOption.name.capitalized)
                                }
                            }
                            .pickerStyle(.menu)
                        }
                    }
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
            if viewModel.shouldShowArrivalTimesCard {
                Section {
                    ArrivalTimesCardView(stopJourneys: viewModel.journeysForHighestPriorityLine)
                        .frame(height: 80)
                        .listRowInsets(EdgeInsets())
                }
            }
            Section {
                ForEach(viewModel.displayedStopJourneys, id: \.id) { stopJourney in
                    NavigationLink(destination: RouteDetailView(
                        viewModel: .init(
                            vehicleJourney: stopJourney,
                            situations: viewModel.combinedSituationDelivery
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
                                    if stopJourney.isHighOccupancy {
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
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(stopJourney.monitoredCall.timeToArrival())
                                    .font(.caption)
                                    .fontWeight(.bold)
                                if let stopName = viewModel.stopNamesByLineRef[stopJourney.lineRef ?? ""] {
                                    Text(stopName)
                                        .font(.caption2)
                                        .foregroundStyle(.gray)
                                }
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
        .listSectionSpacing(8)
        .navigationTitle(viewModel.navBarTitle)
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            await viewModel.refreshAsync()
        }
    }
}

#Preview {
    MultiStopMonitoringView(viewModel: .init(
        firstBusStop: .flushing,
        secondBusStop: .macysFlushing,
        name: "Flushing"
    ))
}
