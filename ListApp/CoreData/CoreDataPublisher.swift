import CoreData
import Combine

class CoreDataPublisher: NSObject, ObservableObject {
    static let shared = CoreDataPublisher()
    
    @Published private(set) var dataDidChange = false
    private var cancellables = Set<AnyCancellable>()
    
    private override init() {
        super.init()
        setupNotificationObserving()
    }
    
    private func setupNotificationObserving() {
        NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
            .sink { [weak self] _ in
                self?.dataDidChange.toggle()
            }
            .store(in: &cancellables)
    }
    
    func triggerUpdateManually() {
        self.dataDidChange.toggle()
    }
}
