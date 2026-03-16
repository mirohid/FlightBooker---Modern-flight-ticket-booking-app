import Foundation
import Combine

enum TripType: String, CaseIterable {
    case oneWay = "One Way"
    case roundTrip = "Round Trip"
}

class FlightSearchViewModel: ObservableObject {
    @Published var tripType: TripType = .oneWay
    
    @Published var boardingAirport: String = "DEL"
    @Published var destinationAirport: String = "DXB"
    
    @Published var departureDate: Date = Date()
    @Published var returnDate: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    
    // Detailed Travellers
    @Published var adults: Int = 1
    @Published var children: Int = 0
    @Published var infants: Int = 0
    
    // Derived passenger count
    var passengerCount: Int {
        return adults + children + infants
    }
    
    @Published var cabinClass: String = "Economy"
    let cabinClasses = ["Economy", "Premium Economy", "Business", "First Class"]
    
    // Derived values
    var isSearchValid: Bool {
        !boardingAirport.isEmpty && !destinationAirport.isEmpty && boardingAirport != destinationAirport && adults > 0
    }
}
