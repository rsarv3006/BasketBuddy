//
//  BottomCenterButton.swift
//  ListApp
//
//  Created by rjs on 1/5/22.
//

import SwiftUI

struct BottomCenterButton: View {
    var centerImageName: String
    var onPressed: () -> Void
    
    var body: some View {
        Button {
            self.onPressed()
        } label: {
            ZStack {
                Circle()
                    .fill(Color.theme.linen)
                    .frame(width: 110, height: 110)
                Circle()
                    .trim(from: 0.1, to: 0.9)
                    .rotation(.degrees(90))
                    .stroke(Color.theme.seaGreen, style: StrokeStyle(lineWidth: 3))
                    .frame(width: 110, height: 110)
                Image(systemName: centerImageName)
                    .font(.system(size: 45))
                    .foregroundColor(Color.theme.seaGreen)
                
            }
        }
    }
}
