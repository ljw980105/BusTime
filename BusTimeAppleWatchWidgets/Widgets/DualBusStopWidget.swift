//
//  DualBusStopWidget.swift
//  BusTime
//
//  Created by Anderson Li on 12/10/24.
//
import WidgetKit
import SwiftUI
import Shared

/// [Tutorial](https://swiftsenpai.com/development/getting-started-widgetkit/)
struct DualBusStopProvider: AppIntentTimelineProvider {
    /// Providing dummy data to the system to render a placeholder UI while waiting for the widget to get ready.
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now, dataSets: [
            .init(location: "Whitestone", busName: "Q44", arrivalTime: "1 Min"),
            .init(location: "Flushing", busName: "Q20B", arrivalTime: "1 Min")
        ])
    }

    /// This function mainly provides the data required by the system to render the widget in the widget gallery. Following is the implementation:
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: .now, dataSets: [
            .init(location: "Whitestone", busName: "Q44", arrivalTime: "1 Min"),
            .init(location: "Flushing", busName: "Q20B", arrivalTime: "1 Min")
        ])
    }
    
    /// This is the most important method in the timeline provider as it provides an array of timeline entries for the current time and, optionally, any future times to update a widget.
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        do {
            let entryResult = try await getEntryResult()
            entries.append(entryResult)
        } catch {
            entries.append(.init(date: .distantFuture, dataSets: [.stub, .stub]))
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
    
    func getEntryResult() async throws -> SimpleEntry {
        var whitestoneResult: Siri.ServiceDelivery?
        var flushingResult: Siri.ServiceDelivery?
        whitestoneResult = try await BustimeAPI.getBusTimeAsync(stopId: BusStop.whitestone.stopId, maximumStopVisits: 1)
        flushingResult = try await BustimeAPI.getBusTimeAsync(stopId: BusStop.flushing.stopId, maximumStopVisits: 1)
        
        guard let whitestoneResult, let flushingResult else {
            throw NSError(domain: "No Results found", code: 0)
        }
        
        let whitestoneMonitoredJourney = whitestoneResult.StopMonitoringDelivery.first?.MonitoredStopVisit.first?.MonitoredVehicleJourney
        let flushingMinotoredJourney = flushingResult.StopMonitoringDelivery.first?.MonitoredStopVisit.first?.MonitoredVehicleJourney
        
        return SimpleEntry(
            date: Date(),
            dataSets: [
                .init(
                    location: BusStop.whitestone.title,
                    busName: whitestoneMonitoredJourney?.publishedLineName.first ?? "",
                    arrivalTime: whitestoneMonitoredJourney?.monitoredCall.timeToArrival() ?? ""
                ),
                .init(
                    location: BusStop.flushing.title,
                    busName: flushingMinotoredJourney?.publishedLineName.first ?? "",
                    arrivalTime: flushingMinotoredJourney?.monitoredCall.timeToArrival() ?? ""
                )
            ]
        )
    }

    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        // Create an array with all the preconfigured widgets to show.
        [
            AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "Bus Arrival Times")
        ]
    }
}

struct DualBusStopWidgetView : View {
    var entry: DualBusStopProvider.Entry

    @ViewBuilder
    var body: some View {
        WidgetRectangularView(entry: entry)
    }
}

struct DualBusStopWidget: Widget {
    let kind: String = "BusTimeAppleWatchWidgets-Dual"
    
    let supportedFamilies: [WidgetFamily] = [
        .accessoryRectangular
    ]

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: DualBusStopProvider()
        ) { entry in
            DualBusStopWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies(supportedFamilies)
    }
}
