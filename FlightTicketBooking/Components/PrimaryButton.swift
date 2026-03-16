import SwiftUI

struct PrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    var isEnabled: Bool = true
    
    init(title: String, icon: String? = nil, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            HapticManager.shared.impact(style: .medium)
            action()
        }) {
            HStack(spacing: AppSpacing.xs) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .bold))
                }
                Text(title)
            }
        }
        .primaryStyle(isEnabled: isEnabled)
        .disabled(!isEnabled)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: AppSpacing.m) {
            PrimaryButton(title: "Search Flights") { }
            PrimaryButton(title: "Confirm Payment", icon: "checkmark.circle.fill") { }
            PrimaryButton(title: "Disabled Button", isEnabled: false) { }
        }
        .padding()
    }
}
