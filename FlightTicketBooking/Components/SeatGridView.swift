import SwiftUI

struct SeatGridView: View {
    @Binding var seats: [Seat]
    
    // Group seats by row
    var groupedSeats: [Int: [Seat]] {
        Dictionary(grouping: seats, by: { $0.row })
    }
    
    var sortedRows: [Int] {
        groupedSeats.keys.sorted()
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.s) {
            ForEach(sortedRows, id: \.self) { row in
                if let rowSeats = groupedSeats[row] {
                    HStack(spacing: AppSpacing.s) {
                        // Left side (A, B)
                        HStack(spacing: AppSpacing.xxs) {
                            if let seatA = rowSeats.first(where: { $0.column == "A" }) {
                                SeatView(seat: seatA) { toggleSeat(seatA) }
                            } else {
                                EmptySeatSpace()
                            }
                            
                            if let seatB = rowSeats.first(where: { $0.column == "B" }) {
                                SeatView(seat: seatB) { toggleSeat(seatB) }
                            } else {
                                EmptySeatSpace()
                            }
                        }
                        
                        // Aisle with Row Number
                        Text("\(row)")
                            .typography(AppTypography.bodyMedium)
                            .foregroundColor(AppColors.textSecondary)
                            .frame(width: 30)
                        
                        // Right side (C, D)
                        HStack(spacing: AppSpacing.xxs) {
                            if let seatC = rowSeats.first(where: { $0.column == "C" }) {
                                SeatView(seat: seatC) { toggleSeat(seatC) }
                            } else {
                                EmptySeatSpace()
                            }
                            
                            if let seatD = rowSeats.first(where: { $0.column == "D" }) {
                                SeatView(seat: seatD) { toggleSeat(seatD) }
                            } else {
                                EmptySeatSpace()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func toggleSeat(_ seat: Seat) {
        if let index = seats.firstIndex(where: { $0.id == seat.id }) {
            var updatedSeat = seats[index]
            if updatedSeat.status == .available {
                updatedSeat.status = .selected
            } else if updatedSeat.status == .selected {
                updatedSeat.status = .available
            }
            seats[index] = updatedSeat
        }
    }
}

struct EmptySeatSpace: View {
    var body: some View {
        Color.clear
            .frame(width: 45, height: 45)
    }
}

struct SeatGridView_Previews: PreviewProvider {
    @State static var seats = MockData.generateSeats()
    
    static var previews: some View {
        ScrollView {
            SeatGridView(seats: $seats)
                .padding()
        }
    }
}
