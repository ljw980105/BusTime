//
//  AppIntent.swift
//  BusTimeAppleWatchWidgets
//
//  Created by Anderson Li on 12/8/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an example widget." }
    
    @Parameter(title: "Bus Stop")
    var predeterminedBusStopId: Int
    
    init(predeterminedBusStopId: Int) {
        self.predeterminedBusStopId = predeterminedBusStopId
    }
    
    init() {
        self.predeterminedBusStopId = 0
    }
    
}
