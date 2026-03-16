import Foundation
import Combine

class SeatSelectionViewModel: ObservableObject {
    @Published var flight: Flight
    @Published var seats: [Seat]
    @Published var baseAmount: Double
    
    init(flight: Flight, baseAmount: Double) {
        self.flight = flight
        self.seats = MockData.generateSeats()
        self.baseAmount = baseAmount
    }
    
    var selectedSeats: [Seat] {
        seats.filter { $0.status == .selected }
    }
    
    var totalPrice: Double {
        selectedSeats.reduce(0) { $0 + $1.price } + baseAmount
    }
    
    var formattedTotalPrice: String {
        return String(format: "₹%.0f", totalPrice)
    }
    
    var isReadyToBook: Bool {
        !selectedSeats.isEmpty
    }
}
