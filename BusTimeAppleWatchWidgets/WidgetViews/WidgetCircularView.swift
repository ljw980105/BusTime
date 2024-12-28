//
//  WidgetCircularView.swift
//  BusTimeAppleWatchWidgetsExtension
//
//  Created by Anderson Li on 12/10/24.
//

import SwiftUI
import WidgetKit

struct WidgetCircularView: View {
    let entry: SingleBusStopProvider.Entry
    
    init(entry: SingleBusStopProvider.Entry) {
        self.entry = entry
    }
    
    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack() {
                Text(entry.firstDataSet.busName)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.blue)
                    .widgetAccentable()
                Text(entry.firstDataSet.arrivalTime)
                    .font(.system(size: 18, weight: .medium))
                    .bold()
                Text(entry.firstDataSet.busStop.shortTitle)
                    .font(.system(size: 10, weight: .medium))
            }
        }
    }
}

#Preview(as: .accessoryCircular) {
    SingleBusStopWidget()
} timeline: {
    SimpleEntry(date: Date(), dataSets: [.shortStub])
}

