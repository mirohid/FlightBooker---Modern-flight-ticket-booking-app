import SwiftUI

import SwiftUI

struct PaymentSuccessView: View {
    let ticket: Ticket
    
    // Animation States
    @State private var circleScale: CGFloat = 0.0
    @State private var checkmarkProgress: CGFloat = 0.0
    @State private var showTicketCard: Bool = false
    @State private var airplaneOffset: CGFloat = -UIScreen.main.bounds.width
    @State private var showText = false
    @State private var showButtons = false
    
    // Particles / Confetti
    @State private var confettiActive = false
    
    var body: some View {
        ZStack {
            // Animated Radial Gradient Background
            RadialGradient(
                colors: [Color(hex: "FFF8F0"), Color(hex: "FFE3C8")],
                center: .center,
                startRadius: confettiActive ? 100 : 10,
                endRadius: confettiActive ? 800 : 200
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 2), value: confettiActive)
            
            // Confetti Layer
            if confettiActive {
                ConfettiView()
            }
            
            VStack {
                Spacer()
                
                // Success Icon Area
                ZStack {
                    // Expanding Glow
                    Circle()
                        .fill(AppColors.success.opacity(0.15))
                        .frame(width: 200, height: 200)
                        .scaleEffect(circleScale)
                        .blur(radius: 20)
                    
                    // Main Circle
                    Circle()
                        .fill(AppColors.success)
                        .frame(width: 120, height: 120)
                        .scaleEffect(circleScale)
                        .shadow(color: AppColors.success.opacity(0.5), radius: 15, x: 0, y: 10)
                    
                    // Drawing Checkmark
                    CheckmarkShape()
                        .trim(from: 0, to: checkmarkProgress)
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                        .frame(width: 50, height: 50)
                }
                
                // Text
                if showText {
                    VStack(spacing: AppSpacing.s) {
                        Text("Booking Successful ✈️")
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .foregroundColor(AppColors.textPrimary)
                            .multilineTextAlignment(.center)
                        
                        Text("Your flight ticket has been confirmed.\nGet ready for your journey!")
                            .typography(AppTypography.bodyMedium)
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, AppSpacing.l)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.top, AppSpacing.m)
                }
                
                Spacer()
                
                // Slide up Ticket Card Profile
                if showTicketCard {
                    TicketCardView(ticket: ticket)
                        .scaleEffect(0.9)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .zIndex(1)
                }
                
                Spacer()
                
                // Buttons Layer
                if showButtons {
                    VStack(spacing: AppSpacing.s) {
                        NavigationLink(destination: TicketView(ticket: ticket)) {
                            HStack {
                                Text("View Ticket")
                                Image(systemName: "ticket.fill")
                            }
                            .typography(AppTypography.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, AppSpacing.s)
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .cornerRadius(16)
                            .shadow(color: AppColors.primary.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        
                        NavigationLink(destination: HomeView().navigationBarBackButtonHidden(true)) {
                            Text("Back to Home")
                                .typography(AppTypography.headline)
                                .foregroundColor(AppColors.primary)
                                .padding(.vertical, AppSpacing.s)
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding(.horizontal, AppSpacing.l)
                    .padding(.bottom, AppSpacing.m)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(2)
                }
            }
            
            // Flying Airplane
            Image(systemName: "airplane")
                .font(.system(size: 60))
                .foregroundColor(AppColors.primary.opacity(0.4))
                .offset(x: airplaneOffset, y: -200)
                .rotationEffect(.degrees(10))
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            startSuccessSequence()
        }
    }
    
    private func startSuccessSequence() {
        // 1. Circle expands
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            circleScale = 1.0
        }
        
        // 2. Checkmark draws
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.5)) {
                checkmarkProgress = 1.0
            }
            HapticManager.shared.notification(type: .success)
        }
        
        // 3. Confetti Burst & Text
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            confettiActive = true
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showText = true
            }
            HapticManager.shared.impact(style: .medium)
        }
        
        // 4. Airplane flies across
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 2.5)) {
                airplaneOffset = UIScreen.main.bounds.width + 100
            }
        }
        
        // 5. Ticket slides up
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
                showTicketCard = true
            }
            HapticManager.shared.impact(style: .light)
        }
        
        // 6. Buttons appear
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut(duration: 0.5)) {
                showButtons = true
            }
        }
    }
}

// Custom Shape for Checkmark
struct CheckmarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX - 5, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        return path
    }
}

// Simple Confetti system using basic shapes scattered randomly
struct ConfettiView: View {
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1.0
    
    var body: some View {
        ZStack {
            ForEach(0..<40, id: \.self) { _ in
                Circle()
                    .fill(
                        [Color.red, Color.blue, Color.green, Color.orange, Color.purple].randomElement()!
                    )
                    .frame(width: CGFloat.random(in: 4...10), height: CGFloat.random(in: 4...10))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: -200...UIScreen.main.bounds.height / 2)
                    )
                    .offset(y: offset * CGFloat.random(in: 0.5...1.5))
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 3.0)) {
                offset = 600
                opacity = 0
            }
        }
    }
}

struct PaymentSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PaymentSuccessView(ticket: Ticket(passengerName: "JOHN DOE", flight: MockData.flights[0], seats: MockData.generateSeats().prefix(1).map{$0}, date: Date(), gate: "A10", boardingTime: Date(), qrCodeData: "QR123"))
        }
    }
}


