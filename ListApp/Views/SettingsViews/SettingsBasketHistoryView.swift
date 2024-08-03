import SwiftUI
import CoreData

// TODO Fix issue where the section headers don't get removed unless you navigate home and come back

struct SettingsBasketHistoryView: View {
    @EnvironmentObject var store: Store
    @State private var dateArray: [String]
    
    @FetchRequest private var listItems: FetchedResults<ListItem>
    private var viewContext: NSManagedObjectContext

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
            self._dateArray = State(initialValue: tempArr)

        } catch let error as NSError {
            print(error.localizedDescription)
            fatalError("testing this")
        }
    }

    var body: some View {
        VStack {
            ZStack {
                List {
                    ForEach(dateArray, id: \.self) { date in
                        Section(header: Text(createFormattedDateHeaderString(date)).foregroundColor(Color.Theme.seaGreen)) {
                            ForEach(listItems) { item in
                                if let basketDates = item.datesMovedToBasket, basketDates.contains(where: {$0.dateCompareString() == date}), let itemName = item.name {
                                    Text(itemName)
                                        .foregroundColor(Color.Theme.linen)
                                        .listRowBackground(Color.Theme.seaGreen)
                                }
                            }
                        }
                    }
                }
                .background(Color.Theme.linen)
                .scrollContentBackground(.hidden)

                if dateArray.isEmpty {
                    Spacer()
                        .background(Color.Theme.linen)
                }
            }
            SettingsBasketHistoryClearButton(dateArray: $dateArray)
                .padding([.bottom])

        }
        .background(Color.Theme.linen)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Basket History")
                        .font(.headline)
                        .foregroundColor(Color.Theme.seaGreen)
                }
            }
        }

    }
}
