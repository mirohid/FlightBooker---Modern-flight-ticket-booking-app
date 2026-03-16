import SwiftUI

struct SeatView: View {
    let seat: Seat
    let action: () -> Void
    
    var backgroundColor: Color {
        switch seat.status {
        case .available:
            return AppColors.availableSeat
        case .selected:
            return AppColors.selectedSeat
        case .booked:
            return AppColors.bookedSeat
        }
    }
    
    var foregroundColor: Color {
        switch seat.status {
        case .available:
            return AppColors.textPrimary
        case .selected:
            return .white
        case .booked:
            return .white
        }
    }
    
    var isSelectable: Bool {
        return seat.status != .booked
    }
    
    var body: some View {
        Button(action: {
            if isSelectable {
                HapticManager.shared.selection()
                withAnimation(AnimationManager.tapScale) {
                    action()
                }
            }
        }) {
            ZStack {
                // Seat Shape
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
                    .frame(width: 45, height: 45)
                
                // Seat details (like armrest)
                VStack {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 30, height: 4)
                        .padding(.top, 4)
                    
                    Spacer()
                }
                
                Text(seat.name)
                    .typography(AppTypography.caption)
                    .foregroundColor(foregroundColor)
            }
            .scaleEffect(seat.status == .selected ? 1.1 : 1.0)
            .shadow(color: seat.status == .selected ? AppColors.primary.opacity(0.5) : Color.clear, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isSelectable)
    }
}

struct SeatView_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: AppSpacing.s) {
            SeatView(seat: Seat(row: 1, column: "A", status: .available, price: 1500)) {}
            SeatView(seat: Seat(row: 1, column: "B", status: .selected, price: 1500)) {}
            SeatView(seat: Seat(row: 1, column: "C", status: .booked, price: 1500)) {}
        }
        .padding()
    }
}
