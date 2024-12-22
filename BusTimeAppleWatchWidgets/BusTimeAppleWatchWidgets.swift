//
//  BusTimeAppleWatchWidgets.swift
//  BusTimeAppleWatchWidgets
//
//  Created by Anderson Li on 12/8/24.
//

import WidgetKit
import SwiftUI
import Shared

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
        
        static var shortStub: DataSet {
            .init(
                location: "FLU",
                busName: "Q44",
                arrivalTime: "1m"
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
    let dataSets: [DataSet]
    let dateString: String
    
    var firstDataSet: DataSet {
        dataSets.first ?? .errorStub
    }
    var secondDataSet: DataSet {
        dataSets.last ?? .errorStub
    }
    
    init(title: String = "Arrival Times", date: Date, dataSets: [DataSet]) {
        self.title = title
        self.date = date
        self.dataSets = dataSets
        self.dateString = Self.dateFormatter.string(from: date)
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter
    }()
}

@main
struct BusTimeAppleWatchWidgets: WidgetBundle {
    var body: some Widget {
        SingleBusStopWidget()
        DualBusStopWidget()
    }
}
