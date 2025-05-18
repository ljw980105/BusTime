//
//  ArrivalTimesCardView.swift
//  BusTime
//
//  Created by Anderson Li on 5/17/25.
//

import SwiftUI
import Shared

struct ArrivalTimesCardView: View {
    private let rows = [GridItem(.fixed(30))]
    let stopJourneys: [Siri.MonitoredVehicleJourney]
    
    init(stopJourneys: [Siri.MonitoredVehicleJourney]) {
        self.stopJourneys = stopJourneys
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows) {
                ForEach(stopJourneys) { journey in
                    ZStack {
                        RoundedRectangle(cornerSize: .init(width: 10, height: 10))
                            .foregroundStyle(Color("Cell"))
                        VStack(alignment: .leading) {
                            Text(journey.publishedLineName.first ?? "")
                                .font(.caption2)
                            Text(journey.monitoredCall.timeToArrival(isMinimal: true))
                                .font(.headline)
                        }
                        .padding(10)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .background(Color("CellBackground"))
    }
}

#Preview {
    ArrivalTimesCardView(stopJourneys: [
        Siri.MonitoredVehicleJourney(publishedLineName: ["M14-SBS"]),
        Siri.MonitoredVehicleJourney(publishedLineName: ["M15-SBS"]),
        Siri.MonitoredVehicleJourney(publishedLineName: ["M16-SBS"])
    ])
    .frame(width: 375, height: 60)
}
