//
//  SingleBusStopWidget.swift
//  BusTime
//
//  Created by Anderson Li on 12/10/24.
//
import WidgetKit
import SwiftUI
import Shared

/// [Tutorial](https://swiftsenpai.com/development/getting-started-widgetkit/)
struct SingleBusStopProvider: AppIntentTimelineProvider {
    /// Providing dummy data to the system to render a placeholder UI while waiting for the widget to get ready.
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now, dataSets: [.shortStub])
    }

    /// This function mainly provides the data required by the system to render the widget in the widget gallery. Following is the implementation:
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: .now, dataSets: [.shortStub])
    }
    
    /// This is the most important method in the timeline provider as it provides an array of timeline entries for the current time and, optionally, any future times to update a widget.
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        do {
            let entryResult: SimpleEntry
            let busStop: BusStop
            switch configuration.predeterminedBusStopId {
            case BusStop.whitestone.stopId:
                busStop = .whitestone
            case BusStop.flushing.stopId:
                busStop = .flushing
            default:
                busStop = .custom(stopId: configuration.predeterminedBusStopId, title: nil)
            }
            entryResult = try await getEntryMinimal(stop: busStop)
            entries.append(entryResult)
        } catch {
            entries.append(.init(date: .distantFuture, dataSets: [.shortStub]))
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
    
    func getEntryMinimal(stop: BusStop) async throws -> SimpleEntry {
        let result = try await BustimeAPI.getBusTimeAsync(stopId: stop.stopId, maximumStopVisits: 1)
        let monitoredJourney = result.StopMonitoringDelivery.first?.MonitoredStopVisit.first?.MonitoredVehicleJourney
        return SimpleEntry(
            date: Date(),
            dataSets: [
                .init(
                    location: stop.shortTitle,
                    busName: monitoredJourney?.publishedLineName.first?.shortBusName ?? "",
                    arrivalTime: monitoredJourney?.monitoredCall.timeToArrival(isMinimal: true) ?? ""
                )
            ]
        )
    }

    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        // Create an array with all the preconfigured widgets to show.
        [
            AppIntentRecommendation(
                intent: ConfigurationAppIntent(predeterminedBusStopId: BusStop.whitestone.stopId),
                description: "Bus Arrival Time - Whitestone"
            ),
            AppIntentRecommendation(
                intent: ConfigurationAppIntent(predeterminedBusStopId: BusStop.flushing.stopId),
                description: "Bus Arrival Time - Flushing"
            )
        ]
    }
}

struct SingleBusStopWidgetView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    @Environment(\.widgetRenderingMode) var renderingMode: WidgetRenderingMode
    var entry: SingleBusStopProvider.Entry

    @ViewBuilder
    var body: some View {
        switch family {
        case .accessoryCircular:
            WidgetCircularView(entry: entry)
        case .accessoryCorner:
            WidgetCornerView(entry: entry)
        default:
            EmptyView()
        }
    }
}

struct SingleBusStopWidget: Widget {
    let kind: String = "BusTimeAppleWatchWidgets-Single"
    
    let supportedFamilies: [WidgetFamily] = [
        .accessoryCircular,
        .accessoryCorner
    ]

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: SingleBusStopProvider()
        ) { entry in
            SingleBusStopWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies(supportedFamilies)
    }
}

fileprivate extension String {
    var shortBusName: String {
        split(separator: "-").first?.uppercased() ?? self
    }
}

