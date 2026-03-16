import Foundation

enum MockData {
    // Airports
    static let del = Airport(code: "DEL", city: "New Delhi", name: "Indira Gandhi Int.", country: "India")
    static let dxb = Airport(code: "DXB", city: "Dubai", name: "Dubai Int.", country: "UAE")
    static let lhr = Airport(code: "LHR", city: "London", name: "Heathrow", country: "UK")
    static let jfk = Airport(code: "JFK", city: "New York", name: "John F. Kennedy", country: "USA")
    static let cdg = Airport(code: "CDG", city: "Paris", name: "Charles de Gaulle", country: "France")
    static let sin = Airport(code: "SIN", city: "Singapore", name: "Changi", country: "Singapore")
    
    static let airports = [del, dxb, lhr, jfk, cdg, sin]
    
    // Helper to generate Dates
    static func date(from dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: dateString) ?? Date()
    }
    
    // Generate Sample Flights
    static let flights: [Flight] = [
        Flight(airline: "Emirates", logo: "airplane", origin: del, destination: dxb,
               departureTime: date(from: "2026-05-15 10:30"),
               arrivalTime: date(from: "2026-05-15 13:15"),
               flightNumber: "EK 511", price: 18500),
        
        Flight(airline: "Air India", logo: "airplane.circle.fill", origin: del, destination: lhr,
               departureTime: date(from: "2026-05-15 14:00"),
               arrivalTime: date(from: "2026-05-15 19:30"),
               flightNumber: "AI 161", price: 45000),
               
        Flight(airline: "British Airways", logo: "airplane", origin: lhr, destination: jfk,
               departureTime: date(from: "2026-05-16 09:15"),
               arrivalTime: date(from: "2026-05-16 12:45"),
               flightNumber: "BA 117", price: 62000),
               
        Flight(airline: "Singapore Airlines", logo: "airplane.circle", origin: sin, destination: del,
               departureTime: date(from: "2026-05-17 08:30"),
               arrivalTime: date(from: "2026-05-17 11:45"),
               flightNumber: "SQ 402", price: 24000),
               
        Flight(airline: "Air France", logo: "paperplane.fill", origin: cdg, destination: dxb,
               departureTime: date(from: "2026-05-18 16:00"),
               arrivalTime: date(from: "2026-05-19 01:20"),
               flightNumber: "AF 662", price: 38000),
               
        Flight(airline: "Emirates", logo: "airplane", origin: dxb, destination: jfk,
               departureTime: date(from: "2026-05-19 08:00"),
               arrivalTime: date(from: "2026-05-19 14:15"),
               flightNumber: "EK 201", price: 89000),
               
        Flight(airline: "Vistara", logo: "airplane.departure", origin: del, destination: dxb,
               departureTime: date(from: "2026-05-15 20:45"),
               arrivalTime: date(from: "2026-05-15 23:30"),
               flightNumber: "UK 201", price: 17200),
               
        Flight(airline: "Indigo", logo: "airplane", origin: del, destination: dxb,
               departureTime: date(from: "2026-05-15 05:15"),
               arrivalTime: date(from: "2026-05-15 08:00"),
               flightNumber: "6E 1419", price: 15500),
               
        Flight(airline: "Singapore Airlines", logo: "airplane.circle", origin: jfk, destination: sin,
               departureTime: date(from: "2026-05-20 22:30"),
               arrivalTime: date(from: "2026-05-22 05:15"),
               flightNumber: "SQ 23", price: 110000),
               
        Flight(airline: "British Airways", logo: "airplane", origin: del, destination: lhr,
               departureTime: date(from: "2026-05-16 01:50"),
               arrivalTime: date(from: "2026-05-16 07:00"),
               flightNumber: "BA 256", price: 47500)
    ]
    
    // Generate Sample Seats
    static func generateSeats() -> [Seat] {
        var seats: [Seat] = []
        let columns = ["A", "B", "C", "D"]
        let totalRows = 10 // 40 seats total
        
        for row in 1...totalRows {
            for col in columns {
                // Randomly assign booked status
                let isBooked = Int.random(in: 0...10) > 7 // ~30% booked
                let status: SeatStatus = isBooked ? .booked : .available
                
                let seat = Seat(row: row, column: col, status: status, price: 1500)
                seats.append(seat)
            }
        }
        return seats
    }
}
