//
//  Tag.swift
//  BusTime
//
//  Created by Anderson Li on 5/17/24.
//

import Foundation
import SwiftUI

struct Tag: View {
    let text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.system(size: 10))
            .bold()
            .foregroundStyle(Color.white)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(
                RoundedRectangle(cornerSize: CGSize(width: 4, height: 4))
                    .foregroundStyle(Color.orange)
            )
        .frame(height: 15)
    }
}

#Preview {
    Tag(text: "BUSY")
}
