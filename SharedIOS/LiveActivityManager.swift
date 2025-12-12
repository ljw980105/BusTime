//
//  LiveActivityManager.swift
//  SharedIOS
//
//  Created by Anderson Li on 12/11/25.
//

import Foundation
import ActivityKit
import Combine

public class LiveActivityManager {
    public static var shared: LiveActivityManager = .init()
    
    public var changeUUID = UUID() {
        didSet {
            onChangePublisher.send(changeUUID)
        }
    }
    public var onChangePublisher: PassthroughSubject<UUID, Never> = .init()
    
    private var currentLiveActivity: Activity<LiveActivityAttributes>? {
        didSet {
            changeUUID = UUID()
        }
    }
    
    public func startLiveActivity(activity: Activity<LiveActivityAttributes>?) {
        currentLiveActivity = activity
    }
    
    public func endLiveActivity() async {
        await currentLiveActivity?.end(nil, dismissalPolicy: .immediate)
        currentLiveActivity = nil
    }
    
    public var hasLiveActivity: Bool {
        currentLiveActivity != nil
    }
}
