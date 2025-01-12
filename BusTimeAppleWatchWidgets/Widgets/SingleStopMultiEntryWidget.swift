//
//  SingleStopMultiEntryWidget.swift
//  BusTime
//
//  Created by Anderson Li on 1/10/25.
//

import SwiftUI
import WidgetKit
import Shared

struct SingleStopMultiEntryProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now, dataSets: [.shortStub, .shortStub, .shortStub])
    }

    /// This function mainly provides the data required by the system to render the widget in the widget gallery. Following is the implementation:
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        //SimpleEntry(date: .now, dataSets: [.shortStub])
        SimpleEntry(date: .now, dataSets: [.shortStub, .shortStub, .shortStub])
    }
    
    /// This is the most important method in the timeline provider as it provides an array of timeline entries for the current time and, optionally, any future times to update a widget.
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        do {
            let result = try await getEntries(at: BusStop(stopId: configuration.predeterminedBusStopId))
            entries.append(result)
        } catch {
            entries.append(.init(date: .distantFuture, dataSets: [.errorStub]))
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
    
    func getEntries(at stop: BusStop) async throws -> SimpleEntry {
        let result = try await BustimeAPI.getBusTimeAsync(stopId: stop.stopId, maximumStopVisits: 8)
        let monitoredStopVisits = result.StopMonitoringDelivery.first?.MonitoredStopVisit ?? []
        let entriesByLineRef = monitoredStopVisits.reduce(into: [LineRef: [Siri.MonitoredStopVisit]]()) { result, next in
            guard let lineRef = next.MonitoredVehicleJourney.knownLineRef else { return }
            result[lineRef, default: []].append(next)
        }
        let sortedByLineRef = entriesByLineRef.sorted { $0.key.priority > $1.key.priority }
        let dataSets: [SimpleEntry.DataSet] = sortedByLineRef.first?.value.map { monitoredJourney in
            let journey = monitoredJourney.MonitoredVehicleJourney
            return SimpleEntry.DataSet(
                busStop: stop,
                busName: journey.publishedLineName.first ?? "",
                arrivalTime: journey.monitoredCall.timeToArrival(isMinimal: true)
            )
        } ?? []
        
        return SimpleEntry(
            date: Date(),
            dataSets: Array(dataSets.prefix(4))
        )
    }
    
    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        [
            AppIntentRecommendation(
                intent: ConfigurationAppIntent(predeterminedBusStopId: BusStop.whitestone.stopId),
                description: "Multi Entry - Whitestone"
            ),
            AppIntentRecommendation(
                intent: ConfigurationAppIntent(predeterminedBusStopId: BusStop.flushing.stopId),
                description: "Multi Entry - Flushing"
            )
        ]
    }
    
}

struct SingleStopMultiEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    @Environment(\.widgetRenderingMode) var renderingMode: WidgetRenderingMode
    var entry: SingleStopMultiEntryProvider.Entry

    @ViewBuilder
    var body: some View {
        switch family {
        case .accessoryRectangular:
            MultiEntryRectangularView(entry: entry)
                .widgetURL(widgetURL)
        default:
            EmptyView()
        }
    }
    
    private var widgetURL: URL? {
        let busStopId = entry.dataSets.first?.busStop.stopId ?? 0
        return URL(string: "bustime://single/\(busStopId)")
    }
}

struct SingleStopMultiEntryWidget: Widget {
    let kind: String = "BusTimeAppleWatchWidgets-SingleStopMultiEntry"
    
    let supportedFamilies: [WidgetFamily] = [
        .accessoryRectangular
    ]

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: SingleStopMultiEntryProvider()
        ) { entry in
            SingleStopMultiEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies(supportedFamilies)
    }
}


