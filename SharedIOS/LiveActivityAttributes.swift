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
        public var emoji: String
        
        public init(emoji: String) {
            self.emoji = emoji
        }
    }

    // Fixed non-changing properties about your activity go here!
    public var name: String
    
    public init(name: String) {
        self.name = name
    }
}
