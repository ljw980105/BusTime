//
//  StopMonitoringViewWatch.swift
//  BusTimeAppleWatch Watch App
//
//  Created by Anderson Li on 12/21/24.
//

import Foundation
import SwiftUI

struct StopMonitoringViewWatch: View {
    @ObservedObject var viewModel: StopMonitoringViewWatchViewModel
    
    init (viewModel: StopMonitoringViewWatchViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            Section{
                ForEach(viewModel.stopJourneys, id: \.id) { stopJourney in
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(stopJourney.publishedLineName.first ?? "Unknown")
                                    .font(.headline)
                            }
                            Text(stopJourney.destinationName.first ?? "Unknown")
                                .font(.system(size: 12))
                            Text(stopJourney.monitoredCall.arrivalProximityText ?? "Unknown")
                                .font(.system(size: 12))
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(stopJourney.monitoredCall.timeToArrival(isMinimal: true))
                                .font(.caption)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.vertical, 12)
                }
            } footer: {
                HStack {
                    Text("Last Updated: \(viewModel.lastUpdated)")
                        .font(.system(size: 10))
                }
                .frame(maxWidth: .infinity)
            }
        }
        .listStyle(.carousel)
        .navigationTitle(viewModel.navBarTitle)
        .onAppear {
            Task {
                await viewModel.refresh()
            }
        }
    }
}
