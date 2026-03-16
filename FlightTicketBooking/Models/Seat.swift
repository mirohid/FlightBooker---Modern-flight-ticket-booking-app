import Foundation

enum SeatStatus {
    case available
    case selected
    case booked
}

struct Seat: Identifiable, Hashable {
    let id = UUID()
    let row: Int
    let column: String // "A", "B", "C", etc.
    var status: SeatStatus
    let price: Double
    
    var name: String {
        return "\(row)\(column)"
    }
}
