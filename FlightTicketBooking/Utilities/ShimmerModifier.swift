import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    var duration: Double = 1.5
    var bounce: Bool = false
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    Color.white
                        .mask(Rectangle().fill(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .clear, location: 0),
                                    .init(color: .white.opacity(0.8), location: 0.5),
                                    .init(color: .clear, location: 1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        ))
                        .offset(x: -geometry.size.width + (geometry.size.width * 2) * phase)
                }
            )
            .onAppear {
                withAnimation(Animation.linear(duration: duration).repeatForever(autoreverses: bounce)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmer(duration: Double = 1.5, bounce: Bool = false) -> some View {
        self.modifier(ShimmerModifier(duration: duration, bounce: bounce))
    }
}
