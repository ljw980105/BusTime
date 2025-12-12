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
                    ZStack {
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundStyle(Color.cyan.opacity(0.2))
                        Image(systemName: "xmark")
                            .resizable()
                            .foregroundStyle(Color.cyan)
                            .frame(width: 25, height: 25)
                    }
                    .onTapGesture {
                        Task {
//                            let content = ActivityContent(state: context.state, staleDate: .now)
//                            await activity?.end(content, dismissalPolicy: .immediate)
                        }
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack {
                        countDownText(for: context.state)
                            .lineLimit(1)
                            .foregroundStyle(Color.cyan)
                            .font(.largeTitle)
                            .frame(width: 100)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                    .frame(height: .infinity)
                }
                DynamicIslandExpandedRegion(.center) {
                    HStack(alignment: .bottom) {
                        Spacer()
                        VStack {
                            Spacer()
                            Text(context.attributes.name)
                            Text("Arrives in")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.cyan)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.trailing, 10)
                }
            } compactLeading: {
                Image(systemName: "bus.fill")
                    .resizable()
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(Color.cyan)
                    .frame(width: 18, height: 18)
            } compactTrailing: {
                // Special initializer for countdown timers
                countDownText(for: context.state)
                    .frame(maxWidth: .minimum(50, 50), alignment: .leading)
                    .foregroundStyle(.cyan)
            } minimal: {
                
            }
            //.widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.cyan)
        }
    }
    
    func countDownText(for state: LiveActivityAttributes.ContentState) -> some View {
        Text(
            timerInterval: Date.now...Date(
                timeInterval: state.countdown,
                since: .now
            )
        )
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
