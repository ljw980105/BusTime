//
//  LiveActivityLockScreenView.swift
//  LiveActivityWidgetExtension
//
//  Created by Anderson Li on 12/11/25.
//

import Foundation
import SwiftUI
import SharedIOS
import WidgetKit

struct LiveActivityLockScreenView: View {
    let context: ActivityViewContext<LiveActivityAttributes>
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(Color.cyan.opacity(0.2))
                Image(systemName: "bus.fill")
                    .resizable()
                    .foregroundStyle(Color.cyan)
                    .frame(width: 30, height: 30)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(alignment: .center) {
                VStack(alignment: .trailing) {
                    Text(context.attributes.name)
                    Text("Arrives in")
                }
                .font(.subheadline)
                .foregroundStyle(.cyan)
                
                countDownText(for: context.state)
                    .lineLimit(1)
                    .foregroundStyle(Color.cyan)
                    .font(.largeTitle)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(10)
    }
    
    func countDownText(for state: LiveActivityAttributes.ContentState) -> some View {
        // Special initializer for countdown timers
        Text(
            timerInterval: Date.now...Date(
                timeInterval: state.countdown,
                since: .now
            )
        )
    }
    
}

#Preview(
    "Lockscreen",
    as: .content,
    using: LiveActivityAttributes(name: "Q44-SBS")
) {
   LiveActivityWidgetLiveActivity()
} contentStates: {
    LiveActivityAttributes.ContentState(countdown: 600)
}

