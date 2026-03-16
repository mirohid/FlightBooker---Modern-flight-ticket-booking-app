import SwiftUI

struct TicketCardView: View {
    let ticket: Ticket
    var showQR: Bool = true // Default true for other screens, false for animation
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Section - Flight Details
            VStack(spacing: AppSpacing.m) {
                // Airline
                HStack {
                    Image(systemName: ticket.flight.logo)
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.primary)
                    Text(ticket.flight.airline)
                        .typography(AppTypography.headline)
                        .foregroundColor(AppColors.textPrimary)
                    Spacer()
                    Text("Economy")
                        .typography(AppTypography.caption)
                        .padding(.horizontal, AppSpacing.xxs)
                        .padding(.vertical, 4)
                        .background(AppColors.primary.opacity(0.1))
                        .foregroundColor(AppColors.primary)
                        .cornerRadius(4)
                }
                
                // Origin & Destination
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(ticket.flight.origin.code)
                            .typography(AppTypography.largeTitle)
                            .foregroundColor(AppColors.primary)
                        Text(ticket.flight.origin.city)
                            .typography(AppTypography.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Image(systemName: "airplane")
                            .font(.system(size: 20))
                            .foregroundColor(AppColors.gradientEnd)
                        Text(ticket.flight.duration)
                            .typography(AppTypography.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(ticket.flight.destination.code)
                            .typography(AppTypography.largeTitle)
                            .foregroundColor(AppColors.primary)
                        Text(ticket.flight.destination.city)
                            .typography(AppTypography.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                
                Divider()
                
                // Passenger Info
                HStack {
                    InfoColumn(title: "PASSENGER", value: ticket.passengerName.uppercased())
                    Spacer()
                    InfoColumn(title: "FLIGHT", value: ticket.flight.flightNumber)
                    Spacer()
                    InfoColumn(title: "DATE", value: formattedDate(ticket.date))
                }
            }
            .padding(AppSpacing.m)
            .background(Color.white)
            .cornerRadius(16, corners: [.topLeft, .topRight])
            
            // Perforated Line
            HStack(spacing: 0) {
                Circle()
                    .fill(Color(AppColors.background)) // Match app background
                    .frame(width: 24, height: 24)
                    .offset(x: -12)
                
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.3))
                
                Circle()
                    .fill(Color(AppColors.background))
                    .frame(width: 24, height: 24)
                    .offset(x: 12)
            }
            .frame(height: 1)
            .background(Color.white)
            .zIndex(1) // Ensure circles cut out of the ticket visually
            
            // Bottom Section - Boarding & QR
            VStack(spacing: AppSpacing.m) {
                HStack {
                    InfoColumn(title: "GATE", value: ticket.gate, isHighlight: true)
                    Spacer()
                    InfoColumn(title: "SEAT", value: formatSeats(ticket.seats), isHighlight: true)
                    Spacer()
                    InfoColumn(title: "BOARDING", value: formattedTime(ticket.boardingTime), isHighlight: true)
                }
                
                Divider()
                
                // Simulated QR Code
                VStack(spacing: 8) {
                    Image(systemName: "qrcode")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(ticket.qrCodeData)
                        .typography(AppTypography.caption)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .padding(AppSpacing.m)
            .background(Color.white)
            .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
        }
        .cardShadow()
        .padding(AppSpacing.s)
    }
    
    // Helpers
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date).uppercased()
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatSeats(_ seats: [Seat]) -> String {
        seats.map { $0.name }.joined(separator: ", ")
    }
}

// Custom View Helpers
struct InfoColumn: View {
    let title: String
    let value: String
    var isHighlight: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .typography(AppTypography.caption)
                .foregroundColor(AppColors.textSecondary)
            Text(value)
                .typography(isHighlight ? AppTypography.title : AppTypography.bodyMedium)
                .foregroundColor(isHighlight ? AppColors.primary : AppColors.textPrimary)
        }
    }
}

// Line shape for dashed line
struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

// Extension to round specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
