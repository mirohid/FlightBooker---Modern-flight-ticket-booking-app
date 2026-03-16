import SwiftUI

struct FlightCardView: View {
    let flight: Flight
    
    var body: some View {
        VStack(spacing: AppSpacing.s) {
            // Airline Info
            HStack {
                Image(systemName: flight.logo)
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.primary)
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: AppColors.primary.opacity(0.2), radius: 5, x: 0, y: 3)
                
                Text(flight.airline)
                    .typography(AppTypography.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Text(flight.formattedPrice)
                    .typography(AppTypography.headline)
                    .foregroundColor(AppColors.primary)
            }
            
            Divider()
                .padding(.vertical, AppSpacing.xxs)
            
            // Flight Timeline
            HStack(alignment: .center) {
                // Origin
                VStack(alignment: .leading, spacing: AppSpacing.xxxs) {
                    Text(flight.formattedDeparture)
                        .typography(AppTypography.title)
                        .foregroundColor(AppColors.textPrimary)
                    Text(flight.origin.code)
                        .typography(AppTypography.bodyMedium)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                // Duration & Line
                VStack(spacing: 4) {
                    Text(flight.duration)
                        .typography(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                    
                    HStack(spacing: 0) {
                        Circle()
                            .stroke(AppColors.primary, lineWidth: 2)
                            .frame(width: 6, height: 6)
                        
                        Rectangle()
                            .fill(LinearGradient(colors: [AppColors.primary.opacity(0.5), AppColors.gradientEnd], startPoint: .leading, endPoint: .trailing))
                            .frame(height: 2)
                            .frame(maxWidth: .infinity)
                        
                        Image(systemName: "airplane")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.gradientEnd)
                    }
                    
                    Text("Non-stop")
                        .typography(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
                .padding(.horizontal, AppSpacing.s)
                
                Spacer()
                
                // Destination
                VStack(alignment: .trailing, spacing: AppSpacing.xxxs) {
                    Text(flight.formattedArrival)
                        .typography(AppTypography.title)
                        .foregroundColor(AppColors.textPrimary)
                    Text(flight.destination.code)
                        .typography(AppTypography.bodyMedium)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .padding(AppSpacing.m)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .background(Color.white.opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.white.opacity(0.5), lineWidth: 1)
        )
        .cardShadow()
    }
}

struct FlightCardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue.opacity(0.1).ignoresSafeArea()
            FlightCardView(flight: MockData.flights[0])
                .padding()
        }
    }
}
