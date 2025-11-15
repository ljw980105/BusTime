//
//  LiveActivityWidgetBundle.swift
//  LiveActivityWidget
//
//  Created by Anderson Li on 11/14/25.
//

import WidgetKit
import SwiftUI

@main
struct LiveActivityWidgetBundle: WidgetBundle {
    var body: some Widget {
        LiveActivityWidget()
        LiveActivityWidgetLiveActivity()
    }
}
