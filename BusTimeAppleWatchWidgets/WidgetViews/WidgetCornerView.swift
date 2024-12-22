//
//  WidgetCornerView.swift
//  BusTimeAppleWatchWidgetsExtension
//
//  Created by Anderson Li on 12/14/24.
//

import SwiftUI
import WidgetKit

struct WidgetCornerView: View {
    let entry: SingleBusStopProvider.Entry
    
    init(entry: SingleBusStopProvider.Entry) {
        self.entry = entry
    }
    
    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            Image(systemName: "bus.fill")
                .resizable()
                .frame(width: 18, height: 18)
        }
            .padding(2)
            .foregroundStyle(Color.white)
            .widgetLabel {
                Text(mainLabel)
            }
    }
    
    var mainLabel: AttributedString {
        let busName = entry.firstDataSet.busName
        var label = AttributedString("\(busName) · \(entry.firstDataSet.arrivalTime) · \(entry.firstDataSet.location)")
        guard let range = label.range(of: busName) else {
            return label
        }
        label[range].foregroundColor = .blue
        return label
        
    }
}

#Preview(as: .accessoryCorner) {
    SingleBusStopWidget()
} timeline: {
    SimpleEntry(date: Date(), dataSets: [.shortStub])
}

