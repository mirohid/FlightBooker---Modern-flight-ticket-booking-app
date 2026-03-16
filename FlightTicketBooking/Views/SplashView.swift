import SwiftUI

import SwiftUI

struct SplashView: View {
    @State private var isAnimatingGradient = false
    @State private var pathProgress: CGFloat = 0.0
    @State private var airplanePosition: CGFloat = 0.0
    @State private var showLogo = false
    @State private var planeScale: CGFloat = 1.0
    @State private var planeOffset: CGSize = .zero
    @State private var screenScale: CGFloat = 1.0
    @State private var screenOpacity: Double = 1.0
    
    // Cloud animations
    @State private var cloud1Offset: CGFloat = -200
    @State private var cloud2Offset: CGFloat = 300
    @State private var cloud3Offset: CGFloat = -150
    
    var onFinish: () -> Void
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [Color(hex: "FF5C00"), Color(hex: "FF8C00"), Color(hex: "FFA852")],
                startPoint: isAnimatingGradient ? .topLeading : .bottomTrailing,
                endPoint: isAnimatingGradient ? .bottomTrailing : .topTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: isAnimatingGradient)
            
            // Moving Clouds
            VStack {
                Image(systemName: "cloud.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.white.opacity(0.3))
                    .offset(x: cloud1Offset, y: 100)
                
                Spacer()
                
                Image(systemName: "cloud.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.white.opacity(0.2))
                    .offset(x: cloud2Offset, y: -50)
                
                Spacer()
                
                Image(systemName: "cloud.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white.opacity(0.3))
                    .offset(x: cloud3Offset, y: -150)
            }
            .ignoresSafeArea()
            
            // Flight Path & Airplane
            GeometryReader { geometry in
                ZStack {
                    // Glowing Flight Path
                    FlightPathShape()
                        .trim(from: 0.0, to: pathProgress)
                        .stroke(
                            LinearGradient(colors: [.white.opacity(0.2), .white], startPoint: .leading, endPoint: .trailing),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)
                        )
                        .shadow(color: .white.opacity(0.8), radius: 8, x: 0, y: 0)
                        
                    // Airplane following the path
                    Image(systemName: "airplane")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                        .modifier(FollowPathModifier(progress: pathProgress, path: FlightPathShape().path(in: geometry.frame(in: .local))))
                        // Optional trail left behind (simulated by path trimming itself)
                }
                // Zoom towards camera effect
                .scaleEffect(planeScale)
                .offset(planeOffset)
            }
            .frame(width: 200, height: 200)
            
            // App Logo
            if showLogo {
                VStack(spacing: AppSpacing.s) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.5), radius: 20, x: 0, y: 0)
                        
                    Text("FlightBooker")
                        .font(.system(size: 40, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .transition(.scale.combined(with: .opacity))
                .zIndex(2)
            }
        }
        .scaleEffect(screenScale)
        .opacity(screenOpacity)
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Gradient and clouds
        isAnimatingGradient = true
        withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
            cloud1Offset = UIScreen.main.bounds.width + 100
        }
        withAnimation(.linear(duration: 15).repeatForever(autoreverses: false)) {
            cloud2Offset = -UIScreen.main.bounds.width - 100
        }
        withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) {
            cloud3Offset = UIScreen.main.bounds.width + 150
        }
        
        // Flight Path Draw
        withAnimation(.easeInOut(duration: 1.5)) {
            pathProgress = 1.0
        }
        
        // Zoom Plane & Show Logo
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                planeScale = 3.0
                planeOffset = CGSize(width: 0, height: 100)
                HapticManager.shared.impact(style: .heavy)
            }
            
            withAnimation(.easeInOut(duration: 0.5).delay(0.2)) {
                showLogo = true
            }
        }
        
        // Final Screen Transition
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeIn(duration: 0.5)) {
                screenScale = 5.0
                screenOpacity = 0.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                onFinish()
            }
        }
    }
}

// Shape for the airplane to draw/follow
struct FlightPathShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Starts bottom left, swoops up, loops, and settles center
        path.move(to: CGPoint(x: -50, y: rect.maxY + 50))
        path.addCurve(
            to: CGPoint(x: rect.midX, y: rect.midY),
            control1: CGPoint(x: rect.minX, y: rect.midY),
            control2: CGPoint(x: rect.midX + 50, y: rect.minY - 50)
        )
        return path
    }
}

// Custom modifier to extract point and rotation from a Path based on progress
struct FollowPathModifier: GeometryEffect {
    var progress: CGFloat
    var path: Path
    
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let trimmedPath = path.trimmedPath(from: 0, to: progress)
        let rect = path.boundingRect
        
        let startPoint = CGPoint(x: -50, y: rect.maxY + 50)
        let currentPoint = trimmedPath.currentPoint ?? startPoint
        
        // Simple rotation calculation based on the slope (approximation for dramatic effect)
        let angle: CGFloat = progress < 0.5 ? -45 : 0
        
        let transform = CGAffineTransform(translationX: currentPoint.x - size.width/2, y: currentPoint.y - size.height/2)
            .rotated(by: angle * .pi / 180)
            
        return ProjectionTransform(transform)
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView { }
    }
}
