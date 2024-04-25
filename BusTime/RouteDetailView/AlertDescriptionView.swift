//
//  AlertDescriptionView.swift
//  BusTime
//
//  Created by Jing Wei Li on 2/28/24.
//

import SwiftUI

struct AlertDescriptionView: View {
    let alerts: [RouteDetailViewModel.Situation]
    
    init(alerts: [RouteDetailViewModel.Situation]) {
        self.alerts = alerts
    }
    
    var body: some View {
        TabView {
            ForEach(alerts, id: \.id) { alert in
                VStack {
                    VStack(alignment: .leading) {
                        Text("Summary")
                            .titleStyle()
                        Text(alert.summary)
                            .bodyStyle()
                        Spacer()
                            .frame(height: 8)
                        Text("Description")
                            .titleStyle()
                        Text(alert.description)
                            .bodyStyle()
                        Spacer()
                            .frame(height: 8)
                        Text("Created: \(alert.created)")
                            .font(.caption2)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 25.0)
                            .foregroundColor(Color(UIColor.secondarySystemBackground))
                    )
                    Spacer()
                }
                .padding(16)
                
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .navigationTitle("Alerts (\(alerts.count))")
    }
}

fileprivate extension View {
    func titleStyle() -> some View {
        font(.caption)
        .fontWeight(.bold)
        .foregroundStyle(Color.pink)
    }
    
    func bodyStyle() -> some View {
        font(.caption)
        .foregroundStyle(Color.pink)
    }
}
