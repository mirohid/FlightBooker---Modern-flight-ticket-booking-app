import SwiftUI

struct TicketView: View {
    @StateObject private var viewModel: TicketViewModel
    @State private var ticketOffset: CGFloat = UIScreen.main.bounds.height
    @State private var ticketRotation: Double = 15
    @State private var ticketGlow: CGFloat = 0
    @State private var showQR: Bool = false
    @State private var showFullscreenTicket: Bool = false
    @State private var confettiActive: Bool = false
    @State private var buttonScale: CGFloat = 1.0
    
    init(ticket: Ticket) {
        _viewModel = StateObject(wrappedValue: TicketViewModel(ticket: ticket))
    }
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(colors: [Color(hex: "FFF8F0"), Color.white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: AppSpacing.l) {
                // Header
                HStack {
                    Text("Boarding Pass")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    NavigationLink(destination: HomeView().navigationBarBackButtonHidden(true)) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                .padding(.horizontal, AppSpacing.m)
                .padding(.top, AppSpacing.m)
                
                // Animated Ticket Card
                ZStack {
                    // Glow effect
                    RoundedRectangle(cornerRadius: 24)
                        .fill(AppColors.primary.opacity(0.3))
                        .blur(radius: ticketGlow)
                        .scaleEffect(1.05)
                        .opacity(ticketGlow > 0 ? 1 : 0)
                    
                    TicketCardView(ticket: viewModel.ticket, showQR: showQR)
                }
                .padding(.horizontal, AppSpacing.m)
                .offset(y: ticketOffset)
                .rotation3DEffect(.degrees(ticketRotation), axis: (x: 1, y: 0, z: 0))
                .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
                
                Spacer()
                
                // Download Button
                Button(action: {
                    downloadTicket()
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                        Text(viewModel.isDownloading ? "Generating PDF..." : "Download Ticket")
                    }
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.vertical, AppSpacing.m)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientEnd], startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(16)
                    .shadow(color: AppColors.primary.opacity(0.4), radius: 10, x: 0, y: 5)
                }
                .scaleEffect(buttonScale)
                .disabled(viewModel.isDownloading || viewModel.downloadComplete)
                .padding(.horizontal, AppSpacing.l)
                .padding(.bottom, AppSpacing.m)
                .opacity(viewModel.downloadComplete ? 0.6 : 1.0)
            }
            
            // Fullscreen Celebration Overlay
            if showFullscreenTicket {
                ZStack {
                    Color.black.opacity(0.85)
                        .ignoresSafeArea()
                    
                    if confettiActive {
                        ConfettiView()
                    }
                    
                    VStack(spacing: AppSpacing.l) {
                        Text("Ticket Downloaded! 🎉")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: AppColors.primary.opacity(0.5), radius: 10, x: 0, y: 0)
                        
                        TicketCardView(ticket: viewModel.ticket, showQR: true)
                            .padding(.horizontal, 20)
                            .scaleEffect(1.05)
                            .shadow(color: AppColors.primary.opacity(0.3), radius: 30, x: 0, y: 15)
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                showFullscreenTicket = false
                                confettiActive = false
                            }
                        }) {
                            Text("Close")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.black)
                                .padding(.vertical, AppSpacing.m)
                                .padding(.horizontal, AppSpacing.xl)
                                .background(Color.white)
                                .cornerRadius(30)
                                .shadow(color: .white.opacity(0.4), radius: 10, x: 0, y: 5)
                        }
                        .padding(.top, AppSpacing.m)
                    }
                }
                .transition(.scale.combined(with: .opacity))
                .zIndex(20)
            }
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            startEntryAnimation()
        }
    }
    
    private func startEntryAnimation() {
        // 1. Ticket flies up & rotates into place
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
            ticketOffset = 0
            ticketRotation = 0
        }
        
        // 2. Add subtle glow
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            ticketGlow = 15
        }
        
        // 3. Fade in QR code later
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.easeIn(duration: 0.8)) {
                showQR = true
            }
        }
    }
    
    private func downloadTicket() {
        // Ripple & Scale effect
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            buttonScale = 0.95
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                buttonScale = 1.0
            }
        }
        
        HapticManager.shared.impact(style: .medium)
        viewModel.downloadTicket()
        
        // Listen for completion to show toast
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Simulating the PDF generation time
            if viewModel.downloadComplete {
                HapticManager.shared.notification(type: .success)
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    showFullscreenTicket = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    confettiActive = true
                }
            }
        }
    }
}
