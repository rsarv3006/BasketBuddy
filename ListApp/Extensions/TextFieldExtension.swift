import SwiftUI

public struct TextFieldDefaultBackgroundSeagreenBorder: TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color.Theme.seaGreen, lineWidth: 2))
    }
}
