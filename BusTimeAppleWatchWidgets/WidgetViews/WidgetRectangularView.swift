//
//  WidgetRectangularView.swift
//  BusTimeAppleWatchWidgetsExtension
//
//  Created by Anderson Li on 12/10/24.
//

import SwiftUI
import WidgetKit

struct WidgetRectangularView: View {
    let entry: DualBusStopProvider.Entry
    
    init(entry: DualBusStopProvider.Entry) {
        self.entry = entry
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "bus.fill")
                    .resizable()
                    .frame(width: 14, height: 14)
                Text(entry.title)
                    .font(.callout)
                    .bold()
                    .fixedSize(horizontal: true, vertical: false)
                Text(entry.dateString)
                    .font(.callout)
                    .bold()
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                VStack(alignment: .leading) {
                    Text(entry.firstDataSet.location)
                        .customFont()
                    Text(entry.firstDataSet.busName)
                        .customFont()
                        .foregroundStyle(Color.blue)
                    Text(entry.firstDataSet.arrivalTime)
                        .customFont()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                VStack(alignment: .trailing) {
                    Text(entry.secondDataSet.location)
                        .customFont()
                    Text(entry.secondDataSet.busName)
                        .customFont()
                        .foregroundStyle(Color.blue)
                    Text(entry.secondDataSet.arrivalTime)
                        .customFont()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}

fileprivate extension View {
    func customFont() -> some View {
        font(.system(size: 12, weight: .medium))
    }
}

#Preview(as: .accessoryRectangular) {
    DualBusStopWidget()
} timeline: {
    SimpleEntry(date: Date(), dataSets: [.stub,. stub])
}

