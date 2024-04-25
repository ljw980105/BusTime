//
//  KeyValueCell.swift
//  Shared
//
//  Created by Jing Wei Li on 12/24/22.
//

import SwiftUI

public struct KeyValueCell: View {
    let key: String
    let value: String
    
    public init(_ key: String, _ value: String) {
        self.key = key
        self.value = value
    }
    
    public var body: some View {
        HStack {
            Text(key)
                .font(.caption)
                .fontWeight(.bold)
            Spacer()
            Text(value)
                .font(.caption)
                .multilineTextAlignment(.trailing)
        }
        .padding(5)
        .cornerRadius(12)
    }
}


struct KeyValueCell_Previews: PreviewProvider {
    static var previews: some View {
        KeyValueCell("Key", "Value")
    }
}
