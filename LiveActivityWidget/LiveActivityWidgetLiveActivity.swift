//
//  LiveActivityWidgetLiveActivity.swift
//  LiveActivityWidget
//
//  Created by Anderson Li on 11/14/25.
//

import ActivityKit
import WidgetKit
import SwiftUI
import SharedIOS

struct LiveActivityWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Testing")
            }
            .activityBackgroundTint(Color.black)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "bus.fill")
                        .resizable()
                        .symbolRenderingMode(.monochrome)
                        .foregroundStyle(Color.cyan)
                        .frame(width: 60, height: 60)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.attributes.name)
                        .font(.system(size: 10))
                        .foregroundStyle(Color.cyan)
                }
                DynamicIslandExpandedRegion(.bottom) {
                }
            } compactLeading: {
                Image(systemName: "bus.fill")
                    .resizable()
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(Color.cyan)
                    .frame(width: 18, height: 18)
            } compactTrailing: {
//                Text("\(context.state.emoji)")
                CountDownDialView(
                    totalTimeInterval: context.state.countdown,
                    size: 20
                )
            } minimal: {
//                Text(context.state.emoji)
            }
//            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.cyan)
        }
    }
}

extension LiveActivityAttributes {
    fileprivate static var preview: LiveActivityAttributes {
        LiveActivityAttributes(name: "World")
    }
}

#Preview("Notification", as: .content, using: LiveActivityAttributes.preview) {
   LiveActivityWidgetLiveActivity()
} contentStates: {
    LiveActivityAttributes.ContentState(countdown: 50)
}
