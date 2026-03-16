import Foundation

struct Ticket: Identifiable, Hashable {
    let id = UUID()
    let passengerName: String
    let flight: Flight
    let seats: [Seat]
    let date: Date // Booking date
    let gate: String // E.g., "G12"
    let boardingTime: Date
    let qrCodeData: String
}
