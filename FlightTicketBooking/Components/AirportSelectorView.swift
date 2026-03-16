import SwiftUI

struct AirportSelectorView: View {
    @Binding var boardingAirport: String
    @Binding var destinationAirport: String
    
    @State private var swapRotation: Double = 0
    
    var body: some View {
        HStack(spacing: AppSpacing.s) {
            // Boarding
            VStack(alignment: .leading, spacing: AppSpacing.xxxs) {
                Text("From")
                    .typography(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
                
                TextField("Boarding", text: $boardingAirport)
                    .typography(AppTypography.title)
                    .foregroundColor(AppColors.textPrimary)
                    .textInputAutocapitalization(.characters)
            }
            .padding(.vertical, AppSpacing.xs)
            .padding(.horizontal, AppSpacing.s)
            .background(Color.white.opacity(0.6))
            .cornerRadius(12)
            
            // Swap Button
            Button(action: {
                HapticManager.shared.impact(style: .light)
                withAnimation(AnimationManager.springSmooth) {
                    swapRotation += 180
                    let temp = boardingAirport
                    boardingAirport = destinationAirport
                    destinationAirport = temp
                }
            }) {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(LinearGradient(colors: [AppColors.gradientStart, AppColors.gradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing))
                    )
                    .shadow(color: AppColors.primary.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .rotationEffect(.degrees(swapRotation))
            
            // Destination
            VStack(alignment: .leading, spacing: AppSpacing.xxxs) {
                Text("To")
                    .typography(AppTypography.caption)
                    .foregroundColor(AppColors.textSecondary)
                
                TextField("Destination", text: $destinationAirport)
                    .typography(AppTypography.title)
                    .foregroundColor(AppColors.textPrimary)
                    .textInputAutocapitalization(.characters)
            }
            .padding(.vertical, AppSpacing.xs)
            .padding(.horizontal, AppSpacing.s)
            .background(Color.white.opacity(0.6))
            .cornerRadius(12)
        }
    }
}

struct AirportSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue.opacity(0.1).ignoresSafeArea()
            AirportSelectorView(boardingAirport: .constant("DEL"), destinationAirport: .constant("DXB"))
                .padding()
        }
    }
}
