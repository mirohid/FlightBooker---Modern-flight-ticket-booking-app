import Foundation
import Combine

class FlightListViewModel: ObservableObject {
    @Published var flights: [Flight] = []
    @Published var isLoading: Bool = true
    @Published var selectedDate: Date = Date()
    @Published var availableDates: [Date] = []
    
    let boarding: String
    let destination: String
    
    init(boarding: String, destination: String) {
        self.boarding = boarding
        self.destination = destination
        generateDateStrip()
        loadFlights()
    }
    
    // Generate next 14 days for date strip
    private func generateDateStrip() {
        let today = Date()
        availableDates = (0..<14).compactMap { day -> Date? in
            Calendar.current.date(byAdding: .day, value: day, to: today)
        }
    }
    
    func loadFlights() {
        isLoading = true
        
        // Simulating network fetch delay (Shimmer effect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            let allFlights = MockData.flights
            let filtered = allFlights.filter { flight in
                flight.origin.code == self.boarding && flight.destination.code == self.destination
            }
            
            if filtered.isEmpty {
                self.flights = allFlights.prefix(5).map { flight in
                    Flight(
                        airline: flight.airline,
                        logo: flight.logo,
                        origin: self.getMockedAirport(code: self.boarding),
                        destination: self.getMockedAirport(code: self.destination),
                        departureTime: self.randomizeTime(for: self.selectedDate, baseTime: flight.departureTime),
                        arrivalTime: self.randomizeTime(for: self.selectedDate, baseTime: flight.arrivalTime),
                        flightNumber: flight.flightNumber,
                        price: flight.price
                    )
                }
            } else {
                self.flights = filtered.map { flight in
                    Flight(
                        airline: flight.airline,
                        logo: flight.logo,
                        origin: flight.origin,
                        destination: flight.destination,
                        departureTime: self.randomizeTime(for: self.selectedDate, baseTime: flight.departureTime),
                        arrivalTime: self.randomizeTime(for: self.selectedDate, baseTime: flight.arrivalTime),
                        flightNumber: flight.flightNumber,
                        price: flight.price
                    )
                }
            }
            
            self.isLoading = false
        }
    }
    
    // Helper to snap mock flight times to the selected date
    private func randomizeTime(for selectedDate: Date, baseTime: Date) -> Date {
        let calendar = Calendar.current
        let valComponents = calendar.dateComponents([.hour, .minute], from: baseTime)
        return calendar.date(bySettingHour: valComponents.hour ?? 0, minute: valComponents.minute ?? 0, second: 0, of: selectedDate) ?? selectedDate
    }
    
    // Sorting Helper
    func sortFlights(by option: SortOption) {
        switch option {
        case .cheapest:
            flights.sort { $0.price < $1.price }
        case .fastest:
            flights.sort { $0.duration < $1.duration }
        case .earliest:
            flights.sort { $0.departureTime < $1.departureTime }
        }
    }
    
    enum SortOption: String, CaseIterable {
        case cheapest = "Cheapest"
        case fastest = "Fastest"
        case earliest = "Earliest"
    }
    
    private func getMockedAirport(code: String) -> Airport {
        if let found = MockData.airports.first(where: { $0.code == code }) {
            return found
        }
        let cityNames: [String: String] = [
            "DEL": "New Delhi", "BOM": "Mumbai", "BLR": "Bangalore",
            "HYD": "Hyderabad", "CCU": "Kolkata", "MAA": "Chennai",
            "GOI": "Goa", "AMD": "Ahmedabad", "PNQ": "Pune",
            "JAI": "Jaipur", "LKO": "Lucknow", "IXC": "Chandigarh"
        ]
        let name = cityNames[code] ?? code + " City"
        return Airport(code: code, city: name, name: "International Airport", country: "India")
    }
}
