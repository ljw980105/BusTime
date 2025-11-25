//
//  LiveActivityAttributes.swift
//  SharedIOS
//
//  Created by Anderson Li on 11/14/25.
//

import Foundation
import ActivityKit

public struct LiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        public var countdown: TimeInterval
        
        public init(countdown: TimeInterval) {
            self.countdown = countdown
        }
    }

    // Fixed non-changing properties about your activity go here!
    public var name: String
    
    public init(name: String) {
        self.name = name
    }
}
