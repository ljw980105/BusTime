//
//  SubwayStatusView.swift
//  BusTime
//
//  Created by Anderson Li on 12/1/24.
//

import SwiftUI

struct SubwayStatusView: View {
    @ObservedObject var viewModel: SubwayStatusViewModel
    
    init(viewModel: SubwayStatusViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(viewModel.subwayAlerts, id: \.id) { subwayAlert in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            if let activePeriod = viewModel.formattedActivePeriod(subwayAlert.alert.activePeriod) {
                                Text(activePeriod)
                                    .font(.caption)
                                    .bold()
                            }
                            
                            if let title = subwayAlert.alert.headerText.translation.first {
                                Text(title.text)
                                    .font(.caption)
                            }
                            if let title = subwayAlert.alert.descriptionText?.translation.first {
                                Text(title.text)
                                    .font(.caption2)
                            }
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background {
                        RoundedRectangle(cornerSize: .init(width: 8, height: 8))
                            .foregroundStyle(Color(UIColor.secondarySystemBackground))
                    }
                }
            }
            .padding(.horizontal, 16)
            .background(Color(UIColor.systemBackground))
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                Task {
                    try? await viewModel.refresh()
                }
            }
    //        .refreshable {
    //            await viewModel.refreshAsync()
    //        }
        }
    }
}

#Preview {
    SubwayStatusView(viewModel: .init(subwayRoutes: [.seven]))
}
