import SwiftUI

struct BoardingAnimationView: View {
    let flight: Flight
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 1.0
    @State private var showSeatSelection = false
    
    var body: some View {
        ZStack {
            Color(AppColors.background)
                .ignoresSafeArea()
            
            if !showSeatSelection {
                VStack {
                    Image(systemName: "airplane")
                        .font(.system(size: 150))
                        .foregroundColor(AppColors.primary)
                        .rotation3DEffect(.degrees(rotation), axis: (x: 1, y: 1, z: 0), perspective: 0.5)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .onAppear {
                            HapticManager.shared.impact(style: .heavy)
                            
                            withAnimation(.easeInOut(duration: AnimationManager.boardingDuration)) {
                                rotation = 360
                                scale = 5.0
                                opacity = 0.0
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + AnimationManager.boardingDuration - 0.2) {
                                showSeatSelection = true
                            }
                        }
                    
                    Text("Boarding \(flight.flightNumber)...")
                        .typography(AppTypography.headline)
                        .foregroundColor(AppColors.textSecondary)
                        .padding(.top, AppSpacing.xl)
                        .opacity(opacity)
                }
            } else {
                SeatSelectionView(flight: flight, baseAmount: flight.price)
                    .transition(.opacity)
            }
        }
        .navigationBarHidden(true)
    }
}

struct BoardingAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        BoardingAnimationView(flight: MockData.flights[0])
    }
}
