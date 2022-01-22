//
//  SettingsBasketHistoryView.swift
//  ListApp
//
//  Created by rjs on 1/5/22.
//

import SwiftUI
import CoreData

// TODO Fix issue where the section headers don't get removed unless you navigate home and come back

struct SettingsBasketHistoryView: View {
    
    @FetchRequest private var listItems: FetchedResults<ListItem>
    private var viewContext: NSManagedObjectContext
    @State private var dateArray: [String]
    
    func createFormattedDateHeaderString(_ date: String) -> String {
        let dateArr = date.components(separatedBy: ".")
        
        return "\(dateArr[1])/\(dateArr[2])/\(dateArr[0])"
    }
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        
        let fetchRequest: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ListItem.name, ascending: true)]
        // TODO: Figure out this predicate
        //        fetchRequest.predicate = NSPredicate(format: "datesMovedToBasket.@count >0")
        fetchRequest.predicate = NSPredicate(value: true)
        self._listItems = FetchRequest(fetchRequest: fetchRequest)
        
        do {
            let tempListItems = try viewContext.fetch(fetchRequest)
            var dateSet: Set<String> = []
            for item in tempListItems {
                if let safeArr = item.datesMovedToBasket, !safeArr.isEmpty {
                    for date in safeArr {
                        dateSet.insert(date.dateCompareString())
                    }
                }
            }
            let tempArr = Array(dateSet).sorted(by: { $0.compare($1) == .orderedDescending })
            print(tempArr)
            self._dateArray = State(initialValue: tempArr)
            
        } catch let error as NSError {
            print(error.userInfo)
            fatalError("testing this")
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(dateArray, id: \.self) { date in
                    Section(header: Text(createFormattedDateHeaderString(date))) {
                        ForEach(listItems) { item in
                            if let basketDates = item.datesMovedToBasket,  basketDates.contains(where: {$0.dateCompareString() == date}), let itemName = item.name {
                                Text(itemName)
                            }
                        }
                    }
                }
            }
            SettingsBasketHistoryClearButton(dateArray: $dateArray)
        }
        .navigationTitle("Basket History")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct SettingsBasketHistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsBasketHistoryView()
//    }
//}
