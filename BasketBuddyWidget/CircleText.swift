//
//  CircleText.swift
//  BasketBuddyWidgetExtension
//
//  Created by Robert J. Sarvis Jr on 11/12/23.
//

import SwiftUI

struct CircleText: View {
    var text: String
    
    func getTextSize() -> CGFloat {
        if text.count > 2 {
            return 12
        }
        return 18
    }
    
    var body: some View {
        ZStack {
            if text.count <= 2 {
                Circle()
                    .strokeBorder(.seaGreen, lineWidth: 1.5)
                    .frame(width: 28, height: 28)
            }
            
            Text(text)
                .foregroundColor(.seaGreen)
                .font(.system(size: getTextSize()))
        }
        .overlay(
            Text(text)
                .foregroundColor(.seaGreen)
                .font(.system(size: getTextSize()))
        )
    }
}

#Preview {
    CircleText(text: "10")
}
