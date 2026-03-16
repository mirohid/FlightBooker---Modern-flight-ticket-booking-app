import Foundation
import Combine

class FlightListViewModel: ObservableObject {
    @Published var flights: [Flight] = []
    
    let boarding: String
    let destination: String
    
    init(boarding: String, destination: String) {
        self.boarding = boarding
        self.destination = destination
        loadFlights()
    }
    
    private func loadFlights() {
        // Simulating network fetch
        let allFlights = MockData.flights
        
        let filtered = allFlights.filter { flight in
            flight.origin.code == boarding && flight.destination.code == destination
        }
        
        // If not found, generate dynamically based on selection
        if filtered.isEmpty {
            self.flights = allFlights.prefix(5).map { flight in
                Flight(
                    airline: flight.airline,
                    logo: flight.logo,
                    origin: getMockedAirport(code: boarding),
                    destination: getMockedAirport(code: destination),
                    departureTime: flight.departureTime,
                    arrivalTime: flight.arrivalTime,
                    flightNumber: flight.flightNumber,
                    price: flight.price
                )
            }
        } else {
            self.flights = filtered
        }
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
