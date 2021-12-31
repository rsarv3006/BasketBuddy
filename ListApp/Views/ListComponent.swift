//
//  ListComponent.swift
//  ListApp
//
//  Created by rjs on 12/29/21.
//

import SwiftUI

struct ListComponent: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)], animation: .default)
    private var categories: FetchedResults<Category>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Unit.name, ascending: true)], animation: .default)
    private var units: FetchedResults<Unit>
    
    var body: some View {
        List {
            ForEach(categories) { cat in
                Text(cat.name ?? "")
            }
            ForEach(units) {unit in
                Text("\(unit.name ?? "") - \(unit.abbreviation ?? "")")
            }
        }
            .frame(maxWidth: .infinity)
            .background(Color.tomato)

        
        
    }
}

struct ListComponent_Previews: PreviewProvider {
    static var previews: some View {
        ListComponent()
    }
}
