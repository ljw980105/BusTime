//
//  MultiEntryRectangularView.swift
//  BusTimeAppleWatchWidgetsExtension
//
//  Created by Anderson Li on 1/10/25.
//

import SwiftUI
import WidgetKit

struct MultiEntryRectangularView: View {
    let entry: SingleStopMultiEntryProvider.Entry
    
    init(entry: SingleStopMultiEntryProvider.Entry) {
        self.entry = entry
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 6) {
                Image(systemName: "bus.fill")
                    .resizable()
                    .frame(width: 14, height: 14)
                Text(location)
                    .bold()
                    .fixedSize(horizontal: true, vertical: false)
                Text(entry.dateString)
                    .bold()
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
                .font(.caption2)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(busName)
                .font(.caption2)
                .foregroundStyle(.blue)
                .widgetAccentable()
            Text(arrivalTimes)
                .font(.caption2)
        }
    }
    
    var location: String {
        entry.dataSets.first?.location.capitalized ?? ""
    }
    
    var busName: String {
        entry.dataSets.first?.busName ?? ""
    }
    
    var arrivalTimes: String {
        entry.dataSets
            .map(\.arrivalTime)
            .joined(separator: ", ")
    }
}

#Preview(as: .accessoryRectangular) {
    SingleStopMultiEntryWidget()
} timeline: {
    SimpleEntry(date: Date(), dataSets: [.shortStub, .shortStub, .shortStub])
}

