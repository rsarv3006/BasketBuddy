import Foundation

public enum AppGroup: String {
  case basketBuddy = "group.rjs.app.dev.basketbuddy"

  public var containerURL: URL {
    switch self {
    case .basketBuddy:
      return FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: self.rawValue)!
    }
  }
}
