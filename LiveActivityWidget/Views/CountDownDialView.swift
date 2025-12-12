//
//  CountDownDialView.swift
//  LiveActivityWidgetExtension
//
//  Created by Anderson Li on 11/14/25.
//

import SwiftUI
import SharedIOS
import WidgetKit
import ActivityKit

struct CountDownDialView: View {
    let totalTimeInterval: TimeInterval
    let size: CGFloat
    // @State var timer: Timer?
    var remainingTimeInterval: TimeInterval
    let viewModel: CountdownViewModel
    
    init(totalTimeInterval: TimeInterval, size: CGFloat) {
        self.totalTimeInterval = totalTimeInterval
        self.size = size
        remainingTimeInterval = totalTimeInterval
        viewModel = CountdownViewModel(totalTimeInterval: totalTimeInterval)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke( // 1
                    Color.cyan.opacity(0.5),
                    lineWidth: 2
                )
                .frame(width: size, height: size)
            Circle()
                .trim(from: 0, to: viewModel.percentage/*remainingTimeInterval/totalTimeInterval*/)
                .stroke( // 1
                    Color.cyan,
                    lineWidth: 2
                )
                .frame(width: size, height: size)
        }
        .rotationEffect(.degrees(270))
        .onAppear {
            viewModel.startTimer()
        }
//        Text(
//            timerInterval: Date.now...Date(timeInterval: totalTimeInterval, since: .now)
//        )
//        .foregroundStyle(.cyan)
    }
}

class CountdownViewModel {
    let totalTimeInterval: TimeInterval
    var timer: Timer? = nil
    var remainingTimeInterval: TimeInterval
    
    init(totalTimeInterval: TimeInterval) {
        self.totalTimeInterval = totalTimeInterval
        self.remainingTimeInterval = totalTimeInterval
    }
    
    @objc func updateRemainingTimeInterval() {
        remainingTimeInterval = max(0, remainingTimeInterval - 1)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.remainingTimeInterval = max(0, self.remainingTimeInterval - 1)
            print("timer run \(self.remainingTimeInterval)")
        }
    }
    
    var percentage: Double {
        remainingTimeInterval / totalTimeInterval
    }
}

#Preview(
    "Countdown Dial",
    as: .dynamicIsland(.compact),
    using: LiveActivityAttributes(name: "")
) {
   LiveActivityWidgetLiveActivity()
} contentStates: {
    LiveActivityAttributes.ContentState(countdown: 2)
}
