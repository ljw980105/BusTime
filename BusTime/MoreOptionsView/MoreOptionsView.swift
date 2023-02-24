//
//  MoreOptionsView.swift
//  BusTime
//
//  Created by Jing Wei Li on 2/18/23.
//

import SwiftUI

struct MoreOptionsView: View {
    @State private var presentAlert = false
    @State private var stopId: String = ""
    @State private var popVc: Bool = false
    
    
    var body: some View {
        NavigationView {
            List {
                Button("More Stops") {
                    presentAlert = true
                }
                .alert("Enter StopId", isPresented: $presentAlert, actions: {
                    TextField("StopId", text: $stopId)
                        .keyboardType(.numberPad)
                    Button("Cancel") {}
                        .foregroundColor(.red)
                    Button("Done") {
                        popVc = true
                    }
                }, message: {
                    Text("Enter the 6 digit stopId")
                })
                .popover(isPresented: $popVc) {
                    let id = Int(stopId) ?? 0
                    StopMonitoringView(viewModel: .init(stopId: id, title: stopId, showStopName: true))
                }
            }
            .navigationTitle("More")
        }
    }
}
