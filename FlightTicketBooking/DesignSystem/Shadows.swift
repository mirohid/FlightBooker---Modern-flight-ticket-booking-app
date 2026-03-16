import SwiftUI

enum AppShadows {
    static let cardShadowColor = Color.black.opacity(0.1)
    static let cardShadowRadius: CGFloat = 10
    static let cardShadowX: CGFloat = 0
    static let cardShadowY: CGFloat = 5
    
    static let buttonShadowColor = AppColors.primary.opacity(0.3)
    static let buttonShadowRadius: CGFloat = 12
    static let buttonShadowX: CGFloat = 0
    static let buttonShadowY: CGFloat = 6
    
    static let floatingElementShadowColor = Color.black.opacity(0.15)
    static let floatingElementShadowRadius: CGFloat = 20
    static let floatingElementShadowX: CGFloat = 0
    static let floatingElementShadowY: CGFloat = 10
}

extension View {
    func cardShadow() -> some View {
        self.shadow(
            color: AppShadows.cardShadowColor,
            radius: AppShadows.cardShadowRadius,
            x: AppShadows.cardShadowX,
            y: AppShadows.cardShadowY
        )
    }
    
    func buttonShadow() -> some View {
        self.shadow(
            color: AppShadows.buttonShadowColor,
            radius: AppShadows.buttonShadowRadius,
            x: AppShadows.buttonShadowX,
            y: AppShadows.buttonShadowY
        )
    }
    
    func floatingShadow() -> some View {
        self.shadow(
            color: AppShadows.floatingElementShadowColor,
            radius: AppShadows.floatingElementShadowRadius,
            x: AppShadows.floatingElementShadowX,
            y: AppShadows.floatingElementShadowY
        )
    }
}
