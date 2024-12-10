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
            entries.append(.init(date: .distantFuture, firstDataSet: .errorStub, secondDataSet: .errorStub))
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
        [AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "Bus Arrival Times")]
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
                location: ["WHITESTONE", "FLUSHING"].randomElement() ?? "",
                busName: "Q44-SBS",
                arrivalTime: ["20 seconds", "1 min"].randomElement() ?? ""
            )
        }
        
        static var errorStub: DataSet {
            .init(
                location: "Error",
                busName: "Error",
                arrivalTime: "Error"
            )
        }
    }

    let title: String
    let date: Date
    let firstDataSet: DataSet
    let secondDataSet: DataSet
    let dateString: String
    
    init(title: String = "Arrival Times", date: Date, firstDataSet: DataSet, secondDataSet: DataSet) {
        self.title = title
        self.date = date
        self.firstDataSet = firstDataSet
        self.secondDataSet = secondDataSet
        self.dateString = Self.dateFormatter.string(from: date)
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter
    }()
}

struct BustimeTimeToArrivalView : View {
    var entry: Provider.Entry

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

#Preview(as: .accessoryRectangular) {
    BusTimeAppleWatchWidgets()
} timeline: {
    SimpleEntry(date: Date(), firstDataSet: .stub, secondDataSet: .stub)
}
