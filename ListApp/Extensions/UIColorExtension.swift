import SwiftUI

extension UIColor {
    static let tomato = UIColor(red: 1.00, green: 0.39, blue: 0.28, alpha: 1.00)
}

extension Color {
    static let tomato = Color(uiColor: .tomato)

    struct Theme {
        static let seaGreen = Color("SeaGreen")
        static let redMunsell = Color("RedMunsell")
        static let linen = Color("Linen")
        static let persimmon = Color("Persimmon")
    }
}
