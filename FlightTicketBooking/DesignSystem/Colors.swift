import SwiftUI

enum AppColors {
    // Primary Brand Colors
    static let primary = Color(hex: "FF7A00")
    static let secondary = Color(hex: "FFA852") // Lighter orange
    static let gradientStart = Color(hex: "FF8C00")
    static let gradientEnd = Color(hex: "FF5C00")

    // Backgrounds
    static let background = Color("BackgroundColor") // Need asset or standard
    static let cardBackground = Color.white.opacity(0.8)

    // Text Colors
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary

    // Status Colors
    static let success = Color.green
    static let error = Color.red
    static let availableSeat = Color.gray.opacity(0.3)
    static let bookedSeat = Color.gray.opacity(0.8)
    static let selectedSeat = primary
}

// Extension to initialize Color with Hex string
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
