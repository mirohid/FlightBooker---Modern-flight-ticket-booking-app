import Foundation
import Combine

class FlightSearchViewModel: ObservableObject {
    @Published var boardingAirport: String = "DEL"
    @Published var destinationAirport: String = "DXB"
    @Published var departureDate: Date = Date()
    @Published var returnDate: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    @Published var passengerCount: Int = 1
    @Published var cabinClass: String = "Economy"
    
    let cabinClasses = ["Economy", "Premium Economy", "Business", "First Class"]
    
    // Derived values
    var isSearchValid: Bool {
        !boardingAirport.isEmpty && !destinationAirport.isEmpty && boardingAirport != destinationAirport
    }
    
    // Simulate Search
    func searchFlights() -> [Flight] {
        // Return mock data filtered (mock implementation)
        return MockData.flights.filter { flight in
            flight.origin.code == boardingAirport && flight.destination.code == destinationAirport
        }
    }
}
