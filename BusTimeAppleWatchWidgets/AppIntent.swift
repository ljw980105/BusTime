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
}
