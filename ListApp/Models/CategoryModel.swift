import SwiftUI
import CoreData

struct CategoryModel {
    static func delete(_ category: Category) {
        guard let context = category.managedObjectContext else { return }

        let fetchRequest: NSFetchRequest<ListItem> = ListItem.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "category = %@", category)

        do {
            let listItems = try context.fetch(fetchRequest)
            for item in listItems {
                context.delete(item)
            }
            context.delete(category)
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func getCategoryByName(viewContext: NSManagedObjectContext, name: String) -> Category? {
        let request = Category.fetchRequest() as NSFetchRequest<Category>
        request.predicate = NSPredicate(format: "name = %@", name)
        do {
            let categories = try viewContext.fetch(request)
            if categories.count > 0 {
                return categories[0]
            }
        } catch {
            print("Error finding category by name")
        }
        return nil
    }
    
    static func add(viewContext: NSManagedObjectContext, name: String) throws -> Category {
        let category = Category(context: viewContext)
        category.name = name
        try viewContext.save()
        return category
    }
    
    static func categoriesToBeCreatedFromShareListArray(viewContext: NSManagedObjectContext, shareListArray: Set<ShareListItem>) -> [String] {
        var categoriesToBeCreated: [String] = []
        for item in shareListArray {
            if getCategoryByName(viewContext: viewContext, name: item.categoryName) == nil {
                categoriesToBeCreated.append(item.categoryName)
            }
        }
        return categoriesToBeCreated
    }
    
    static func createCategories(viewContext: NSManagedObjectContext, fromArray categories: [String]) throws {
        for category in categories {
            _ = try add(viewContext: viewContext, name: category)
        }
    }
    
}
