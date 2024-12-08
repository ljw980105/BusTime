//
//  BusTimeAppleWatchWidgets.swift
//  BusTimeAppleWatchWidgets
//
//  Created by Anderson Li on 12/8/24.
//

import WidgetKit
import SwiftUI
import Shared

/// [Tutorial](https://swiftsenpai.com/development/getting-started-widgetkit/)
struct Provider: AppIntentTimelineProvider {
    /// Providing dummy data to the system to render a placeholder UI while waiting for the widget to get ready.
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: .now,
            firstDataSet: .init(location: "Whitestone", busName: "Q44", arrivalTime: "1 Min"),
            secondDataSet: .init(location: "Flushing", busName: "Q20B", arrivalTime: "1 Min")
        )
    }

    /// This function mainly provides the data required by the system to render the widget in the widget gallery. Following is the implementation:
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(
            date: .now,
            firstDataSet: .init(location: "Whitestone", busName: "Q44", arrivalTime: "1 Min"),
            secondDataSet: .init(location: "Flushing", busName: "Q20B", arrivalTime: "1 Min")
        )
    }
    
    /// This is the most important method in the timeline provider as it provides an array of timeline entries for the current time and, optionally, any future times to update a widget.
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        do {
            let entryResult = try await getEntryResult()
            entries.append(entryResult)
        } catch {
            return Timeline(entries: entries, policy: .atEnd)
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
            firstDataSet: .init(
                location: BusStop.whitestone.title,
                busName: whitestoneMonitoredJourney?.publishedLineName.first ?? "",
                arrivalTime: whitestoneMonitoredJourney?.monitoredCall.timeToArrival ?? ""
            ),
            secondDataSet: .init(
                location: BusStop.flushing.title,
                busName: flushingMinotoredJourney?.publishedLineName.first ?? "",
                arrivalTime: flushingMinotoredJourney?.monitoredCall.timeToArrival ?? ""
            )
        )
    }

    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        // Create an array with all the preconfigured widgets to show.
        [AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "Example Widget")]
    }
}

struct SimpleEntry: TimelineEntry {
    struct DataSet {
        let location: String
        let busName: String
        let arrivalTime: String
        
        init(location: String, busName: String, arrivalTime: String) {
            self.location = location
            self.busName = busName
            self.arrivalTime = arrivalTime
        }
        
        static var stub: DataSet {
            .init(
                location: "Whitestone",
                busName: "Q44-SBS",
                arrivalTime: ["20 seconds", "1 min"].randomElement() ?? ""
            )
        }
    }

    let title: String
    var date: Date
    let firstDataSet: DataSet
    let secondDataSet: DataSet
    
    init(title: String = "Arrival Times", date: Date, firstDataSet: DataSet, secondDataSet: DataSet) {
        self.title = title
        self.date = date
        self.firstDataSet = firstDataSet
        self.secondDataSet = secondDataSet
    }
}

struct BustimeTimeToArrivalView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.title)
                .font(.subheadline)
            HStack(alignment: .top) {
                Text(entry.firstDataSet.location)
                    .font(.caption)
                Text(entry.firstDataSet.busName)
                    .font(.caption)
                    .foregroundStyle(Color.blue)
                Text(entry.firstDataSet.arrivalTime)
                    .font(.caption)
            }
            HStack(alignment: .top) {
                Text(entry.secondDataSet.location)
                    .font(.caption)
                Text(entry.secondDataSet.busName)
                    .font(.caption)
                    .foregroundStyle(Color.blue)
                Text(entry.secondDataSet.arrivalTime)
                    .font(.caption)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

@main
struct BusTimeAppleWatchWidgets: Widget {
    let kind: String = "BusTimeAppleWatchWidgets"
    
    let supportedFamilies: [WidgetFamily] = [
        .accessoryRectangular
    ]

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            BustimeTimeToArrivalView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies(supportedFamilies)
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .accessoryRectangular) {
    BusTimeAppleWatchWidgets()
} timeline: {
    SimpleEntry(date: Date(), firstDataSet: .stub, secondDataSet: .stub)
}
