import Foundation

struct Flight: Identifiable, Hashable {
    let id = UUID()
    let airline: String
    let logo: String // System image name or asset name
    let origin: Airport
    let destination: Airport
    let departureTime: Date
    let arrivalTime: Date
    let flightNumber: String
    let price: Double
    
    var duration: String {
        let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: departureTime, to: arrivalTime)
        let hours = diffComponents.hour ?? 0
        let minutes = diffComponents.minute ?? 0
        return "\(hours)h \(minutes)m"
    }
    
    var formattedDeparture: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: departureTime)
    }
    
    var formattedArrival: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: arrivalTime)
    }
    
    var formattedPrice: String {
        return String(format: "₹%.0f", price)
    }
}
