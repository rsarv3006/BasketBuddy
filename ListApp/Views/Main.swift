//
//  Main.swift
//  ListApp
//
//  Created by rjs on 12/29/21.
//

import SwiftUI

struct Main: View {
    @State private var showSettings = false;
    @State private var showAdd = false;
    
    var body: some View {
        NavigationView {
            
            VStack {
                NavigationLink(destination: Settings(), isActive: $showSettings) {
                    EmptyView()
                }
                ListComponent()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                showSettings.toggle()
                            } label: {
                                Image(systemName: "gearshape")
                            }
                        }
                        ToolbarItem(placement: .bottomBar) {
                            Button {
                                showAdd.toggle()
                            } label: {
                                ZStack {
                                    Circle()
                                        .trim(from: 0.1, to: 0.9)
                                        .rotation(.degrees(90))
                                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 3))
                                        .frame(width: 110, height: 110)
                                    
                                    Image(systemName: "plus")
                                        .font(.system(size: 50))
                                        .foregroundColor(.blue)
                                }
                                
                            }
                            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                        .onEnded({ value in
                                if value.translation.height < 0 {
                                    showAdd.toggle()
                                }

                            })
                            )
                        }

                    }
                    .sheet(isPresented: $showAdd) {
                        AddItems()
                    }
            }
        }
        
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
