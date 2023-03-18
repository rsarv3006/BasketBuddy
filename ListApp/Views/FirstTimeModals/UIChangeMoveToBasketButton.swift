//
//  UIChangeMoveToBasketButton.swift
//  BasketBuddy
//
//  Created by Robert J. Sarvis Jr on 3/18/23.
//

import SwiftUI

struct UIChangeMoveToBasketButton: View {
    let dismissCallback: () -> Void
    
    var body: some View {
        VStack{
            Text("Interface Update Alert!")
                .font(.largeTitle)
                .foregroundColor(.Theme.seaGreen)
                .padding(.bottom)
            Text("Based on feedback we have moved the 'Move To Basket' button to be part of the item row.")
                .foregroundColor(.Theme.seaGreen)
                .padding(.bottom)
            Image("UIChangeMoveToBasket")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Spacer()
            Button("Good to know", action: dismissCallback)
                .buttonStyle(.bordered)
                .padding(.bottom)
        }
        .background(Color.Theme.linen)
    }
    
}


struct UIChangeMoveToBasketButton_Previews: PreviewProvider {
    static var previews: some View {
        UIChangeMoveToBasketButton {}
    }
}
