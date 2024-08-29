import SwiftUI
import CoreData
import BackgroundTasks
import ActivityKit

class BackgroundUpdater: ObservableObject {
    static let shared = BackgroundUpdater()
    
    private init() {
        registerBackgroundTasks()
    }
    
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "rjs.app.dev.basketbuddy.refreshLiveActivity", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        
        let context = PersistenceController.shared.container.viewContext
        checkForUpdatesAndRefreshLiveActivity(context: context)
        
        task.setTaskCompleted(success: true)
        scheduleAppRefresh()
    }
    
    func checkForUpdatesAndRefreshLiveActivity(context: NSManagedObjectContext) {
        let sharedDefaults = UserDefaults(suiteName: AppGroup.basketBuddy.rawValue)
        if sharedDefaults?.bool(forKey: "CoreDataChangedByWidget") == true {
            updateLiveActivity(context: context)
            sharedDefaults?.set(false, forKey: "CoreDataChangedByWidget")
            sharedDefaults?.synchronize()
        }
    }
    
    func updateLiveActivity(context: NSManagedObjectContext) {
        guard let activity = Activity<BasketBuddyWidgetAttributes>.activities.first else { return }
        
        do {
            let items = try ListItem.getSimplifiedListItemsForWidget(PersistenceController.shared.container.viewContext)
            
            let nextItem: SimplifiedListItem
            if let item = items.first {
                nextItem = item
            } else {
                nextItem = SimplifiedListItem(count: "", name: "No Items Left!", unitAbbrv: nil, categoryName: nil)
            }
            
            Task {
                let contentState = BasketBuddyWidgetAttributes.ContentState(itemCount: items.count, nextItem: nextItem)
                
                await activity.update(ActivityContent<BasketBuddyWidgetAttributes.ContentState>(state: contentState, staleDate: Date.now + 15))
            }
        } catch {
            print("Failed to fetch latest entity: \(error)")
        }
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "rjs.app.dev.basketbuddy.refreshLiveActivity")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 minutes
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
}
